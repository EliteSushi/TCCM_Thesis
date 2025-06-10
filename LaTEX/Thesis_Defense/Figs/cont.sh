#!/bin/bash
# Modified from http://www.phyast.pitt.edu/~zov1/gnuplot/html/contour.html
# Usage: cont.sh <file> <0|1> <width> <offset>

gawk -v d=$2 -v w=$3 -v os=$4 -v ro=$5 'function abs(x) { return (x>=0?x:-x) }
    {
            if($0~/# Contour/ || $0 ~ /^$/) nr=0;
            if(nr==int(os+w/2) && d==0) {i++; a[i]=$1; b[i]=$2; c[i]=$3; r[i]==0}
            if(nr==int(os+w/2)-1 && d==0) {x = $1; y = $2;}
            if(nr==int(os+w/2)+1 && d==0 && ro==1) r[i]= 180.0*atan2(y-$2, x-$1)/3.14

            if(nr==int(os+w/2) && d==1) print ""
            if(abs(nr-os-w/2)>w/2 && d==1) print $0
            nr++
    }
    END {   if(d==0) {
                    for(j=1;j<=i;j++)
                    printf "set label %d \"{\\\\small %.2f}\" at %g, %g centre front rotate by %d\n", j, c[j], a[j], b[j], r[j]

            }
    }' $1