require "./src/kakurasu"

cols = ARGV[0...(ARGV.size / 2)].map { |arg| arg == "-" ? nil : arg.to_i }
rows = ARGV[(ARGV.size / 2)..-1].map { |arg| arg == "-" ? nil : arg.to_i }

Kakurasu.new(cols, rows, verbose: true).solve
