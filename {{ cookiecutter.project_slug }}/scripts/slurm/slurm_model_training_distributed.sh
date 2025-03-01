#!/bin/bash
#SBATCH --job-name=dist-model-training_{{ cookiecutter.project_slug }}
#SBATCH --output=logs/dist-model-training_%j.out
#SBATCH --error=logs/dist-model-training_%j.err
#SBATCH --time=24:00:00
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --gpus-per-node=4
#SBATCH --partition=gpu

# Print job information
echo "Running on hosts: $(scontrol show hostname $SLURM_JOB_NODELIST)"
echo "Job ID: $SLURM_JOB_ID"
echo "Start time: $(date)"

# Load modules and activate environment
source $HOME/miniconda/bin/activate
conda activate {{ cookiecutter.project_slug }}

# Create logs directory if it doesn't exist
mkdir -p logs

# Get the master node's address
MASTER_ADDR=$(scontrol show hostnames $SLURM_JOB_NODELIST | head -n 1)
MASTER_PORT=29500

# Run distributed training
srun python -m src.pipelines.distributed_training \
  --data_path data/processed/training_data.csv \
  --model_type transformer \
  --output_dir models/dist_$(date +%Y%m%d_%H%M%S) \
  --batch_size 64 \
  --epochs 10 \
  --learning_rate 5e-5 \
  --master_addr $MASTER_ADDR \
  --master_port $MASTER_PORT

echo "End time: $(date)"