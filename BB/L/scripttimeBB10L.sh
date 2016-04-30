set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
########(generate a jpeg file.)
set terminal jpeg      
set output  "approx_timeBB10L.jpg"
set title "BB: Average Time vs. P-value(rounding last fractional value)"
set xlabel "p-value"
set ylabel "Average Time BB (in second)"
plot "timeLPBB10L.txt" with lines, "timeIPBB10L.txt" with lines, "timeIRBB10L.txt" with lines, "timeBB10L.txt" with lines
#pause -1 "Hit any key to continue"
