# Cookiecutter ML-HPC

A comprehensive cookiecutter template for machine learning projects for running on high-performance computing (HPC) clusters using the SLURM system.

## Overview

This template provides a structured foundation for machine learning projects that are designed to run on high-performance computing (HPC) clusters.
It includes a set of best practices for organizing your project, examples for scripts for running on the compute notes and creating reproducible workflows.

## Features

- **Organized project structure** following ML best practices
- **Reproducible workflows** using Python virtual environments
- **SLURM scripts** for running on HPC clusters
- **Documentation** for project setup and usage

## Requirements

- [uv][uv]. For setting up the environment and Python dependencies.
- [Cookiecutter][cookiecutter]. For setting up the project structure.
- [Git][git]. For versioning your code.

## Usage

### Installing uv

To use this template, we suggest using [uv] to manage your Python environment.
You will need to install [uv] if you haven't already. To do this, you can run the following commands:

```bash
# Download and install
curl -LsSf https://astral.sh/uv/install.sh | sh
```

For changes to take effect, you might need to restart your shell or run the following command:

```bash
source $HOME/.bashrc
```

### Creating a New Project

Before creating a new project, you will need to make a new python environment and activate Python version is 3.10 or higher:

```bash
# Create new environment using uv
uv venv --python 3.10
# Activate the new environment
source .venv/bin/activate
# Check the Python version
python --version
```

To create a new project, run the following commands:

```bash
# install pipx for running cookiecutter
uv pip install pipx
# create a new project using the template
pipx run cookiecutter gh:eriknovak/cookiecutter-ml-hpc
```

You'll be prompted for inputs to customize your project:

- `project_name`: Name of your project
- `project_description`: Brief description of your project
- `version`: Initial version (default: 0.1.0)
- `python_version`: Python version (default: 3.10)
- `author_name`: Your name
- `author_email`: Your email
- ... and more configurable options

Afterwards, follow the README within the created project for further instructions.

### Git Init

After creating the project, initialize a new Git repository and commit the initial project structure:

```bash
cd <project_name>
git init
git add .
git commit -m "Initial commit"
```

You can then push the repository to your remote git server. After that, you can start developing your project.

## Acknowledgments

Inspired by the [cookiecutter] project structure.

[uv]: https://docs.astral.sh/uv/
[cookiecutter]: https://github.com/cookiecutter/cookiecutter
[git]: https://git-scm.com/