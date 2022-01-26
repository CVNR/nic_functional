#!/bin/bash -ef
#
# This script de-noises functional data via fsl_regfilt
# by regressing out noise components classified by FIX.


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

INPUT_IMG=${SUBJECT}_${SESSION}_${TASK}_bold_tshift_volreg_topapply_automask

DESIGN=${DERIV_DIR}/${INPUT_IMG}.ica/filtered_func_data.ica/melodic_mix

FIXCLASS=${DERIV_DIR}/${INPUT_IMG}.ica/fix4melview_WhII_MB6_thr15.txt

NOISE=$(tail -n 1 ${FIXCLASS})

echo Running denoising of ${INPUT_IMG}.nii.gz

echo Noise components:  ${NOISE}

fsl_regfilt -i ${DERIV_DIR}/${INPUT_IMG}.nii.gz -d ${DESIGN} -f "${NOISE}" -o ${DERIV_DIR}/${INPUT_IMG}_denoised
