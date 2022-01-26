#!/bin/bash -ef
#
# This script smoothes input EPI image via 3dBlurInMask



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

IMG_IN=${SUBJECT}_${SESSION}_${TASK}_bold_tshift_volreg_topapply_automask_denoised_MPRAGE_rsampl

# Full-width half-maximum value for amount of smoothness added to dataset (in mm)
# Should NOT be changed between subjects
FWHM=3
#FWHM=6

echo Spatially blurring dataset ${IMG_IN}.nii.gz...

3dBlurInMask -input ${DERIV_DIR}/${IMG_IN}.nii.gz -FWHM ${FWHM} -automask -prefix ${DERIV_DIR}/${IMG_IN}_blur-${FWHM}.nii.gz

