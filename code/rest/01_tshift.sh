#!/bin/bash -e
# This script performs slice timing via 3dTshift of fMRI data
# edited by Mark Vernon (mverno2@emory.edu) 05/06/2021
# edited by Dan Wakeman (dwakem2@emory.edu) 09/03/2021


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

DERIV_DIR=${PROJECT_DIR}/derivatives/${PIPELINE}/${SUBJECT}/${SESSION}/func


mkdir -p ${DERIV_DIR}


IMG_IN=${SUBJECT}_${SESSION}_${TASK}_bold

echo Running slice timing of ${IMG_IN}.nii.gz

SLICENUM=`3dinfo -nk ${RAW_DIR}/${IMG_IN}.nii.gz`

echo Number of slices is:  ${SLICENUM}

SLICETIMES=`grep -A ${SLICENUM} SliceTiming ${RAW_DIR}/${IMG_IN}.json | grep -Eo '[0-9.]{1,}'`

echo Slice times:  ${SLICETIMES}

echo ${SLICETIMES}>${DERIV_DIR}/${IMG_IN}_slicetimes.1D

3dTshift -quintic -prefix ${DERIV_DIR}/${IMG_IN}_tshift.nii.gz -tpattern @${DERIV_DIR}/${IMG_IN}_slicetimes.1D ${RAW_DIR}/${IMG_IN}.nii.gz

