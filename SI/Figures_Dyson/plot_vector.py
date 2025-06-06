from pymol import cmd
from pymol.cgo import CYLINDER, CONE

def draw_vector(vector, origin=(0,0,0), name='arrow', color='splitpea', radius=0.08, cone_ratio=2.0):
    """
    Draws a vector as an arrow in PyMOL.

    Parameters:
    - vector: tuple of three floats (vx, vy, vz) representing the vector components.
    - origin: tuple of three floats (ox, oy, oz) representing the starting point (default: (0,0,0)).
    - name: name of the PyMOL object (default: 'arrow').
    - color: color of the arrow (default: 'red').
    - radius: radius of the arrow shaft (default: 0.2).
    - cone_ratio: factor to adjust cone size relative to the shaft (default: 2.0).
    """
    ox, oy, oz = origin
    vx, vy, vz = vector
    end = (ox + vx, oy + vy, oz + vz)  # Vector endpoint

    # Adjust cone size based on shaft radius
    cone_radius = radius * cone_ratio  # Cone should be wider than the shaft
    cone_length = cone_radius * 2  # Cone length should be 1.5 times its radius
    cone_tip = (end[0] + (vx / (vx**2 + vy**2 + vz**2)**0.5) * cone_length,
                end[1] + (vy / (vx**2 + vy**2 + vz**2)**0.5) * cone_length,
                end[2] + (vz / (vx**2 + vy**2 + vz**2)**0.5) * cone_length)  # Cone tip in vector direction

    arrow = [
        # Cylinder for the shaft
        CYLINDER, ox, oy, oz, *end, radius, *cmd.get_color_tuple(color), *cmd.get_color_tuple(color),
        
        # Cone for the arrowhead
        CONE, *end, *cone_tip, cone_radius, 0.0,
        *cmd.get_color_tuple(color), *cmd.get_color_tuple(color),1,1
    ]

    cmd.load_cgo(arrow, name)

# Example Usage in PyMOL
cmd.extend('draw_vector', draw_vector)

