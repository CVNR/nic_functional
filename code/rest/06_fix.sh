#!/bin/bash -ef
#
# This script classifies components of input ICA from melodic via FIX


# Make sure to export environment variables before running this script!

# export PROJECT_DIR=/data/qb/Atlanta/projects/<project>
# (e.g. export PROJECT_DIR=/data/qb/Atlanta/projects/Woodbury-CDA2)

# export PIPELINE=<pipeName>
# (e.g. export PIPELINE=task-rest)

# export SUBJECT=sub-<subID>
# (e.g. export SUBJECT=sub-CES01)

# export SESSION=ses-<sesID>
# (e.g. export SESSION=ses-bl)

# export TASK=task-<taskName>
# (e.g. export TASK=task-rest)



DERIV_DIR=${PROJECT_DIR}/derivatives/${PIPELINE}/${SUBJECT}/${SESSION}/func

IMG_IN=${SUBJECT}_${SESSION}_${TASK}_bold_tshift_volreg_topapply_automask

# Training dataset used to classify components
TRAINDATA=/usr/local/fix1.06/training_files/WhII_MB6.RData

# Thresholding of good vs bad components
THRESHOLD=15

echo Running component classification on ${INPUT_IMG}.ica...

/usr/local/fix1.06/fix -c ${DERIV_DIR}/${IMG_IN}.ica ${TRAINDATA} ${THRESHOLD}
