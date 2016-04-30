set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
########(generate a jpeg file.)
set terminal jpeg      
set output  "approx_ratioBB10M.jpg"

set title "BB:Average Approx Ratio vs. P-value(rounding maximum fractional value)"
set xlabel "p-value"
set ylabel "Average Approx Ratio BB"
plot "approxIR1LP10M.txt" with lines, "approxBBLP10M.txt" with lines,"approxIR1BB10M.txt" with lines, "highestIR1LP10M.txt" with lines, "highestBBLP10M.txt" with lines, "highestIR1BB10M.txt" with lines

#pause -1 "Hit any key to continue"
