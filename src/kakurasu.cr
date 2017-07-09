def powerset(items)
  (0...2**items.size).map { |bits|
    items.each_with_index.select { |(e, i)|
      bits & (1 << i) != 0
    }.map { |(e, i)| e }.to_a
  }
end

class Kakurasu
  alias Cell = Tuple(UInt32, UInt32)

  @cells_left : UInt32
  @cell_width : UInt32
  @left_width : UInt32

  def initialize(@cols : Array(Int32?), @rows : Array(Int32?), @verbose : Bool = false)
    @states = Array(Array(Bool?)).new(@rows.size) { Array(Bool?).new(@cols.size, nil) }
    @change = Array(Array(Bool)).new(@rows.size) { Array(Bool).new(@cols.size, false) }
    @cell_width = @cols.map { |c| c ? c.to_s.size : 1 }.max.to_u32
    @left_width = @rows.map { |c| c ? c.to_s.size : 1 }.max.to_u32
    @cells_left = (@cols.size * @rows.size).to_u32
  end

  def solve
    until @cells_left == 0
      infer(@cols, "Col", ->(n : UInt32) { @states.map { |s| s[n] } }, ->(mine : UInt32, theirs : UInt32) { {theirs, mine} })
      infer(@rows, "Row", ->(n : UInt32) { @states[n] }, ->(mine : UInt32, theirs : UInt32) { {mine, theirs} })
    end

    @states.map(&.dup).to_a
  end

  def to_s
    header = (" " * (@left_width + 1)) + @cols.map { |c| "%#{@cell_width}s" % (c || '-') }.join(" ")
    header + "\n" + @rows.zip(@states).map_with_index { |(n, row), y|
      ("%#{@left_width}s " % (n || '-')) + row.map_with_index { |c, x|
        colour, mark =
          case c
          when true ; {32, 'X'}
          when false; {31, '.'}
          else        {0, '?'}
          end
        "\e[#{@change[y][x] ? 1 : 0};#{colour}m#{"%#{@cell_width}s" % mark}\e[0m"
      }.join(" ")
    }.join("\n")
  end

  private def infer(group : Array(Int32?), name : String, states : UInt32 -> Array(Bool?), coord : UInt32, UInt32 -> Cell)
    group.each_with_index { |n, my_index|
      next unless n

      my_index = my_index.to_u32
      my_states = states.call(my_index)

      target = n
      candidates = [] of Int32
      my_states.each_with_index { |cs, i|
        candidates << i + 1 if cs.nil?
        target -= i + 1 if cs
      }

      possible = powerset(candidates).select { |p| p.sum == target }
      in_every = possible.reduce(candidates) { |a, b| a & b }
      in_none = candidates - possible.reduce([] of Int32) { |a, b| a | b }

      next if in_every.empty? && in_none.empty?

      puts "#{name} #{my_index} (#{n}): possible (#{possible.size}) #{possible}. In every: #{in_every}, in none: #{in_none}" if @verbose

      in_every.each { |x| self[coord.call(my_index, x.to_u32 - 1)] = true }
      in_none.each { |x| self[coord.call(my_index, x.to_u32 - 1)] = false }

      if @verbose
        puts self.to_s
        # Don't need to bother clearing change if not verbose.
        @change.each { |c| c.fill(false) }
      end
    }
  end

  private def []=(c : Cell, v : Bool)
    y, x = c
    current_value = @states[y][x]
    if current_value.nil?
      @cells_left -= 1
      @change[y][x] = true
    elsif v != current_value
      raise "#{v} conflicts with #{current_value} at #{y}, #{x}"
    end
    @states[y][x] = v
  end
end
