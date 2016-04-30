set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
########(generate a jpeg file.)
set terminal jpeg      
set output  "approx_ratioBB10L.jpg"
set title "BB:Average Approx Ratio vs. P-value(rounding last fractional value)"
set xlabel "p-value"
set ylabel "Average Approx Ratio BB"
plot "approxIR1LP10L.txt" with lines, "approxBBLP10L.txt" with lines,"approxIR1BB10L.txt" with lines, "highestIR1LP10L.txt" with lines, "highestBBLP10L.txt" with lines, "highestIR1BB10L.txt" with lines

#pause -1 "Hit any key to continue"
