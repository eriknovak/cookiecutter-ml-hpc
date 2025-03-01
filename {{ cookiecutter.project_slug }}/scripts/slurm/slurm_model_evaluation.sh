#!/bin/bash
#SBATCH --job-name=model-evaluation_{{ cookiecutter.project_slug }}
#SBATCH --output=logs/model-evaluation_%j.out
#SBATCH --error=logs/model-evaluation_%j.err
#SBATCH --time=06:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --gres=gpu:1
#SBATCH --partition=gpu

# Print job information
echo "Running on host: $(hostname)"
echo "Job ID: $SLURM_JOB_ID"
echo "Start time: $(date)"

# Load modules and activate environment
source $HOME/miniconda/bin/activate
conda activate {{ cookiecutter.project_slug }}

# Create logs directory if it doesn't exist
mkdir -p logs

# Run the evaluation script
python -m src.pipelines.model_evaluate \
  --model_path models/MODEL_TIMESTAMP \
  --test_data data/processed/test_data.csv \
  --output_dir results/$(date +%Y%m%d_%H%M%S) \
  "$@"

echo "End time: $(date)"