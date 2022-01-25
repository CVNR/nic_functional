#!/bin/bash -ef
#
# This doesn't work. I'ts just a log for turning into a script later
#

#PROJECT_DIR=/data/qb/Atlanta/projects/Rodriguez-Merit
#SUBJECT=sub-int99
#SESSION=ses-bl
# These change for each analysis
analysis=task-intdnwh

# minor section to dynamically select the analysis pipline used based on subject
# number

SUBNUM=`echo ${SUBJECT} | cut -c 8-`

if [ ${SUBNUM} -gt 90 ]
then
  anat_ana=anat-T1w_dev
else
  echo 'This command has not been prepared to deal with SUBJECT IDs < 90'
  exit 1
fi

n_runs=4
# need to reduce the number of these.
task_name=task-cn

func_dir=${PROJECT_DIR}/derivatives/${analysis}/${SUBJECT}/${SESSION}/func
mkdir -p ${func_dir}
auto_dir=${PROJECT_DIR}/derivatives/task-intauto/${SUBJECT}/${SESSION}/func
anat_dir=${PROJECT_DIR}/derivatives/${anat_ana}/${SUBJECT}/${SESSION}/anat

DESIGN_FILE=${func_dir}/${SUBJECT}_design.fsf

# Copy design file w/ all melodic settings
cp ${PROJECT_DIR}/code/${analysis}/melodic_design.fsf ${DESIGN_FILE}

# Replace generic T1_BRAIN with path to individual's T1
T1_FILE=${anat_dir}/${SUBJECT}_${SESSION}_T1w_deoblq_RPI_denoised_brain.nii.gz
sed -i "s+T1_BRAIN+${T1_FILE}+g" ${DESIGN_FILE}

# Replace generic Run name with 
for run in `seq 1 1 ${n_runs}`; do
  echo run-${run}
  auto_lnk=${auto_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}
  auto_lnk=${auto_lnk}_tshift_volreg_topapply_automask.nii.gz
  bold_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}
  automask=${bold_name}_tshift_volreg_topapply_automask.nii.gz
  
  ln -s ${auto_lnk} ${automask}

  tofind=RUN${run}
  sed -i "s+${tofind}+${automask}+g" ${DESIGN_FILE}

done

Melodic ${DESIGN_FILE}

