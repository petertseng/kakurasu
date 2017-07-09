# Kakurasu

[![Build Status](https://travis-ci.org/petertseng/kakurasu.svg?branch=master)](https://travis-ci.org/petertseng/kakurasu)

A simple Kakurasu solver.

Just iterates all columns/rows looking for subsets.

I got tired of doing these by hand.

A good source of Kakurasu puzzles is http://www.janko.at/Raetsel/Kakurasu.

# Usage

`kakurasu.cr` assumes the board is square (this assumption is not present in the code) and takes the first half of ARGV as the column sums, and the second half of ARGV as the row sums. Use `-` for undefined.

```
$ crystal build --release kakurasu.cr
$ ./kakurasu 5 6 1 2 3 7 1 2
Col 1 (6): possible (2) [[1, 2, 3], [2, 4]]. In every: [2], in none: []
  5 6 1 2
3 ? ? ? ?
7 ? X ? ?
1 ? ? ? ?
2 ? ? ? ?
Col 2 (1): possible (1) [[1]]. In every: [1], in none: [2, 3, 4]
  5 6 1 2
3 ? ? X ?
7 ? X . ?
1 ? ? . ?
2 ? ? . ?
Col 3 (2): possible (1) [[2]]. In every: [2], in none: [1, 3, 4]
  5 6 1 2
3 ? ? X .
7 ? X . X
1 ? ? . .
2 ? ? . .
Row 0 (3): possible (1) [[]]. In every: [], in none: [1, 2]
  5 6 1 2
3 . . X .
7 ? X . X
1 ? ? . .
2 ? ? . .
Row 1 (7): possible (1) [[1]]. In every: [1], in none: []
  5 6 1 2
3 . . X .
7 X X . X
1 ? ? . .
2 ? ? . .
Row 2 (1): possible (1) [[1]]. In every: [1], in none: [2]
  5 6 1 2
3 . . X .
7 X X . X
1 X . . .
2 ? ? . .
Row 3 (2): possible (1) [[2]]. In every: [2], in none: [1]
  5 6 1 2
3 . . X .
7 X X . X
1 X . . .
2 . X . .
```

# Future directions

* Instead of scanning all rows + all columns each time, only scan where anything changed in the last pass (is speedup worth the extra code?).
* Initially, could immediately eliminate large values for the small sums (speedup probably not worth the extra code?).
* Allow non-square boards in ARGV (the code probably already allows it).
