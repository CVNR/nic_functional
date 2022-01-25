#!/bin/bash -e
# This script performs volume registration via 3dvolreg of fMRI data
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


DERIV_DIR=${PROJECT_DIR}/derivatives/${PIPELINE}/${SUBJECT}/${SESSION}/func

IMG_IN=${SUBJECT}_${SESSION}_${TASK}_bold_tshift

# volume index should NOT be changed between subjects
ref_vol=100
BASE=${DERIV_DIR}/${IMG_IN}.nii.gz"[${ref_vol}]"

# motion threshold, past which results in a volume being censored. Should NOT be changed between subjects
THRESHOLD=0.5


echo Running volume registration and motion correction of ${IMG_IN}.nii.gz

3dvolreg -float -quintic -prefix ${DERIV_DIR}/${IMG_IN}_volreg.nii.gz -maxite 30 -x_thresh 0.00003 -rot_thresh 0.00003 -twopass -maxdisp1D ${DERIV_DIR}/${IMG_IN}_maxdisp.1D -1Dfile ${DERIV_DIR}/${IMG_IN}_mpar.1D -base ${BASE} ${DERIV_DIR}/${IMG_IN}.nii.gz


echo Plotting motion parameters from ${IMG_IN}_mpar.1D...

1dplot -plabel head-motion -xlabel '# of Time Steps' -volreg -png ${DERIV_DIR}/${IMG_IN}_mpar.png - ${DERIV_DIR}/${IMG_IN}_mpar.1D

echo Generating motion censor list of volumes. Review ${IMG_IN}_CENSORTR.txt for list of censored volumes.

# A volume is censored if the derivative values have a Euclidean Norm above the threshold set in ${THRESHOLD}

1d_tool.py -infile ${DERIV_DIR}/${IMG_IN}_mpar.1D -set_nruns 1 -show_censor_count -censor_motion ${THRESHOLD} ${DERIV_DIR}/${IMG_IN}

