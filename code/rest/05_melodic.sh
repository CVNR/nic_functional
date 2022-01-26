#!/bin/bash -ef
#
# This script sets the melodic design file settings then runs Melodic


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

# analysis pipeline from which processed structural image is utilized for Melodic registration
ANAT_PIPE=anat-T1w-gh



DERIV_DIR=${PROJECT_DIR}/derivatives/${PIPELINE}/${SUBJECT}/${SESSION}/func

ANAT_DIR=${PROJECT_DIR}/derivatives/${ANAT_PIPE}/${SUBJECT}/${SESSION}/anat

DESIGN_FILE=${DERIV_DIR}/${SUBJECT}_design.fsf

# Copy design file w/ all melodic settings
cp ${PROJECT_DIR}/code/${PIPELINE}/melodic_design.fsf ${DESIGN_FILE}

# Replace generic "T1_BRAIN" label in design.fsf with path to individual's T1
T1_FILE=${ANAT_DIR}/${SUBJECT}_${SESSION}_T1w_deoblq_RPI_denoised_brain.nii.gz
sed -i "s+T1_BRAIN+${T1_FILE}+g" ${DESIGN_FILE}

# Replace generic "RS_BOLD" label with path to automasked bold data
IMG_IN=${DERIV_DIR}/${SUBJECT}_${SESSION}_${TASK}_bold_tshift_volreg_topapply_automask.nii.gz
sed -i "s+RS_BOLD+${IMG_IN}+g" ${DESIGN_FILE}


Melodic ${DESIGN_FILE}

