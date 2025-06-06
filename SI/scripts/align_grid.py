#!/usr/bin/env python3
import numpy as np

def rotation_matrix_from_axis_angle(axis, theta):
    """
    Return the rotation matrix associated with counterclockwise rotation about
    the given axis by theta radians using the Rodrigues formula.
    """
    axis = axis / np.linalg.norm(axis)
    K = np.array([[    0,     -axis[2],  axis[1]],
                  [ axis[2],      0,    -axis[0]],
                  [-axis[1],  axis[0],      0]])
    return np.eye(3) + np.sin(theta)*K + (1 - np.cos(theta))*(K @ K)

def align_structure(coords):
    """
    Given an array coords of shape (N,3) for a structure, perform:
      1. Translation so that atom 1 (index 0) is at (0,0,0)
      2. Rotation so that the plane defined by atoms 1, 3, and 5 (indices 0,2,4)
         becomes the xy plane.
      3. Rotation about z so that the vector from atom 1 to atom 2 (index 1)
         lies along the x axis.
    Returns the new coordinates and the overall rotation matrix.
    """
    # Step 1. Translate so that atom 1 is at the origin.
    translated = coords - coords[0]

    # Step 2. Rotate so that the plane through atoms 1,3,5 becomes the xy plane.
    # Since atom 1 is at the origin, we use atoms 3 and 5:
    v3 = translated[2]   # atom 3 (index 2)
    v5 = translated[4]   # atom 5 (index 4)
    normal = np.cross(v3, v5)  # normal to the plane
    norm_normal = np.linalg.norm(normal)
    if norm_normal < 1e-8:
        R1 = np.eye(3)
    else:
        normal_unit = normal / norm_normal
        target = np.array([0, 0, 1])  # we want the normal to become this
        # Compute the axis and angle to rotate normal_unit onto target.
        axis = np.cross(normal_unit, target)
        if np.linalg.norm(axis) < 1e-8:
            # They are already parallel (or anti-parallel)
            if np.dot(normal_unit, target) < 0:
                # 180° rotation: choose any axis perpendicular to normal_unit.
                axis = np.cross(normal_unit, np.array([1, 0, 0]))
                if np.linalg.norm(axis) < 1e-8:
                    axis = np.cross(normal_unit, np.array([0, 1, 0]))
                axis = axis / np.linalg.norm(axis)
                theta = np.pi
            else:
                theta = 0.0
        else:
            axis = axis / np.linalg.norm(axis)
            theta = np.arccos(np.clip(np.dot(normal_unit, target), -1.0, 1.0))
        R1 = rotation_matrix_from_axis_angle(axis, theta)
    rotated1 = (R1 @ translated.T).T

    # Step 3. Rotate about the z-axis so that the vector from atom 1 to atom 6 lies along the x-axis.
    atom2 = rotated1[5]  # after the first rotation
    # Get the projection onto the xy plane:
    atom2_xy = np.array([atom2[0], atom2[1]])
    angle = np.arctan2(atom2_xy[1], atom2_xy[0])
    # We want to rotate by -angle so that atom2 lies along x.
    cos_angle = np.cos(-angle)
    sin_angle = np.sin(-angle)
    Rz = np.array([[cos_angle, -sin_angle, 0],
                   [sin_angle,  cos_angle, 0],
                   [0,              0,     1]])
    rotated2 = (Rz @ rotated1.T).T
    # Overall rotation matrix (applied after translation):
    R_total = Rz @ R1
    return rotated2, R_total

def transform_dipole(dipole, R_total):
    """
    Apply the rotation to the dipole vector.
    """
    return R_total @ dipole

def process_xyz(input_filename, output_filename):
    """
    Process the input XYZ file (with concatenated structures) and write an output
    file with molecules realigned so that:
      - Atom 1 is at the origin.
      - The plane defined by atoms 1,3,5 is the xy plane.
      - The vector from atom 1 to atom 2 lies along the x-axis.
    The comment line is updated by rotating the dipole components.
    """
    with open(input_filename, 'r') as f:
        lines = f.readlines()

    i = 0
    output_lines = []
    while i < len(lines):
        # Skip any blank lines.
        if lines[i].strip() == "":
            i += 1
            continue

        # The first line of a structure is the number of atoms.
        try:
            natoms = int(lines[i].strip())
        except ValueError:
            print(f"Error reading number of atoms in line: {lines[i]}")
            break

        # The next line is the comment line. Expected format:
        # structure_number energy dipole_x dipole_y dipole_z dipole_magnitude
        comment_line = lines[i+1].strip()
        comment_parts = comment_line.split()
        if len(comment_parts) < 6:
            print(f"Comment line does not have expected 6 fields: {comment_line}")
            break
        structure_number = comment_parts[0]
        energy = comment_parts[1]
        dipole = np.array([float(comment_parts[2]),
                           float(comment_parts[3]),
                           float(comment_parts[4])])
        # (We will recalc the dipole magnitude after rotation.)

        # Read the atom lines.
        atoms = []
        coords_list = []
        for j in range(natoms):
            parts = lines[i+2+j].strip().split()
            atoms.append(parts[0])
            coords_list.append([float(parts[1]),
                                float(parts[2]),
                                float(parts[3])])
        coords = np.array(coords_list)

        # Get the rotated coordinates and overall rotation matrix.
        new_coords, R_total = align_structure(coords)
        # Rotate the dipole vector.
        new_dipole = transform_dipole(dipole, R_total)
        new_dipole_magnitude = np.linalg.norm(new_dipole)

        # Build the new comment line.
        new_comment = f"{structure_number} {energy} " \
                      f"{new_dipole[0]:.6f} {new_dipole[1]:.6f} {new_dipole[2]:.6f} {new_dipole_magnitude:.6f}"
        output_lines.append(f"{natoms}\n")
        output_lines.append(new_comment + "\n")
        for label, coord in zip(atoms, new_coords):
            output_lines.append(f"{label} {coord[0]:.6f} {coord[1]:.6f} {coord[2]:.6f}\n")

        # Advance to the next structure.
        i += 2 + natoms

    with open(output_filename, 'w') as f_out:
        f_out.writelines(output_lines)

if __name__ == "__main__":
    process_xyz("grid.xyz", "grid_aligned_Q1.xyz")

