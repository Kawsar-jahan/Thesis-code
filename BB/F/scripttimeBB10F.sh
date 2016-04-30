set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
########(generate a jpeg file.)
set terminal jpeg      
set output  "approx_timeBB10F.jpg"
set title "BB: Average Time vs. P-value for 10x10x10(rounding first fractional value)"
set xlabel "p-value"
set ylabel "Average Time BB(in second)"
plot "timeLPBB10F.txt" with lines, "timeIPBB10F.txt" with lines, "timeIRBB10F.txt" with lines, "timeBB10F.txt" with lines
#pause -1 "Hit any key to continue"
