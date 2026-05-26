# PyMOL visualization script for Figure 1
# Renders Balicatib docked into Hexamita Cathepsin B active site

reinitialize
load complex_clean.pdb

bg_color white
hide everything

# Protein as transparent cartoon
show cartoon, polymer
color grey90, polymer
set cartoon_transparency, 0.5

# Ligand as yellow sticks
show sticks, organic
color yellow, organic
util.cnc organic

# Active site residues
select active_site, resi 56+126+137+144 and polymer and not name N+C+O+H
show sticks, active_site
color cyan, active_site
util.cnc active_site

# Labels
label resi 56 and name CZ, "PHE56"
label resi 126 and name CG, "ASP126"
label resi 137 and name OH, "TYR137"
label resi 144 and name CZ, "PHE144"

set label_size, 24
set label_color, black

zoom organic, 5
orient organic

set ray_opaque_background, on
set ray_shadows, 0
set antialias, 2

ray 2400, 1800
png figure1_docking.png, dpi=300
