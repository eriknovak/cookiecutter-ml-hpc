# Troubleshoot

## Make sure the system is using the right environment

When debugging, you might install multiple environments. Because of this,
the system might retrieve the wrong environment to run the sbatch scripts.

To solve this problem, remove all environments and reinstall a new one by
running the command `make setup`. This will start the `scripts/setup_env.sh`
scripts, which (1) creates a new environment in the `.venv` folder (the default
one used by `uv`), (2) install all of the packages in that environment.

Afterwards, the `slurm/*.sh` scripts should be able to pick the right
environment.

Also, make sure you activate the Python virtual environment within the SLURM
script. When not using `uv`, make sure to include the following command in your
script:

```bash
source $HOME/[project-dir]/.venv/bin/activate
```

But when using `uv`, you can use the `uv run python ...` command, which will
automatically use the correct virtual environment (as long it is stored in `.venv`).

## Experiments do not update

When changing code, which are considered modules in Python - i.e. those that are
found in the `src` folder and then loaded in the main Python script - it might
be that the `bash` scripts will not take the latest code but the cached ones.

But when using `uv`, this is somewhat resolved when running the scripts using
`uv run python ...` command. But be sure to log the changes you are expecting
with the new code so that you can cancel the experiment.
