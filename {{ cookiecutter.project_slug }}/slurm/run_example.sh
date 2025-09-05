#!/bin/bash
#SBATCH --job-name=TNERUNEMC                      # Name of the job
#SBATCH --account=s25r04-01-users                 # Account name
#SBATCH --output=logs/train-model-unsloth-%j.out  # Standard output file (%j = job ID)
#SBATCH --error=logs/train-model-unsloth-%j.out   # Standard error file (same as output file) (change to .err if you want to separate the output and error logs)
#SBATCH --time=02:00:00                           # Time limit (format: HH:MM:SS)
#SBATCH --partition=gpu                           # Partition (queue) to use
#SBATCH --gres=gpu:1                              # Number of GPUs per node
#SBATCH --nodes=1                                 # Number of nodes to allocate
#SBATCH --ntasks=1                                # Total number of tasks (processes)
#SBATCH --ntasks-per-node=1                       # Number of tasks per node
#SBATCH --cpus-per-task=8                         # Number of CPU cores per task

set -e # exit on error

echo "Loading the environment variables..."
source $HOME/{{ cookiecutter.project_slug }}/.env

echo "# ==============================================="
echo "# Job information"
echo "# ==============================================="
echo ""

export MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_PORT=50202

# Print some information about the job
echo "Running on host: $(hostname)"
echo "MASTER_ADDR:MASTER_PORT="${MASTER_ADDR}:${MASTER_PORT}
echo "SLURM_JOB_ID=${SLURM_JOB_ID}"
echo "NODELIST="${SLURM_NODELIST}
echo "Current working directory: $(pwd)"
echo "Start time: $(date)"
echo ""


echo "# ==============================================="
echo "# Make sure GPU is available"
echo "# ==============================================="
echo ""

# Print GPU info for debugging
echo "CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES}"
nvidia-smi

echo ""

# ===============================================
# Load the dataset directory parameters
# ===============================================

# Storage directories
BASE_STORAGE_DIR=/ceph/hpc/data/
BASE_PROJECT_DIR=/ceph/hpc/home/[username]

# ===============================================
# Export the environment variables
# ==============================================

# Hugging Face cache (set them to a place where you have enough space)
export HF_HOME=$BASE_STORAGE_DIR/huggingface
export HUGGINGFACE_HUB_CACHE=$BASE_STORAGE_DIR/huggingface/hub
export HF_HUB_CACHE=$BASE_STORAGE_DIR/huggingface/hub

# Create the directories if they don't exist
mkdir -p $HF_HOME
mkdir -p $HUGGINGFACE_HUB_CACHE
mkdir -p $HF_HUB_CACHE

# ===============================================
# Load the experiment parameters
# ===============================================
# Model parameters

MODEL_NAME=[model-name]

# ===============================================
# Prepare the training and output directories
# ===============================================

echo "# ==============================================="
echo "# Parameters"
echo "# ==============================================="
echo ""
echo "MODEL_NAME=${MODEL_NAME}"
echo ""


echo "================================================"
echo "Training the model..."
echo "================================================"
echo ""

uv run python -B src/training/example.py

# Print end time
echo ""
echo "End time: $(date)"
