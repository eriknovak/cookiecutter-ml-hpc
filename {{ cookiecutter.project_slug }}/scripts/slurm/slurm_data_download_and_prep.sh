#!/bin/bash
#SBATCH --job-name=data-prep_{{ cookiecutter.project_slug }}
#SBATCH --output=logs/data-prep_%j.out
#SBATCH --error=logs/data-prep_%j.err
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --partition=cpu

# Print job information
echo "Running on host: $(hostname)"
echo "Job ID: $SLURM_JOB_ID"
echo "Start time: $(date)"

# Load modules and activate environment
source $HOME/miniconda/bin/activate
conda activate {{ cookiecutter.project_slug }}

# Create logs directory if it doesn't exist
mkdir -p logs

# Run data download and preparation script
python -m src.pipelines.data_download \
  --output_dir data/raw \
  --dataset_name imagenet \
  "$@"

python -m src.pipelines.data_processing \
  --input_path data/raw \
  --output_path data/processed \
  --split_ratio 0.2 \
  --seed 42

echo "End time: $(date)"