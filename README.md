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

