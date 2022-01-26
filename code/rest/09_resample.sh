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

DXstring=$(3dinfo ${RAW_DIR}/${RAW_BOLD}.nii.gz | grep 'R-to-L')
DX=${DXstring: `expr $(expr index "${DXstring}" m) - 7`:5}
echo DX is ${DX}

DYstring=$(3dinfo ${RAW_DIR}/${RAW_BOLD}.nii.gz | grep 'A-to-P')
DY=${DYstring: `expr $(expr index "${DYstring}" m) - 7`:5}
echo DY is ${DY}

DZstring=$(3dinfo ${RAW_DIR}/${RAW_BOLD}.nii.gz | grep 'I-to-S')
DZ=${DZstring: `expr $(expr index "${DZstring}" m) - 7`:5}
echo DZ is ${DZ}


3dresample -prefix ${DERIV_DIR}/${IMG_IN}_rsampl.nii.gz -input ${DERIV_DIR}/${IMG_IN}.nii.gz -dxyz ${DX} ${DY} ${DZ}


