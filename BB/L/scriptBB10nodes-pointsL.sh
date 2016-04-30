set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
########(generate a jpeg file.)
set terminal jpeg      
set output  "nodes_pointsBB10L.jpg"

set title "BB:Average number of points & nodes vs p-value(rounding Last fractional value)"
set xlabel "p-value"
set ylabel "average number of nodes & points"
plot "numberofnodesL.txt" with lines, "numberofpointsL.txt" with lines

#pause -1 "Hit any key to continue"b
