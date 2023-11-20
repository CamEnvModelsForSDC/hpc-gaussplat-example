# Gaussian Splatting
Creating & submitting a [3D Gaussian Splatting](https://github.com/graphdeco-inria/gaussian-splatting) job on the HPC.

This repository contains a basic example of how to create and submit a Gaussian Splatting job on the HPC. For conducting any research on Gaussian Splatting, you should adapt this code to your needs. This repository is meant as a starting point for your own research.

The `gaussplat-job.sh` file is the job to be submitted on a GPU cluster on the HPC. The `start-job.sh` script, which will create a copy of the job on the HPC and submit it there. This is a script that you run locally, the script will send commands over ssh to the hpc when needed. In order to use this start-job script, some environment variables must be set. Edit the `VSCUSER` variable at the top of `start-job.sh`, and optionally the `VSCCLUSTER` variable if you want to use a different cluster.

The `start-job.sh` script will also open up the job, before sending it over to the HPC. This is done so that you can edit the job parameters before submitting it.



# Usage
```
./start-job.sh <scratch-input-directory>
```
The `<scratch-input-directory>` has to be a directory located on the HPC in the `~/scratch` dir. So if your video files for the scene are located in a directory `~/scratch/tasks/pyramid` then the `<scratch-input-directory>` should be `tasks/pyramid`.

# Tips & tricks

You can use `scp $VSCUSER@login.hpc.ugent.be:~/scratch/<scratch-input-directory>/model.zip .` to download the model from the HPC

Colmap uses a lot of memory and time, so make sure the job parameters are set accordingly. With the default parameters it took about 3h30 and 20GB of ram in order to process a scene consisting of 150 frames or images.

More information on the HPC can be found [here](HPC.md)
