#!/bin/bash
# Step 5: Molecular docking with AutoDock Vina
# Target: Hexamita Cathepsin B (AlphaFold model AF-A0AA86UFS0)
# Active site coordinates from fpocket analysis

RECEPTOR_PDB=~/biyoinfo/proje1/results/AF-A0AA86UFS0-F1-model_v6.pdb
OUT_DIR=~/biyoinfo/proje1/results

# Binding site identification
fpocket -f $RECEPTOR_PDB

# Convert receptor to PDBQT
obabel $RECEPTOR_PDB \
  -O $OUT_DIR/receptor.pdbqt \
  -xr

# Download cysteine protease inhibitors from PubChem
for cid in 9576072 5311272 16760208 3025762 44450571 51049604; do
  wget -q "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/${cid}/SDF?record_type=3d" \
    -O ~/biyoinfo/proje1/data/compound_${cid}.sdf
  obabel ~/biyoinfo/proje1/data/compound_${cid}.sdf \
    -O ~/biyoinfo/proje1/data/compound_${cid}.pdbqt \
    --gen3d
done

# Vina configuration
cat > ~/biyoinfo/proje1/data/vina_config.txt << CONFIG
receptor = $OUT_DIR/receptor.pdbqt
center_x = 6.372
center_y = 10.014
center_z = 8.918
size_x = 30
size_y = 30
size_z = 30
exhaustiveness = 32
num_modes = 9
energy_range = 3
CONFIG

# Run docking for each compound
mkdir -p $OUT_DIR/docking
for cid in 9576072 5311272 16760208 3025762 44450571 51049604; do
  vina \
    --config ~/biyoinfo/proje1/data/vina_config.txt \
    --ligand ~/biyoinfo/proje1/data/compound_${cid}.pdbqt \
    --out $OUT_DIR/docking/cid${cid}_docked.pdbqt
done

# PLIP interaction analysis (best candidate: Balicatib)
plip -f $OUT_DIR/docking/complex_clean.pdb \
     -o $OUT_DIR/docking/plip_output \
     -t
