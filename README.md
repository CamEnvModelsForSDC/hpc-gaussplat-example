# Gaussian Splatting
Creating & submitting a [3D Gaussian Splatting](https://github.com/graphdeco-inria/gaussian-splatting) job on the HPC.

This repository contains a basic example of how to create and submit a Gaussian Splatting job on the HPC. For conducting any research on Gaussian Splatting, you should use adapt this code to your needs. This repository is meant as a starting point for your own research.

The `lib/` folder contains a `gaussplat-job` file, which is the job to be submitted on a GPU cluster on the HPC. The `bin/` folder contains a `gs-hpc-gaussplat-start-job` script, which will create copy the job to the HPC and submit it there. This is a script that you run locally (so no ssh to hpc), the script will ssh commands to the hpc when needed. In order to use this start-job script, some environment variables must be set. This is done by the `activate-lib` script, which you can `source activate-lib` to set the environment variables. The `activate-lib` script will also add the `bin/` folder to your path, so you can run the `gs-hpc-gaussplat-start-job` script from anywhere.


# Activating the library
```
source activate-lib [--local|--hpc]
```

# Library executables

`gs-hpc-gaussplat-start-job <scratch-input-directory>`: \
starts a gaussian splatting job on the HPC, the input directory will first be checked if it exists on the hpc. Then a job is submitted to the HPC and the output & model are written to the input folder. Parameters for the job can be set in the file (the job) that will be opened on execution of this script.

_you can use `scp $VSCUSER@login.hpc.ugent.be:~/scratch/<scratch-input-directory>/model.zip .` to download the model from the HPC_

