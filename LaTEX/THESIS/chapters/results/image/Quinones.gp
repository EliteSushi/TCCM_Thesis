$data << EOD
1	2.02	1.54	1.64
2	1.95	-	1.57
3	1.89	1.39	1.49
4	1.89	1.40	1.5
5	1.84	1.34	1.43
6	1.83	1.32	1.42
7	1.65	1.17	1.32
8	1.88	1.39	1.5
9	1.97	-	1.55
10	1.92	1.45	1.51
11   -   -  1.10
12   -   -  1.65
EOD

set terminal cairolatex size 2.55,2.35
set output 'Quinones.tex'
set xrange [1.3:1.65]
set yrange [1.1:2.1]

set xlabel 'Reference Energy (eV)'
set ylabel 'Method Energy (eV)'
set key bottom right

plot $data using 4:4 with lines linecolor rgb 'gray' linewidth 6 title '', \
     '' using 4:2:(sprintf("{\\\\color{blue}\\\\textbf{%d}}", $1)) with labels offset 0,0.2 notitle, \
     '' using 4:3:(sprintf("{\\\\color{red}\\\\textbf{%d}}", $1))  with labels offset 0,-0.2 notitle, \
     NaN with lines linecolor rgb 'gray' linewidth 5 title 'Ref.', \
     NaN with lines linecolor rgb 'blue' linewidth 5 title 'No SCS', \
     NaN with lines linecolor rgb 'red'  linewidth 5 title 'SCS'

unset output
