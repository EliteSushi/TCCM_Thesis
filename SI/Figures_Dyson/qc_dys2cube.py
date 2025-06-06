import argparse
import numpy as np
import os
from pyscf import gto, tools

def read_nwchem_basis(filename):
    basis_dict = {}
    with open(filename, 'r') as f:
        lines = f.readlines()

    current_block = []
    current_atom = None
    collecting = False

    for line in lines:
        stripped = line.strip()

        # Skip empty lines when not collecting
        if not stripped and not collecting:
            continue

        # When we hit a comment or END, process the current block
        if stripped.startswith('#') or stripped == 'END':
            if current_atom and current_block:
                block_text = '\n'.join(current_block)
                try:
                    # Parse the block and store under the current atom
                    basis_dict[current_atom] = gto.basis.parse(block_text)
                except Exception as e:
                    print(f"Error parsing basis for {current_atom}: {e}")
                    print(f"Problematic block:\n{block_text}")
            current_block = []
            current_atom = None
            collecting = False
            continue

        if not collecting:
            # Look for the atom label at the start of a line
            tokens = stripped.split()
            if tokens:  # if line is not empty
                current_atom = tokens[0]
                collecting = True
                current_block.append(stripped)
        else:
            current_block.append(stripped)

    return basis_dict

def parse_qchem_output(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    # --- Parse geometry ---
    geometry = []
    for i, line in enumerate(lines):
        if 'Standard Nuclear Orientation' in line:
            start = i + 3
            while True:
                l = lines[start].strip()
                if not l or '----' in l:
                    break
                parts = l.split()
                atom = parts[1]
                x, y, z = map(float, parts[2:5])
                geometry.append((atom, x, y, z))
                start += 1
            break
    
    # --- Parse Dyson orbital coefficients ---
    dyson_orbitals = []
    for i, line in enumerate(lines):
        if 'Decomposition over AOs for the right beta Dyson orbital' in line:
            coeffs = []
            j = i + 1
            while True:
                l = lines[j].strip()
                if not l or '*****' in l:
                    break
                coeffs.append(float(l))
                j += 1
            dyson_orbitals.append(coeffs)  # Moved outside the inner while loop
    
    return geometry, dyson_orbitals

def build_molecule(geometry, basis_dict):
    atom_str = '\n'.join([f'{sym} {x} {y} {z}' for sym, x, y, z in geometry])
    mol = gto.Mole()
    mol.verbose = 0 
    mol.atom = atom_str
    mol.unit = 'Angstrom'
    mol.basis = basis_dict
    mol.build()
    
    # Check if all needed atoms are present
    print("\nAtoms in molecule:", set([a[0] for a in geometry]))
    # Debug by printing basis information
    print("PySCF Basis Summary:")
    if isinstance(basis_dict, dict):
        for atom, basis in basis_dict.items():
            print(f"{atom}: {len(basis)} functions")
    else:
        print(f"Using PySCF basis: {basis_dict}")
    
    return mol 


def main():
    parser = argparse.ArgumentParser(description='Convert Dyson orbitals from Q-Chem output to a .cube file.')
    parser.add_argument('-i', '--input', required=True, help='Q-Chem output file with Dyson orbital')
    parser.add_argument('-o', '--output', help='Output .cube file')
    parser.add_argument('-f', '--basis_file', default='/Users/mauro/scripts/NWChem_aug-cc-pVDZ+6s3p.basis',
                        help='NWChem-style basis set file (default: %(default)s)')
    parser.add_argument('-b', '--basis', default=None, help='Basis set name for PySCF (e.g., cc-pVDZ). If not provided, use basis file.')
    parser.add_argument('-n', '--npoints', type=int, default=100, help='Number of grid points in each direction')
    parser.add_argument('-l', '--box_l', type=float, default=25.0, help='Margin (in Bohr) to add to the box')

    args = parser.parse_args()
    if not args.output:
        args.output = f"{os.path.splitext(args.input)[0]}.cube"

    print("Reading geometry and Dyson coefficients from Q-Chem output...")
    geometry, dyson_orbitals = parse_qchem_output(args.input)

    # Handle basis set selection
    if args.basis is None:
        print(f"Reading basis set from {args.basis_file} ...")
        basis_dict = read_nwchem_basis(args.basis_file)
    else:
        print(f"Using PySCF basis set '{args.basis}'")
        basis_dict = args.basis

    print("Building molecule with PySCF...")
    mol = build_molecule(geometry, basis_dict)

    # Check number of basis functions
    if mol.nao_nr() != len(dyson_orbitals[0]):
        raise ValueError(f"Number of basis functions ({mol.nao_nr()}) does not match Dyson coefficients ({len(dyson_orbitals[0])})")

    for i, coeffs in enumerate(dyson_orbitals):
        if len(dyson_orbitals) > 1:
            output_file = f"{os.path.splitext(args.output)[0]}_{i+1}.cube"
        else:
            output_file = args.output
    
        print(f"Writing Dyson orbital {i+1} cube file to {output_file}...")
        tools.cubegen.orbital(mol, output_file, coeffs, nx=args.npoints, ny=args.npoints, nz=args.npoints, margin=args.box_l)

    print("Done.")


if __name__ == '__main__':
    main()

