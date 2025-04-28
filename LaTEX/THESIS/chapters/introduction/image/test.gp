set terminal cairolatex size 3.2,3
set output 'test.tex'

set xlabel '$x$'
set ylabel '$y$'
set yrange [-1.5:1.5]

plot sin(x) w l t '$\sin(x)$' lw 4, \
     cos(x) w l t '$\cos(x)$' lw 4, \
     tan(x) w l t '$\tan(x)$' lw 4

unset output