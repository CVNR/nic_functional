#!/bin/bash -ef
#
# This doesn't work. I'ts just a log for turning into a script later
#

#PROJECT_DIR=/data/qb/Atlanta/projects/Rodriguez-Merit
#SUBJECT=sub-int99
#SESSION=ses-bl
# These change for each analysis
analysis=task-intdnwh
n_runs=4
# need to reduce the number of these.
task_name=task-cn

SUBNUM=`echo ${SUBJECT} | cut -c 8-`

if [ ${SUBNUM} -gt 90 ]
then
  anat_ana=anat-T1w_dev
else
  echo 'This command has not been prepared to deal with SUBJECT IDs < 90'
  exit 1
fi


func_dir=${PROJECT_DIR}/derivatives/${analysis}/${SUBJECT}/${SESSION}/func
for run in `seq 1 1 ${n_runs}`; do

  bold_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}
  toMPRAGE=${bold_name}_tshift_volreg_topapply_automask_denoised_toMPRAGE

  3dresample -prefix ${toMPRAGE}_rsampl.nii.gz -inset ${toMPRAGE}.nii.gz -rmode Cu -orient RPI -dxy 2.000 2.000 2.000

done
