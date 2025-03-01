#!/bin/bash
#SBATCH --job-name=download-datasets            # Name of the job
#SBATCH --output=logs/download-datasets-%j.out  # Standard output file (%j = job ID)
#SBATCH --error=logs/download-datasets-%j.err   # Standard error file
#SBATCH --time=01:00:00                         # Time limit (format: HH:MM:SS)
#SBATCH --partition=cpu                         # Partition (queue) to use
#SBATCH --nodes=1                               # Number of nodes to allocate
#SBATCH --ntasks=1                              # Total number of tasks (processes)
#SBATCH --ntasks-per-node=1                     # Number of tasks per node
#SBATCH --cpus-per-task=8                       # Number of CPU cores per task

# Load modules or activate conda environment
source $HOME/miniconda/bin/activate
conda activate {{ cookiecutter.project_slug }}

export MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_PORT=50202

# Print some information about the job
echo "Running on host: $(hostname)"
echo "MASTER_ADDR:MASTER_PORT="${MASTER_ADDR}:${MASTER_PORT}
echo "NODELIST="${SLURM_NODELIST}
echo "Current working directory: $(pwd)"
echo "Start time: $(date)"

echo "Downloading datasets"
# get the data directory from the params.yaml file
BASE_DATA_DIR=$(yq ".dataset.path" params.yaml)

# TODO: set the dataset directory
DATASET_DIR=$BASE_DATA_DIR/[TODO: dataset name]

# create the dataset directory
mkdir -p $DATASET_DIR
# TODO: download the dataset from the url
curl --remote-name-all [TODO: URL]
# unzip the datasets
unzip [TODO: ZIP_FILE] -d $DATASET_DIR
# remove the zip file
rm [TODO: ZIP_FILE]

echo "Files in $DATASET_DIR:"
ls -la $DATASET_DIR

# Print end time
echo "End time: $(date)"