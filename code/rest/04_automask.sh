#!/bin/bash -e
# This script creates an automask of input bold image via 3dAutomask
# edited by Mark Vernon (mverno2@emory.edu) 05/07/2021
# edited by Dan Wakeman (dwakem2@emory.edu) 09/09/2021


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

IMG_IN=${SUBJECT}_${SESSION}_${TASK}_bold_tshift_volreg_topapply

echo Generating automask for ${IMG_IN}.nii.gz...

3dAutomask -dilate 1 -apply_prefix ${DERIV_DIR}/${IMG_IN}_automask.nii.gz ${DERIV_DIR}/${IMG_IN}.nii.gz

