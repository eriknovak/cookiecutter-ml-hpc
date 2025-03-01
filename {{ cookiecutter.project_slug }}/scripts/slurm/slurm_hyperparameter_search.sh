#!/bin/bash
#SBATCH --job-name=hparam_{{ cookiecutter.project_slug }}
#SBATCH --output=logs/hparam_%j.out
#SBATCH --error=logs/hparam_%j.err
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --gres=gpu:1
#SBATCH --partition=gpu
#SBATCH --array=0-9%2  # Run 10 jobs, max 2 at a time

# Print job information
echo "Running on host: $(hostname)"
echo "Job ID: $SLURM_JOB_ID, Array Task ID: $SLURM_ARRAY_TASK_ID"
echo "Start time: $(date)"

# Load modules and activate environment
source $HOME/miniconda/bin/activate
conda activate {{ cookiecutter.project_slug }}

# Create logs directory if it doesn't exist
mkdir -p logs

# Define hyperparameter sets
case $SLURM_ARRAY_TASK_ID in
    0) LR=1e-3; BATCH=16; ;;
    1) LR=1e-3; BATCH=32; ;;
    2) LR=1e-3; BATCH=64; ;;
    3) LR=5e-4; BATCH=16; ;;
    4) LR=5e-4; BATCH=32; ;;
    5) LR=5e-4; BATCH=64; ;;
    6) LR=1e-4; BATCH=16; ;;
    7) LR=1e-4; BATCH=32; ;;
    8) LR=1e-4; BATCH=64; ;;
    9) LR=2e-5; BATCH=32; ;;
    *) echo "Invalid task ID"; exit 1; ;;
esac

# Run the training script with specific hyperparameters
python -m src.pipelines.model_training \
  --data_path data/processed/training_data.csv \
  --model_type transformer \
  --output_dir models/hparam_${SLURM_ARRAY_TASK_ID}_$(date +%Y%m%d_%H%M%S) \
  --batch_size $BATCH \
  --epochs 5 \
  --learning_rate $LR

echo "End time: $(date)"