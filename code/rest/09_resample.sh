#!/bin/bash -ef
#
# This script resamples MPRAGE coregistered EPI images to original acquisition resolution


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


RAW_DIR=${PROJECT_DIR}/${SUBJECT}/${SESSION}/func
RAW_BOLD=${SUBJECT}_${SESSION}_${TASK}_bold

DERIV_DIR=${PROJECT_DIR}/derivatives/${PIPELINE}/${SUBJECT}/${SESSION}/func
IMG_IN=${SUBJECT}_${SESSION}_${TASK}_bold_tshift_volreg_topapply_automask_denoised_MPRAGE

echo Resampling EPI image to original dimensions...

# Variables for new dx, dy, dz, resolution values.
# These values are pulled from 3dinfo of raw BOLD image as acquired.

DX=$(3dinfo -adi ${RAW_DIR}/${RAW_BOLD}.nii.gz)
echo DX is ${DX}

DY=$(3dinfo -adj ${RAW_DIR}/${RAW_BOLD}.nii.gz)
echo DY is ${DY}

DZ=$(3dinfo -adk ${RAW_DIR}/${RAW_BOLD}.nii.gz)
echo DZ is ${DZ}


3dresample -prefix ${DERIV_DIR}/${IMG_IN}_rsampl.nii.gz -input ${DERIV_DIR}/${IMG_IN}.nii.gz -dxyz ${DX} ${DY} ${DZ}


