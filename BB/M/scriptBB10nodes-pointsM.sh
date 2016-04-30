set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
########(generate a jpeg file.)
set terminal jpeg      
set output  "nodes_pointsBB10M.jpg"

set title "BB:Avg number of points & nodes vs p-value(rounding maximum fractional value)"
set xlabel "p-value"
set ylabel "average number of nodes & points"
plot "numberofnodesM.txt" with lines, "numberofpointsM.txt" with lines

#pause -1 "Hit any key to continue"b
