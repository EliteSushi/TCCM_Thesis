import numpy as np
import argparse

def align_structure(start, vector, length):
    # Define the water molecule structure
    atoms = np.array(["O", "H", "H"])
    coords = np.array([
        [0.0000000, 0.0000000, 0.1653507],
        [0.7493682, 0.0000000, -0.4424329],
        [-0.7493682, 0.0000000, -0.4424329]
    ])
    
    # Use Oxigen instead of center of mass
    #com = np.mean(coords, axis=0)
    com = coords[0]
    coords -= com  # Center molecule at origin
    
    # Align the H-H vector with the x-axis
    h_vector = coords[1] - coords[2]
    h_vector /= np.linalg.norm(h_vector)
    x_axis = np.array([1, 0, 0])
    v = np.cross(h_vector, x_axis)
    c = np.dot(h_vector, x_axis)
    s = np.linalg.norm(v)
    
    if s == 0:
        rot_matrix_hh = np.eye(3)
    else:
        vx = np.array([[0, -v[2], v[1]], [v[2], 0, -v[0]], [-v[1], v[0], 0]])
        rot_matrix_hh = np.eye(3) + vx + vx @ vx * ((1 - c) / (s ** 2))
    
    coords = coords @ rot_matrix_hh.T  # Apply H-H alignment

    # Align the z-axis of the molecule to the given vector
    z_axis = np.array([0, 0, 1])
    vector /= np.linalg.norm(vector)
    v = np.cross(z_axis, vector)
    c = np.dot(z_axis, vector)
    s = np.linalg.norm(v)
    
    if s == 0:
        rot_matrix_z = np.eye(3)
    else:
        vx = np.array([[0, -v[2], v[1]], [v[2], 0, -v[0]], [-v[1], v[0], 0]])
        rot_matrix_z = np.eye(3) + vx + vx @ vx * ((1 - c) / (s ** 2))
    
    coords = coords @ rot_matrix_z.T  # Apply z-axis alignment
    
    # Compute new center of mass position along the given vector
    new_com = start + length * vector
    
    # Translate structure to new position
    final_coords = coords + new_com
    
    # Print the aligned structure to standard output
    for atom, (x, y, z) in zip(atoms, final_coords):
        print(f"{atom} {x:.6f} {y:.6f} {z:.6f}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Align a molecular structure along a given vector and position it at a specific distance from a point.")
    parser.add_argument("-p","--point", nargs=3, type=float, default=(0, 0, 0), help="Starting point coordinates (x, y, z)")
    parser.add_argument("-v","--vector", nargs=3, type=float, default=(1, 1, 1), help="Direction vector (x, y, z)")
    parser.add_argument("-l","--length", type=float, default=1, help="Distance from the starting point")
    
    args = parser.parse_args()
    
    start = np.array(args.point)
    vector = np.array(args.vector)
    length = args.length
    
    align_structure(start, vector, length)
