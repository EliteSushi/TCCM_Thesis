for i in 181 262 349 360 6 73 90; do
    outfile="Q0_${i}.png"
    
    # Extract coordinates
    tail -n +$(($i*25+1)) grid_aligned.xyz | head -n 25 > temp.xyz
    awk 'NR==2 {$0=""} 1' temp.xyz > temp && mv temp temp.xyz
    read X Y Z <<< $(tail -n +$(($i*25+2)) grid_aligned.xyz | head -n 1 | awk '{print $3, $4, $5}')

    cat > pymol_commands.pml <<EOF
load temp.xyz
run plot_vector.py
@pymol_style
draw_vector(($X, $Y, $Z))
zoom temp
view_matrix = (\
     0.875036061,   -0.133025810,    0.465419233,\
     0.460026950,    0.527716100,   -0.714064538,\
    -0.150619984,    0.838938355,    0.522966981,\
     0.000000000,    0.000000000,  -22.721105576,\
     0.453396559,   -0.686841965,   -0.001283288,\
  -10810.000976562, 10855.443359375,  -20.000000000 )
cmd.set_view(view_matrix)
ray
png $outfile, dpi=300
quit
EOF

    # Run PyMOL
    pymol -c pymol_commands.pml
done

