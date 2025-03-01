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
- [Conda][conda]. For setting up the environment and Python dependencies.
- [Cookiecutter][cookiecutter]. For setting up the project structure.
- [Git][git]. For versioning your code.

## Usage

### Installing Conda

To use this template, we suggest using [conda] to manage your Python environment.
You will need to install [conda] if you haven't already. To do this, you can run the following commands:

```bash
# download the installer
curl -LO https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# install Miniconda in your home directory (recommended)
bash Miniconda3-latest-Linux-x86_64.sh -u -p $HOME/miniconda
# remove the installer
rm Miniconda3-latest-Linux-x86_64.sh
```

For changes to take effect, you will need to restart your shell or run the following command:

```bash
source $HOME/.bashrc
```

#### Initializing Conda

During the installation, the conda initialization script was added to your shell configuration file (e.g., `.bashrc`). However, this is not always desirable. Setting conda to be activated at startup will often slow down your shell startup time.

To activate conda automatically at startup, run the following command (change the shell to your shell of choice):

```bash
conda init bash
```

To disable the automatic activation, run the following command (change the shell to your shell of choice):

```bash
conda init --reverse bash
```

If you prefer that conda's base environment is not activated at startup, run the following command when conda is activated:

```bash
conda config --set auto_activate_base false
```

To activate conda, run the following command:

```bash
source $HOME/miniconda/bin/activate
```

To deactivate conda, run the following command:

```bash
conda deactivate
```

### Creating a New Project

Before creating a new project, make sure that conda is activated and that the activate Python version is 3.10 or higher:

```bash
# activate conda
source $HOME/miniconda/bin/activate
# check the Python version
python --version
```

To create a new project, run the following commands:

```bash
# install pipx for running cookiecutter
pip install pipx
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


# Acknowledgments

Inspired by the [cookiecutter] project structure.

[conda]: https://docs.conda.io/en/latest/
[cookiecutter]: https://github.com/cookiecutter/cookiecutter
[git]: https://git-scm.com/