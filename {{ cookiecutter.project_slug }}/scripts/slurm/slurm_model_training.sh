#!/bin/bash
#SBATCH --job-name=model-training_{{ cookiecutter.project_slug }}
#SBATCH --output=logs/model-training_%j.out
#SBATCH --error=logs/model-training_%j.err
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
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

# Run the training script with parameters
python -m src.pipelines.model_training \
  --data_path data/processed/training_data.csv \
  --model_type transformer \
  --output_dir models/$(date +%Y%m%d_%H%M%S) \
  --batch_size 32 \
  --epochs 10 \
  --learning_rate 2e-5 \
  "$@"

echo "End time: $(date)"