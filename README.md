# Gaussian Splatting
Creating & submitting [3D Gaussian Splatting](https://github.com/graphdeco-inria/gaussian-splatting) jobs on the HPC.


# Activating the library
```
source activate-lib [--local|--hpc]
```


# Library executables

`gs-hpc-gaussplat-start-job <task-name>`: \
starts a gaussian splatting job on the HPC, the task name is used to identify the job and the output folder. This script expects a `~scratch/tasks/task-name` folder on the hpc. The job is submitted to the HPC and the output & model are written to the `task-name` folder. Parameters for the job can be set in the file that will be opened on execution of this script.

_you can use `scp $VSCUSER@login.hpc.ugent.be:~/scratch/tasks/<task-name>/<task-name>-model.zip .` to download the model from the HPC_


# What does what?
This is a brief overview of which files do what. Read this if you want to understand how this (small) library works.

The main code is found in `lib/job-params` and `lib/gaussplat-job`. The params file defines the parameters of the job, and the gaussplat-job file defines the job itself. These files must first be merged into a file `job.sh`, and then the `job.sh` must then be transfered to the HPC and submitted there. The `gs-hpc-gaussplat-start-job` script does all of this for you. Beware that the `gs-hpc-gaussplat-start-job` uses environment variables which are set in the `activate-lib` script. If you want to run a gaussplat-job job manually, you will have to merge these files, and set the required environment variables yourself.

