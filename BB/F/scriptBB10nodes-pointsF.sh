set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
########(generate a jpeg file.)
set terminal jpeg      
set output  "nodes_pointsBB10F.jpg"

set title "BB:Average number of points & nodes vs p-value(rounding first fractional value)"
set xlabel "p-value"
set ylabel "average number of nodes & points"
plot "numberofnodesF.txt" with lines, "numberofpointsF.txt" with lines

#pause -1 "Hit any key to continue"b
