set key bmargin left horizontal Right noreverse enhanced autotitles box linetype -1 linewidth 1.000
########(generate a jpeg file.)
set terminal jpeg      
set output  "approx_ratioBB10F.jpg"    

set title "BB:Average Approx Ratio vs. P-value(rounding first fractional value)"
set xlabel "p-value"
set ylabel "Average Approx Ratio BB"
plot "approxIR1LP10F.txt" with lines, "approxBBLP10F.txt" with lines,"approxIR1BB10F.txt" with lines, "highestIR1LP10F.txt" with lines, "highestBBLP10F.txt" with lines, "highestIR1BB10F.txt" with lines

#pause -1 "Hit any key to continue"
