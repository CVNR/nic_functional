#!/bin/bash -ef
#
# This doesn't work. I'ts just a log for turning into a script later
#

# export PROJECT_DIR=/data/qb/Atlanta/projects/example
# export SUBJECT=sub-0
# export SESSION=ses-0

# These change for each analysis
analysis=task-intdnwh
n_runs=4
#need to reduce the number of these.
task_name=task-cn

func_dir=${PROJECT_DIR}/derivatives/${analysis}/${SUBJECT}/${SESSION}/func


for run in `seq 1 1 ${n_runs}`; do

#this name needs to be cleaned up
  ica_dir=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}_tshift_volreg_topapply_automask.ica

  cp -r ${ica_dir} ${func_dir}/.${SUBJECT}_${SESSION}_${task_name}_run-${run}_tshift_volreg_topapply_automask.ica

  /usr/local/fix1.06/fix -c ${ica_dir} /usr/local/fix1.06/training_files/WhII_MB6.RData 15

done

