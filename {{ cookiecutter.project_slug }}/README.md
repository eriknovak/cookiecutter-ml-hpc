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
├── data/              # Data storage (local / used for smaller files)
├── docs/              # Documentation assets
├── logs/              # Logs
├── models/            # Model storage (local / used for smaller files)
├── notebooks/         # Notebooks for data analysis
├── results/           # Experiment results
├── scripts/           # Scripts for setup and running locally
├── slurm/             # Scripts for running on slurm
├── src/               # Source code
├── .env.example       # Environment variables example
├── .gitignore         # Git ignore config
├── Makefile           # Makefile with project commands
├── LICENSE            # License
├── README.md          # Project readme
├── RESULTS.md         # Results documentation
├── SLURM.md           # SLURM documentation
├── TROUBLESHOOT.toml  # Troubleshoot advices
├── pyproject.toml     # The project config
└── requirements.txt   # Project dependencies
```

## ☑️ Requirements

Before starting the project make sure these requirements are available:

- [uv]. For setting up the environment and Python dependencies.
- [git]. For versioning your code.

## 🛠️ Setup

## Initialize the environment file

If you have any environment variables, make a copy of the `.env.example`
and name it `.env`. Add all required environment variables into that file.

### Automatic setup

To setup the project, run the following commands:

```bash
make setup
```

This script will:

1. Create a virtual environment and store it in `.venv`
2. Install all required dependencies including dev dependencies
3. Create the local folder structure stored in `data` folder

### Manual setup

If you prefer to set up the project manually, follow the instructions below.

#### Create a python virtual environment

First, create a virtual environment where all the modules will be stored.
We prefer using [uv], a fast Python package and project manager.

To setup the virtual environment run the following commands:

```bash
# Create a new conda environment
uv venv --python {{ cookiecutter.python_version }}

# Activate the environment
source .venv/bin/activate
```

#### Install dependencies

Check the `requirements.txt` file. If you have any additional requirements, add
them here. Afterwards, install the dependencies:

```bash
# Install the dependencies in development mode
uv pip install -e .[dev]
```

#### Create data directories

The data should be stored in a separate data node available in the HPC. To get
access to the data folder, as the HPC maintainers to create one.

```bash
mkdir -p data/raw data/interim data/final data/external
```

### Environment management

To activate/deactivate the environment environment, use the following commands:

```bash
# Activate the environment
source .venv/bin/activate

# Deactivate the environment
deactivate
```

## 🗃️ Data & Model Storage

Storing the data and models on a HPC cluster is a bit different than on a local
machine. There are various locations where the data can be stored, most notably:

- The login node where each user is given a limited amount of storage space.
- The shared storage where the data is stored centrally and accessible to all
  users (within a given user group).

To get access to the shared storage, you need to contact the HPC administrators
to set up the shared storage for you. Furthermore, ask them for the location of
the shared storage and how to access it.

Once this is done, you can move the data to the shared storage by using different
protocols, like for example `scp` or `rsync`.

> [!WARNING]
> Once the shared data storage is setup, make sure all scripts are accessing the
> data from the correct location, i.e., the shared storage.

### Local data storage

> [!WARNING]
> The local data storage is not suitable for storing large datasets. Use the
> shared storage for large datasets.

The local data storage is located in the `data/` directory.
The data is divided into the following subdirectories:

- `raw/`: Raw data that is not modified in any way.
- `interim/`: Data that is in interim state and ready for training.
- `final/`: Final data that is used for training and evaluation.
- `external/`: External data that is not stored in the repository.

## ⚗️ Experiments

This project includes several SLURM scripts for running machine learning
experiments on HPC clusters.

### Running SLURM jobs

To run an experiment on the HPC cluster, you must submit a SLURM job script[^1].

All SLURM job scripts are located in the `slurm/` directory. An overview
of SLURM commands is found in [SLURM.md](./SLURM.md).

#### Checking GPU availability

To check if the scripts have access to GPUs on the SLURM machine, you can run:

```bash
# Submits a job for running nvidia-smi on the allocated nodes (4 GPUs)
# The resource information available is then shown in the logs folder
sbatch slurm/nvidia_smi.sh
```

The command will allocate 4 GPUs and execute the nvidia-smi command, storing the
results into the `/logs` folder. It might take some time, depending on the HPC
availability.

#### Running experiments

This project focuses on named entity recognition model training and evaluation
using HPC and [unsloth]. The SLURM script to execute is the following:

```bash
# Submits a job for training and evaluating the LLM NER model
# All training parameters are customizable and editable in the script
# The process logs will be found in the logs/ folder
# The experiment results will be present in the results/ folder
sbatch slurm/train_eval_model_unsloth.sh
```

### Data analysis with `marimo`

We are using [marimo], a package for generating notebooks, that are stored as
Git-friendly Python.

All notebooks are stored in the `/notebooks` folder. To edit a notebook in an
interactive way, execute the following command:

```bash
marimo edit notebooks/{name-of-file}.py
```

This will open the browser, where you can edit and analyze the data.

> [!NOTE] marimo vs jupyter notebook
> Data analysis is used using the `marimo` package instead of `jupyter notebooks`.
> We prefer `marimo` as it saves the cells in a python-like structure (using decorator),
> making it less confusing for AI for Coding. In addition, when executing cells,
> the files are not updated in full, but rather only those cells that are being updated.

## 📊 Results

The results of the experiments are stored in the `results/` directory. However,
the actual datasets and models produced by the experiments, which are usually quite
big, should be stored in the shared data storage (prepared by the HPC admins).

## 📣 Acknowledgments

TODO: Acknowledgements


[uv]: https://docs.astral.sh/uv/
[cookiecutter]: https://drivendata.github.io/cookiecutter-data-science/
[git]: https://git-scm.com/
[marimo]: https://docs.marimo.io/

[^1]: For more information on SLURM, see the [official documentation](https://slurm.schedmd.com/) or a [comprehensive overview](https://doc.sling.si/en/navodila/slurm/) on how to create the SLURM scripts provided by the mainteners of [SLING](https://www.sling.si/en/).