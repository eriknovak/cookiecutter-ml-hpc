# {{ cookiecutter.project_name }}

[![Python Version](https://img.shields.io/badge/python-{{ cookiecutter.python_version }}-orange.svg)](https://www.python.org/downloads/)
[![CCDS Project](https://img.shields.io/badge/CCDS-Project%20template-orange?logo=cookiecutter)](https://github.com/eriknovak/cookiecutter-ml-hpc/)
[![SLURM Compatible](https://img.shields.io/badge/scheduler-SLURM-brightgreen.svg)](https://slurm.schedmd.com/)
[![HPC Ready](https://img.shields.io/badge/HPC-ready-orange.svg)](https://github.com/eriknovak/cookiecutter-ml-hpc/)


{{ cookiecutter.project_description }}

Inspired by the [cookiecutter] folder structure. The template contains scripts
for running experiments on the HPC clusters, specifically using the SLURM scheduler.

## 📁 Project Structure

The project is structured as follows:

```plaintext
.
├── logs/              # Logs
├── results/           # Experiment results
├── scripts/           # Helper scripts
├── src/               # Source code
├── storage/           # Data and model storage (local / used for smaller files)
├── tests/             # Tests
├── .gitignore         # Git ignore config
├── Makefile           # Makefile with project commands
├── LICENSE            # License
├── README.md          # Project readme
├── pyproject.toml     # The project config
└── requirements.txt   # Project dependencies
```

## ☑️ Requirements

Before starting the project make sure these requirements are available:

- [conda]. For setting up the environment and Python dependencies.
- [git]. For versioning your code.

## 🛠️ Setup

### Automatic setup

To setup the project, run the following commands:

```bash
bash scripts/setup_env.sh
```

This script will:

1. Create a conda environment named `{{ cookiecutter.project_slug }}`
2. Install all required dependencies including dev dependencies
3. Set up the git filter for Jupyter notebooks
4. Create necessary data directories


### Manual setup

If you prefer to set up the project manually, follow the instructions below.

#### Create a conda environment

First, create a conda environment where all the modules will be stored.

```bash
# Create a new conda environment
conda create -n {{ cookiecutter.project_slug }} python={{ cookiecutter.python_version }} -y

# Activate the environment
conda activate {{ cookiecutter.project_slug }}

# Upgrade pip
pip install --upgrade pip
```

#### Install dependencies

Check the `requirements.txt` file. If you have any additional requirements, add
them here.

Afterwards, install the dependencies:

```bash
# install the dependencies in development mode
pip install -e .[dev]
```

#### Create data directories

The data should be stored in a separate data node available in the HPC. To get
access to the data folder, as the HPC maintainers to create one.

```bash
mkdir -p storage/data/raw storage/data/processed storage/data/final storage/data/external
```

### Environment management

To activate/deactivate the conda environment, use the following commands:

```bash
# Activate the environment
conda activate {{ cookiecutter.project_slug }}

# Deactivate the environment
conda deactivate
```

## 🗃️ Data & Model Storage

Storing the data and models on a HPC cluster is a bit different than on a local
machine. There are various locations where the data can be stored, most notably:

- The login node where each user is given a limited amount of storage space.
- The shared storage where the data is stored centrally and accessible to all
  users (within a given user group).

To get access to the shared storage, you need to contact the HPC administrators
to set up the shared storage for you.
Furthermore, ask them for the location of the shared storage and how to access it.

Once this is done, you can move the data to the shared storage by using different
protocols, like for example `scp` or `rsync`.

> [!WARNING]
> Once the shared data storage is setup, make sure all scripts are accessing the data from the correct location, i.e., the shared storage.

### Local data storage

> [!WARNING]
> The local data storage is not suitable for storing large datasets. Use the shared storage for large datasets.

The local data storage is located in the `storage/data/` directory.
The data is divided into the following subdirectories:

- `raw/`: Raw data that is not modified in any way.
- `processed/`: Data that is preprocessed and ready for training.
- `final/`: Final data that is used for training and evaluation.
- `external/`: External data that is not stored in the repository.

## ⚗️ Experiments

This project includes several SLURM scripts for running machine learning
experiments on HPC clusters.

### Logging with wandb

The project's default experiment monitoring is via the [wandb] package and service.
To initialize it, one must first login through the [wandb] service to get access
to the generated API key, and the execute the following command:

```bash
# make sure the conda environment is activate
conda activate {{ cookiecutter.project_slug }}

# login into wandb - it will prompt you for the API key
wandb login
```

Once wandb is configured, it will send the monitored parameters, metrics and
artifacts to your wandb profile.

### Running SLURM jobs

To run an experiment on the HPC cluster, you must submit a SLURM job script[^1].

All SLURM job scripts are located in the `scripts/slurm/` directory. An overview
of SLURM commands is found in [SLURM.md](./SLURM.md).

As an example, to submit a SLURM job, you can run:

```bash
# submits a job for running nvidia-smi on the allocated nodes (4 GPUs)
# the resource information available is then shown in the logs folder
sbatch scripts/slurm/nvidia_smi.sh
```

The command will allocate 4 GPUs and execute the nvidia-smi command, storing the
results into the `/logs` folder. It might take some time, depending on the HPC
availability.

## 📊 Results

The results of the experiments are stored in the `results/` directory. However,
the actual datasets and models produced by the experiments, which are usually quote
big, should be stored in the shared data storage (prepared by the HPC admins).

## 📣 Acknowledgments

TODO: Acknowledgements


[conda]: https://docs.conda.io/en/latest/
[cookiecutter]: https://drivendata.github.io/cookiecutter-data-science/
[git]: https://git-scm.com/
[wandb]: https://wandb.ai/site/

[^1]: For more information on SLURM, see the [official documentation](https://slurm.schedmd.com/) or a [comprehensive overview](https://doc.sling.si/en/navodila/slurm/) on how to create the SLURM scripts provided by the mainteners of [SLING](https://www.sling.si/en/).