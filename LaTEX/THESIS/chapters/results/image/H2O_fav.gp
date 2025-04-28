$data << EOD
"Distance (\r{A})"	'Interaction E'	'VBA'	'DBA'
2	114473.9229	115313.833	114441.6928
4	-9.734513843	-549.4393587	-1.434511954
6	-54.09165579	-231.6546452	-81.47023975
8	-5.699843009	-101.3326981	-51.80469478
10	0.028188295	-59.27545622	-45.30279824
12	0.781838171	-38.95817004	-38.0311971
15	0.663248134	-23.1874693	-28.07633888
20	0.207424399	-11.40040984	-16.73206073
30	0.069563243	-2.91338395	-5.15852375
40	0	0	0
EOD
#Check this data from excel

set terminal cairolatex size 5,2
set output 'H2O_fav.tex'

set xlabel 'Distance (\r{A})'
set ylabel 'Energy (eV)'
set yrange [-100:10]
set arrow from 0,0 to 40,0 nohead lc rgb "gray" lw 4
set key bottom right

plot $data u 1:2 w l t 'Interaction E' lw 4, \
     $data u 1:3 w l t 'VBA' lw 4, \
     $data u 1:4 w l t 'DBA' lw 4

unset output
