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

func_dir=${PROJECT_DIR}/derivatives/${analysis}/${SUBJECT}/${SESSION}/func
anat_dir=${PROJECT_DIR}/derivatives/${anat_ana}/${SUBJECT}/${SESSION}/anat

#doesn't make sense to register each run separately
for run in `seq 1 1 ${n_runs}`; do
  echo run-${run}

#These filenames are too long
  bold_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-${run}
  rsamp_name=${bold_name}_tshift_volreg_topapply_automask_denoised_toMPRAGE_rsampl
  blur_name=${rsamp_name}_blur-3
                       
  auto_lnk=${auto_dir}/${bold_name}_tshift_mpar.1D
  mparaIn=${func_dir}/${bold_name}_tshift_mpar
  ln -s ${auto_lnk} ${mparaIn}.1D

  #calculate outliers in 3d+time data
                  
  3dToutcount -automask -polort 1 ${blur_name}.nii.gz > ${blur_name}_outcount.1D
                      
  #demean motion files
            
  1d_tool.py -overwrite -infile ${mparaIn}.1D -set_nruns 1 -demean -write ${mparaIn}'_'demean.1D
                        

done
