set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
########(generate a jpeg file.)
set terminal jpeg      
set output  "approx_timeBB10M.jpg"
set title "BB: Average Time vs. P-value(rounding maximum fractional value)"
set xlabel "p-value"
set ylabel "Average Time BB(in second)"
plot "timeLPBB10M.txt" with lines, "timeIPBB10M.txt" with lines, "timeIRBB10M.txt" with lines, "timeBB10M.txt" with lines
#pause -1 "Hit any key to continue"
