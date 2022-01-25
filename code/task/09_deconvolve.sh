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

# Gather all the runs
allruns=

for run in `seq 1 1 ${n_runs}`; do

  bold_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}
  rsamp_name=${bold_name}_tshift_volreg_topapply_automask_toMPRAGE_rsampl
  blur_name=${rsamp_name}_blur-3.nii.gz

  allruns=`echo ${allruns} ${blur_name}`

done

censorall_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-all_censor.1D

fitts=${func_dir}/${SUBJECT}_${SESSION}_fitts_GAM
errts=${func_dir}/${SUBJECT}_${SESSION}_errts_GAM
bucket=${func_dir}/${SUBJECT}_${SESSION}_stats_GAM

# needs to be replaced by individual files at some point
category=${PROJECT_DIR}/code/${analysis}/task-int_category.1d
crosshair=${PROJECT_DIR}/code/${analysis}/task-int_crosshair.1d

3dDeconvolve -input ${allruns} \
             -polort A \
             -censor ${censorall_name} \
             -local_times \
             -num_stimts 2 \
             -stim_times 1 ${category} 'GAM' \
             -stim_label 1 category \
            -stim_times 2 ${crosshair} 'GAM' \
            -stim_label 2 crosshair \
            -gltsym 'SYM: 1*category -1*crosshair' \
            -glt_label 1 categor_v_cross \
            -fout \
            -tout \
            -rout \
            -fitts ${fitts} \
            -errts ${errts} \
            -bucket ${bucket}


