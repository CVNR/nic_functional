#!/bin/bash -ef
#
# This doesn't work. I'ts just a log for turning into a script later
#

# PROJECT_DIR=/data/qb/Atlanta/projects/Rodriguez-Merit
# SUBJECT=sub-int99
# SESSION=ses-bl
# These change for each analysis
analysis=task-intdnwh
n_runs=4
# need to reduce the number of these.
task_name=task-cn

func_dir=${PROJECT_DIR}/derivatives/${analysis}/${SUBJECT}/${SESSION}/func



for run in `seq 1 1 ${n_runs}`; do
  echo run-${run}

  automask_base=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}_tshift_volreg_topapply_automask
#this name needs to be cleaned up
  ica_dir=${automask_base}.ica


#read in fix4melview_WhII_MB6_thr15.txt file and assign last line to ncomps
  ncomps="$(tail -n 1 ${ica_dir}/fix4melview_WhII_MB6_thr15.txt)"

  fsl_regfilt -i ${automask_base}.nii.gz -d ${ica_dir}/filtered_func_data.ica/melodic_mix -f "$ncomps" -o ${automask_base}_denoised

  echo $ncomps

done
