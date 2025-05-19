#!/bin/bash
#SBATCH -p gpu
#SBATCH --mem=16g
#SBATCH -o log
#SBATCH --gres=gpu:a4000:1 

# Run the jobs
./mlfold3_01.sif python /opt/alphafold3/run_alphafold_custom.py --fasta input.fasta --ligand CCD_HEM --ligand "N(C(=O)CCc1ccc(cc1)N(=O)=O)OCc1ccccc1" --run_data_pipeline=false --output_dir $TMPDIR
./mlfold3_01.sif python /opt/alphafold3/run_alphafold_custom.py --fasta input2.fasta --ligand CCD_HEM --ligand "N(C(=O)CCc1ccc(cc1)N(=O)=O)OCc1ccccc1" --run_data_pipeline=false --output_dir $TMPDIR

echo ">>> $TMPDIR"
# === Archive all output ===
ARCHIVE_NAME="job_${SLURM_JOB_ID}_output.tar.gz"
ARCHIVE_PATH="$SLURM_SUBMIT_DIR/$ARCHIVE_NAME"

echo ">>> Archiving all output to $ARCHIVE_PATH"

# List of files to include in archive
FILES_TO_ARCHIVE=$(find "$TMPDIR" -maxdepth 1 -type f )
DIRS_TO_ARCHIVE=$(find "$TMPDIR" -mindepth 1 -maxdepth 1 -type d)


echo "Arch dirs $DIRS_TO_ARCHIVE"
# Create archive
tar -czf "$ARCHIVE_PATH" $FILES_TO_ARCHIVE $DIRS_TO_ARCHIVE

