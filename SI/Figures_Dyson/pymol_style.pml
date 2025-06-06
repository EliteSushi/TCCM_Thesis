#From here: https://pymolwiki.org/index.php/Gallery
# PLot orbitals: https://github.com/felixplasser/qc_pymol/tree/master
run /Users/mauro/Projects/qc_pymol/qc_pymol/dens_plot.py
add_H, all
show sticks
show spheres
set stick_radius, .07
set sphere_scale, .18
set sphere_scale, .13, elem H
set bg_rgb=[1, 1, 1]
set stick_quality, 50
set sphere_quality, 4
color gray85, elem C
color red, elem O
color slate, elem N
color gray98, elem H
set stick_color, black
set ray_trace_mode, 1
set ray_texture, 2
set antialias, 3
set ambient, 0.5
set spec_count, 5
set shininess, 50
set specular, 1
set reflect, .1
set dash_gap, 0
set dash_color, black
set dash_gap, .15
set dash_length, .05
set dash_round_ends, 0
set dash_radius, .05
set transparency, 0.4

#ray settings
# === PyMOL Orbital Flat Shading Template ===

# Disable reflections and specular highlights
set spec_power, 0.0
set spec_reflect, 0.0
set shininess, 0.0
set reflect, 0.0

# Disable shadows entirely
set ray_shadow, 0
set ray_shadow_decay_factor, 0.0
set ray_shadow_decay_range, 0.0

# Disable textures and interior shading effects
set ray_texture, 0
set ray_interior_mode, 0
set ray_interior_reflect, 0.0
set ray_interior_shadows, off
set ray_transparency_specular, 0.0
set ray_transparency_shadows, off
set ray_transparency_oblique, 0.0
set ray_transparency_oblique_power, 0.0

# Flatten lighting and diffuse shading
set ray_direct_shade, 0.0
set ray_legacy_lighting, 0.0
set power, 1.0
set gamma, 1.0

# Disable color blending artifacts
set ray_blend_colors, off

# Control anti-aliasing (adjust if necessary)
set antialias, 1  # 0 = off, 1 = adaptive AA

# Optional: remove fog and gain effects
set ray_trace_gain, 0.0
set ray_trace_fog, 0.0
set ray_trace_fog_start, 0.0


