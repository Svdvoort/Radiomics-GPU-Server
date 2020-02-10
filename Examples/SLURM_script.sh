#!/bin/bash
#SBATCH --ntasks=6
#SBATCH --mem=14G
#SBATCH --gres=gpu:Quadro:1
#SBATCH -p GPU
#SBATCH -t 01:00:00
#SBATCH -o /path/to/out/out_%j.log
#SBATCH -e /path/to/out/error_%j.log

# This is the temporary dir for your job on the SSD
# It will be deleted once your job finishes so don't forget to copy your files!
MY_TMP_DIR=/slurmtmp/${SLURM_JOB_USER}.${SLURM_JOB_ID}

# Move your data to the folder
mv <path/to/your/data/> ${MY_TMP_DIR}

# Load the modules
module purge
module load python/3.6.7
module load tensorflow/1.12.0

echo "Hello world"
