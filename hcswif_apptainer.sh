#!/usr/bin/bash
ARGC=$#
if [[ $ARGC -ne 3 ]]; then
    echo Usage: hcswif.sh SCRIPT RUN EVENTS
    exit 1
fi;
script=$1 # script to run
run=$2 # RUN Number
evt=$3 # Number of events in that run

# Change these if this if not where hallc_replay 

# Modify as you need
#--------------------------------------------------
HALLC_REPLAY_DIR="/home/$USER/hallc_replay"   # my replay directory
DATA_DIR="${RAW_DIR}"
ROOT_FILE="/path/to/rootfile/directory"
REPORT_OUTPUT="/path/to/REPORT_OTUPUT/directory"
APPTAINER_IMAGE="${APPTAINER_IMAGE}"
#--------------------------------------------------

cd $HALLC_REPLAY_DIR

# Check if apptainer is available
if command -v apptainer > /dev/null 2>&1; then
    echo "apptainer is already available."
else
    # Load apptainer if not available
    echo "Loading apptainer..."
   if ! eval module load apptainer; then
        echo "Failed to load apptainer. Please check if the module is installed and accessible."
        exit 1  # Exit the script with a non-zero exit code
    fi
fi

echo
echo "---------------------------------------------------------------------------------------------"
echo "NPS SINGLE REPLAY for ${runNum}. NEvent=${nEvent} using NPSlib container=${APPTAINER_IMAGE}"
echo "----------------------------------------------------------------------------------------------"
echo

runStr="apptainer exec --bind ${DATA_DIR} --bind ${ROOT_FILE} --bind ${REPORT_OUTPUT} --bind ${HALLC_REPLAY_DIR}  ${APPTAINER_IMAGE} bash -c \"hcana -q ${script}\(${runNum},${nEvent}\)\""
eval ${runStr}