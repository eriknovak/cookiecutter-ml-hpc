#!/bin/bash
# setup_env.sh - Setup the development environment

set -e  # Exit immediately if a command exits with a non-zero status

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up development environment...${NC}"

# Define environment name
ENV_NAME={{ cookiecutter.project_slug }}

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo -e "${RED}Conda is not installed. Please install Miniconda or Anaconda and try again.${NC}"
    exit 1
fi

# Create conda environment
echo -e "${GREEN}Creating conda environment...${NC}"
if ! conda env list | grep -q "^${ENV_NAME} "; then
    conda create -n $ENV_NAME python={{ cookiecutter.python_version }} -y
    echo "Conda environment created: $ENV_NAME"
else
    echo "Conda environment already exists: $ENV_NAME"
fi

# Activate conda environment
echo -e "${GREEN}Activating conda environment...${NC}"
# Use source to work within the current script
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate $ENV_NAME

# Upgrade pip
echo -e "${GREEN}Upgrading pip...${NC}"
pip install --upgrade pip

# Install project in development mode
echo -e "${GREEN}Installing project in development mode...${NC}"
pip install -e .[dev]
pip install jupyter_contrib_nbextensions

if command -v git &> /dev/null; then
    # Check if git repository is initialized
    if [ -d ".git" ]; then
        # Setup git filter for Jupyter notebooks
        echo -e "${GREEN}Setting up git filter for Jupyter notebooks...${NC}"
        git config filter.strip-notebook-output.clean 'jupyter nbconvert --ClearOutputPreprocessor.enabled=True --to=notebook --stdin --stdout --log-level=ERROR'
    else
        echo -e "${YELLOW}Git repository not initialized. Skipping git filter setup.${NC}"
        echo -e "${YELLOW}Run 'git init' to initialize a git repository.${NC}"
    fi
fi

# Create necessary directories if they don't exist
echo -e "${GREEN}Creating data directories...${NC}"
mkdir -p storage/data/raw storage/data/processed storage/data/final storage/data/external

# Success message
echo -e "${GREEN}Environment setup complete!${NC}"
echo "To activate the conda environment, run:"
echo -e "  ${YELLOW}conda activate $ENV_NAME${NC}"

# Deactivate conda environment
conda deactivate