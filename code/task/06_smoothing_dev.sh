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

func_dir=${PROJECT_DIR}/derivatives/${analysis}/${SUBJECT}/${SESSION}/func

#doesn't make sense to register each run separately
for run in `seq 1 1 ${n_runs}`; do
  echo run-${run}

  bold_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}
  rsampl=${bold_name}_tshift_volreg_topapply_automask_denoised_toMPRAGE_rsampl

  3dBlurInMask -input ${rsampl}.nii.gz -FWHM 3 -automask -prefix ${rsampl}_blur-3.nii.gz

done

