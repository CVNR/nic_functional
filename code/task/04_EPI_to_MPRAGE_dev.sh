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

#Chanse's edits: will change back if needed.
anat_ana=anat-T1w_dev

#if [ ${SUBNUM} -gt 90 ]
#then
  anat_ana=anat-T1w_dev
#else
  echo 'Warning: This command has not been prepared to deal with SUBJECT IDs < 90'
  #exit 1
#fi


n_runs=4
# need to reduce the number of these.
task_name=task-cn

func_dir=${PROJECT_DIR}/derivatives/${analysis}/${SUBJECT}/${SESSION}/func
mkdir -p ${func_dir}
auto_dir=${PROJECT_DIR}/derivatives/task-intauto/${SUBJECT}/${SESSION}/func
anat_dir=${PROJECT_DIR}/derivatives/${anat_ana}/${SUBJECT}/${SESSION}/anat

t1=${anat_dir}/${SUBJECT}_${SESSION}_T1w_deoblq_RPI_denoised.nii
t1_brain=${anat_dir}/${SUBJECT}_${SESSION}_T1w_deoblq_RPI_denoised_brain_restore

#initialize all_dn
all_mask=

#Chanse: script won't run due to failing to make a symbolic link to _denoised file; File already exists. Commenting loop out to see if that helps

for run in `seq 1 1 ${n_runs}`; do
  echo run-${run}
  auto_lnk=${auto_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}
  auto_lnk=${auto_lnk}_tshift_volreg_topapply_automask_denoised
  bold_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}
  automask=${bold_name}_tshift_volreg_topapply_automask_denoised

#  ln -s ${auto_lnk}.nii.gz ${automask}.nii.gz
  if [ `echo ${all_mask} | wc -c ` -gt 10 ]; then
    all_mask="${all_mask} ${automask}.nii.gz"
  else
    all_mask=${automask}.nii.gz
  fi
done

run=cat
bold_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}
automask=${bold_name}_tshift_volreg_topapply_automask_denoised

3dTcat -prefix ${automask}.nii.gz ${all_mask}

epi_mean=${func_dir}/rm.fMRI_${SUBJECT}_run-${run}_mean

3dTstat -mean -prefix ${epi_mean}.nii ${automask}.nii.gz

# Adding the wmseg saves a ton of time.
epi_reg --epi=${epi_mean}.nii --t1=${t1}.nii --t1brain=${t1_brain} --wmseg=${t1_brain}-WM.nii.gz --out=${epi_mean}_toMPRAGE

premat=${epi_mean}_toMPRAGE

for run in `seq 1 1 ${n_runs}`; do
  echo "Applying warp to run-${run}"
  bold_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}
  automask=${bold_name}_tshift_volreg_topapply_automask_denoised
  toMPRAGE=${automask}_toMPRAGE
  applywarp --interp=spline -i ${automask}.nii.gz -r ${t1_brain} --premat=${premat}.mat -o ${toMPRAGE}
done

