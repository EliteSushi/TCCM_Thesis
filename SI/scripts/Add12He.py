import sys
import numpy as np

def read_xyz(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    num_atoms = int(lines[0].strip())
    atoms = []
    for line in lines[2:num_atoms+2]:
        parts = line.split()
        atoms.append((parts[0], np.array([float(parts[1]), float(parts[2]), float(parts[3])])))
    return atoms

def compute_center_of_mass(atoms):
    masses = {
        'H': 1.008, 'He': 4.0026, 'Li': 6.94, 'Be': 9.0122, 'B': 10.81, 'C': 12.011,
        'N': 14.007, 'O': 15.999, 'F': 18.998, 'Ne': 20.180, 'Na': 22.990, 'Mg': 24.305,
        'Al': 26.982, 'Si': 28.085, 'P': 30.974, 'S': 32.06, 'Cl': 35.45, 'Ar': 39.948
    }
    total_mass = 0.0
    center_of_mass = np.zeros(3)
    for atom, position in atoms:
        mass = masses.get(atom, 12.0)  # Default to 12.0 if element is unknown (carbon mass)
        total_mass += mass
        center_of_mass += mass * position
    return center_of_mass / total_mass if total_mass > 0 else np.zeros(3)

def generate_icosahedron_vertices(radius):
    phi = (1 + np.sqrt(5)) / 2  # Golden ratio
    a = radius / np.sqrt(1 + phi**2)
    b = a * phi
    vertices = [
        (0, -a, -b), (0, a, -b), (0, -a, b), (0, a, b),
        (-a, -b, 0), (a, -b, 0), (-a, b, 0), (a, b, 0),
        (-b, 0, -a), (b, 0, -a), (-b, 0, a), (b, 0, a)
    ]
    return np.array(vertices)

def main():
    if len(sys.argv) != 3:
        print("Usage: python Add12He.py input.xyz radius")
        sys.exit(1)
    
    xyz_filename = sys.argv[1]
    radius = float(sys.argv[2])
    
    atoms = read_xyz(xyz_filename)
    center_of_mass = compute_center_of_mass(atoms)
    icosahedron_vertices = generate_icosahedron_vertices(radius)
    
    # Print new XYZ file
    num_original_atoms = len(atoms)
    num_new_atoms = len(icosahedron_vertices)
    print(num_original_atoms + num_new_atoms)
    print(xyz_filename+" plus He icosahedron of radius "+str(radius))
    
    for atom, position in atoms:
        print(f"{atom} {position[0]:.6f} {position[1]:.6f} {position[2]:.6f}")
    
    for vertex in icosahedron_vertices:
        position = center_of_mass + vertex
        print(f"He {position[0]:.6f} {position[1]:.6f} {position[2]:.6f}")
    
if __name__ == "__main__":
    main()
