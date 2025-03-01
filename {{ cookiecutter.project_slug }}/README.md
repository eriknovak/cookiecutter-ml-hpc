# {{ cookiecutter.project_name }}

[![Python Version](https://img.shields.io/badge/python-{{ cookiecutter.python_version }}-orange.svg)](https://www.python.org/downloads/)
[![CCDS Project](https://img.shields.io/badge/CCDS-Project%20template-orange?logo=cookiecutter)](https://github.com/eriknovak/cookiecutter-ml-hpc/)
[![SLURM Compatible](https://img.shields.io/badge/scheduler-SLURM-brightgreen.svg)](https://slurm.schedmd.com/)
[![HPC Ready](https://img.shields.io/badge/HPC-ready-orange.svg)](https://github.com/eriknovak/cookiecutter-ml-hpc/)


{{ cookiecutter.project_description }}

Inspired by the [cookiecutter] folder structure. The template contains scripts for running experiments on the HPC clusters, specifically using the SLURM scheduler.

## 📁 Project Structure

The project is structured as follows:

```plaintext
.
├── storage/                 # Data and model storage (local / used for smaller files)
├── notebooks/               # Jupyter notebooks
├── results/                 # Experiment results
├── scripts/                 # Helper scripts
├── src/                     # Source code
├── logs/                    # Logs
├── tests/                   # Tests
├── .gitignore               # Git ignore config
├── Makefile                 # Makefile with project commands
├── LICENSE                  # License
├── README.md                # Project readme
├── pyproject.toml           # The project config
└── requirements.txt         # Project dependencies
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

Check the `requirements.txt` file. If you have any additional requirements, add them here.

Afterwards, install the dependencies:

```bash
# install the dependencies in development mode
pip install -e .[dev]
# install the jupyter notebook extensions (optional)
pip install jupyter_contrib_nbextensions
```

#### Set up git filter for Jupyter notebooks (optional)

To avoid commiting outputs in notebooks that should not be commited, run the following command:

```bash
git config filter.strip-notebook-output.clean 'jupyter nbconvert --ClearOutputPreprocessor.enabled=True --to=notebook --stdin --stdout --log-level=ERROR'
```

#### Create data directories

Create the necessary data directories:

```bash
mkdir -p data/raw data/processed data/final data/external
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

Storing the data and models on a HPC cluster is a bit different than on a local machine. There
are various locations where the data can be stored, most notably:

- The login node where each user is given a limited amount of storage space.
- The shared storage where the data is stored centrally and accessible to all users (within a given user group).

To get access to the shared storage, you need to contact the HPC administrators to set up the shared storage for you.
Furthermore, ask them for the location of the shared storage and how to access it.

Once this is done, you can move the data to the shared storage by using different protocols, like for example `scp` or `rsync`.

> [!WARNING]
> Once the shared data storage is setup, make sure all scripts are accessing the data from the correct location, i.e., the shared storage.

### Local data storage

> [!WARNING]
> The local data storage is not suitable for storing large datasets. Use the shared storage for large datasets.

The local data storage is located in the `data/` directory. The data is divided into the following subdirectories:

- `raw/`: Raw data that is not modified in any way.
- `processed/`: Data that is preprocessed and ready for training.
- `final/`: Final data that is used for training and evaluation.
- `external/`: External data that is not stored in the repository.


## ⚙️ Configuration

Project parameters are stored in [params.yaml](params.yaml):

- **Common parameters**: Dataset name, random seed, etc.
- **Model parameters**: Learning rates, batch sizes, etc.

To modify parameters, edit the `params.yaml` file.

## ⚗️ Experiments

This project includes several SLURM scripts for running machine learning experiments on HPC clusters.

### Running SLURM jobs

To run an experiment on the HPC cluster, you must submit a SLURM job script[^1].

All SLURM job scripts are located in the `scripts/slurm/` directory. To submit a job, use the `sbatch` command:

```bash
sbatch scripts/slurm/<script_name>.sh [additional arguments]
```

### Monitoring jobs

To monitor your active jobs, use the following commands:

```bash
# View all your jobs
squeue -u $USER

# View detailed information about a specific job
scontrol show job <job_id>

# Monitor job output in real-time
tail -f slurm_logs/<job_id>.out
```

### Canceling jobs

To cancel a job, use the `scancel` command:

```bash
# Cancel a specific job
scancel <job_id>

# Cancel all your jobs
scancel -u $USER
```

## 📊 Results

The results of the experiments are stored in the `results/` directory.

### Managing experiment results

After running experiments, use the provided utility to track and compare results:

```bash
python scripts/experiment_tracker.py --results_dir results/ --output experiment_summary.csv
```

This will generate a CSV file with metrics from all experiments for easy comparison.


## 📣 Acknowledgments

TODO: Acknowledgements


[conda]: https://docs.conda.io/en/latest/
[cookiecutter]: https://drivendata.github.io/cookiecutter-data-science/
[git]: https://git-scm.com/

[^1]: For more information on SLURM, see the [official documentation](https://slurm.schedmd.com/) or a [comprehensive overview](https://doc.sling.si/en/navodila/slurm/) on how to create the SLURM scripts provided by the mainteners of [SLING](https://www.sling.si/en/).