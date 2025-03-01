#!/bin/bash
#SBATCH --job-name=template_{{ cookiecutter.project_slug }}
#SBATCH --output=logs/template_%j.out
#SBATCH --error=logs/template_%j.err
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --partition=regular

# Print some information about the job
echo "Running on host: $(hostname)"
echo "Current working directory: $(pwd)"
echo "Start time: $(date)"

# Load modules or activate conda environment
source $HOME/miniconda/bin/activate
conda activate {{ cookiecutter.project_slug }}

# Create logs directory if it doesn't exist
mkdir -p logs

# Run the command
echo "Command to run: $@"
$@

# Print end time
echo "End time: $(date)"