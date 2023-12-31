#!/bin/bash


##################################################
# CHANGE THESE JOB PARAMETERS


#PBS -N $NAME               ## Job name


#PBS -l nodes=1:ppn=all       ## 1 node, 12 processors per node (ppn=all to get a full node)
#PBS -l walltime=24:00:00     ## Max time your job will run (no more than 72:00:00)
#PBS -l mem=48gb              ## If not used, memory will be available proportional to the max amount
#PBS -l gpus=1                ## GPU amount (only on accelgor or joltik)
#PBS -m abe                   ## Email notifications (abe=aborted, begin and end)


FPS=5  # FPS to use for extracting frames


# END OF JOB PARAMETERS
##################################################





cd $PBS_O_WORKDIR           ## Change to the working directory to where the job was submitted (the task dir)
ROOT=$(pwd)                 ## Save the root path of the job

# the expected minimal dir structure on the hpc looks like this
# INPUT-DIR   
# ├── jobid.txt       (id of this job)
# ├── job.sh          (this file)
# ├── <video-1>.mp4
# ├── <video-2>.mp4
# └── ...


echo "0. Resizing videos to max 1600 pixels (width)..."
    module purge
    module load FFmpeg/6.0-GCCcore-12.3.0
    # resize all videos to max 1600 pixels (width)
    for file in *.mp4; do
        ffmpeg -loglevel warning -nostats -i $file -vf "scale='min(1600,iw)':-2" $(basename $file .mp4)-resized.mp4
        mv $(basename $file .mp4)-resized.mp4 $file  # overwrite the original video
    done


echo "1. Extracting frames from videos..."
    module purge
    module load FFmpeg/6.0-GCCcore-12.3.0
    mkdir scene
    mkdir scene/input  # for the frames
    # extract frames from all videos
    for file in *.mp4; do
        ffmpeg -loglevel warning -nostats -i $file -vf "fps=$FPS" scene/input/$(basename $file .mp4)-%04d.jpg
    done



echo "2. Converting frames..."
    module purge
    module load COLMAP/3.8-foss-2022b
    # on hpc this is not available (yet)
    curl -s https://raw.githubusercontent.com/graphdeco-inria/gaussian-splatting/main/convert.py > convert.py
    time python3 convert.py --no_gpu -s scene > /dev/null # for hpc change python3 -> python
    rm convert.py                                             # the script
    #rm -rf scene/distorted scene/stereo                                   # unnecessary folders that were generated
    #rm     scene/run-colmap-geometric.sh scene/run-colmap-photometric.sh  # unnecessary files that were generated
    #rm -rf scene/input  # not needed for training on hpc


echo "Preparing training..."
    module purge
    module load CUDA/11.7.0
    module load PyTorch/1.12.0-foss-2022a-CUDA-11.7.0
    module load torchaudio/0.12.0-foss-2022a-PyTorch-1.12.0-CUDA-11.7.0
    module load torchvision/0.13.1-foss-2022a-CUDA-11.7.0
    # check whether gs is installed
    if [ ! -d ~/scratch/gaussian-splatting ]; then
        echo "Directory ~/scratch/gaussian-splatting does not exist"
        echo "Trying to install gaussian-splatting"
        cd ~/scratch
        git clone https://github.com/graphdeco-inria/gaussian-splatting.git --recursive --quiet
        cd gaussian-splatting
        pip install tqdm plyfile
        pip install submodules/simple-knn/
        pip install submodules/diff-gaussian-rasterization/
    fi
    # check that cuda is available, will be printed to stdout
    # used for debugging
    python -c "import torch; print('cuda available:', torch.cuda.is_available())"


echo "3. Training..."
    cd ~/scratch/gaussian-splatting
    python train.py -s $ROOT/scene -m $ROOT/model


echo "4. Finishing up..."
    cd $ROOT
    # basename $ROOT = $NAME
    zip -r model.zip model

echo "Done!"

# hint: use 
# `scp $VSCUSER@login.hpc.ugent.be:~/scratch/$DIR/model.zip .` 
# to download the model on your local machine
