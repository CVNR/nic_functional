#!/bin/bash -e
# This script performs inhomogeneity correction, via topup, of fMRI data
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

FMAP_DIR=${PROJECT_DIR}/${SUBJECT}/${SESSION}/fmap

IMG_IN=${SUBJECT}_${SESSION}_${TASK}_bold_tshift_volreg

IMG_FMAP=${DERIV_DIR}/${SUBJECT}_${SESSION}

AP_SCAN=${FMAP_DIR}/${SUBJECT}_${SESSION}_rest-AP_fmap
PA_SCAN=${FMAP_DIR}/${SUBJECT}_${SESSION}_rest-PA_fmap

echo Generating topup file...

# concatenate AP and PA scans, excluding initial volumes with bval of zero
3dTcat -prefix ${IMG_FMAP}_allb0.nii.gz ${AP_SCAN}.nii.gz'[1..$]' ${PA_SCAN}.nii.gz'[1..$]'

# Make sure the fourth column in the acqpars.txt file is set to the total readout
# time listed in the topup .json file for the scanning protocol
ACQ_PARS=${PROJECT_DIR}/code/${PIPELINE}/${TASK}_acqpars.txt
CONFIG=${FSLDIR}/etc/flirtsch/b02b0.cnf


topup -v --imain=${IMG_FMAP}_allb0 --datain=${ACQ_PARS} --config=${CONFIG} --out=${IMG_FMAP}_topup --fout=${IMG_FMAP}_topup-field --iout=${IMG_FMAP}_topup-unwarped


echo Registering EPI to topup...

3dTcat -prefix ${IMG_FMAP}_AP-b0.nii.gz ${AP_SCAN}.nii.gz'[0]'

3dTstat -mean -prefix ${DERIV_DIR}/${IMG_IN}_mean.nii.gz ${DERIV_DIR}/${IMG_IN}.nii.gz

flirt -ref ${IMG_FMAP}_AP-b0.nii.gz -searchcost corratio -cost corratio -interp trilinear -dof 6 -bins 512 -in ${DERIV_DIR}/${IMG_IN}_mean.nii.gz -searchrx -30 30 -searchry -30 30 -searchrz -30 30 -omat ${DERIV_DIR}/${IMG_IN}_topup-premat.mat


echo Applying topup to ${IMG_IN}.nii.gz...

applywarp --ref=${IMG_FMAP}_AP-b0.nii.gz --in=${DERIV_DIR}/${IMG_IN}.nii.gz --premat=${DERIV_DIR}/${IMG_IN}_topup-premat.mat --out=${DERIV_DIR}/${IMG_IN}_topreg.nii.gz --interp=spline

applytopup --imain=${DERIV_DIR}/${IMG_IN}_topreg.nii.gz --datain=${ACQ_PARS} --inindex=1 --topup=${IMG_FMAP}_topup --out=${DERIV_DIR}/${IMG_IN}_topapply.nii.gz --method=jac

