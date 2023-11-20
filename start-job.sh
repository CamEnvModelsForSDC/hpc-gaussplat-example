#!/bin/bash
VSCUSER=""  # your vsc account
CLUSTER="accelgor"  # accelgor or joltik

# check that VSCUSER is set
[ -z "$VSCUSER" ] && echo "VSCUSER is not set, open this file and set it to your vsc account" && exit 1

usage () {
    echo "Usage: $0 <scratch-input-directory>"
}

# first argument: path to the folder
[ -z "$1" ] && echo "No path to the intput folder on the hpc given" && usage && exit 1
# check that the task dir exists on hpc
echo "Checking if the input directory ($1) exists on hpc..."
if [[ $(ssh $VSCUSER@login.hpc.ugent.be "if [ ! -d ~/scratch/$1 ]; then echo 1; else echo 0; fi") == 1 ]]; then
    echo "Directory ~/scratch/$1 does not exist on hpc"
    echo "  make sure the path starts from the scratch directory (leave the ~/scratch/ out of the path)"
    exit 1
fi
# first argument parsed
DIR="~/scratch/$1"

# create job file
# change $NAME in the job.sh file to the name of the directory
NAME=$(basename $DIR)
sed "8s/\$NAME/$NAME/g" gaussplat-job.sh > job.sh
# open file for user to edit the job parameters at the top
nano job.sh
# execution rights
chmod +x job.sh

# copy job to hpc
echo "Copying job to hpc... $VSCUSER@login.hpc.ugent.be"
scp job.sh $VSCUSER@login.hpc.ugent.be:$DIR
rm job.sh

# submit the job on hpc
echo "Submitting job on hpc..."
ssh $VSCUSER@login.hpc.ugent.be "cd $DIR; module swap cluster/$CLUSTER; qsub job.sh > jobid.txt; echo \"Job created with id: \$(cat jobid.txt)\""
