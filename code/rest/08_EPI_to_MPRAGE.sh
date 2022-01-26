#!/bin/bash -ef
#
# This script coregisters EPI to MPRAGE image via epi_reg


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

IMG_IN=${SUBJECT}_${SESSION}_${TASK}_bold_tshift_volreg_topapply_automask_denoised

ANAT_DIR=${PROJECT_DIR}/derivatives/${ANAT_PIPE}/${SUBJECT}/${SESSION}/anat

IMG_T1=${SUBJECT}_${SESSION}_T1w_deoblq_RPI_denoised


echo Running EPI to MPRAGE coregistration on ${IMG_IN}.nii.gz...

3dTstat -mean -prefix ${DERIV_DIR}/${IMG_IN}_mean.nii.gz ${DERIV_DIR}/${IMG_IN}.nii.gz

epi_reg --epi=${DERIV_DIR}/${IMG_IN}_mean.nii.gz --t1=${ANAT_DIR}/${IMG_T1}.nii --t1brain=${ANAT_DIR}/${IMG_T1}_brain_restore.nii.gz --wmseg=${ANAT_DIR}/${IMG_T1}_brain_restore-WM.nii.gz --out=${DERIV_DIR}/${IMG_IN}_MPRAGE

ln -s ${ANAT_DIR}/${IMG_T1}_brain_restore.nii.gz ${DERIV_DIR}/${IMG_T1}_brain_restore.nii.gz
