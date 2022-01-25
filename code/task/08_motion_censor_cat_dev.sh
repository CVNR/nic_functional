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
auto_dir=${PROJECT_DIR}/derivatives/task-intauto/${SUBJECT}/${SESSION}/func

#These filenames are too long
bold1_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-1
rsamp1_name=${bold1_name}_tshift_volreg_topapply_automask_denoised_toMPRAGE_rsampl
blur1_name=${rsamp1_name}_blur-3

bold2_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-2
rsamp2_name=${bold2_name}_tshift_volreg_topapply_automask_denoised_toMPRAGE_rsampl
blur2_name=${rsamp2_name}_blur-3

bold3_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-3
rsamp3_name=${bold3_name}_tshift_volreg_topapply_automask_denoised_toMPRAGE_rsampl
blur3_name=${rsamp3_name}_blur-3

bold4_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-4
rsamp4_name=${bold4_name}_tshift_volreg_topapply_automask_denoised_toMPRAGE_rsampl
blur4_name=${rsamp4_name}_blur-3

boldall_name=${func_dir}/${SUBJECT}_${SESSION}_${task_name}_run-all
rsampall_name=${boldall_name}_tshift_volreg_topapply_automask_denoised_toMPRAGE_rsampl
blurall_name=${rsampall_name}_blur-3


#combine time points from 3dToutcount

oclabel=bold_tshift_volreg_automask_denoised_toMPRAGE_rsampl_blur-3

1dcat -stack ${blur1_name}_outcount.1D ${blur2_name}_outcount.1D ${blur3_name}_outcount.1D ${blur4_name}_outcount.1D > ${blurall_name}_outcount.1D
  
#combine time files from 1d_tool.py

# cnlabel=censor

cens_name=${SUBJECT}_${SESSION}_${task_name}_run-
for run in `seq 1 1 ${n_runs}`; do

  auto_lnk=${auto_dir}/${cens_name}${run}_tshift_censor.1D
  censor=${func_dir}/${cens_name}${run}_tshift_censor.1D
  ln -s ${auto_lnk} ${censor}

done

cens_namep=${func_dir}/${cens_name}

1dcat -stack ${cens_namep}1_tshift_censor.1D ${cens_namep}2_tshift_censor.1D ${cens_namep}3_tshift_censor.1D ${cens_namep}4_tshift_censor.1D > ${cens_namep}all_censor.1D


#combine demeaned files - to be used in 3dDeconvolve motion parameter regression        


dm1=${cens_namep}1_tshift_mpar_demean.1D
dm2=${cens_namep}2_tshift_mpar_demean.1D
dm3=${cens_namep}3_tshift_mpar_demean.1D
dm4=${cens_namep}4_tshift_mpar_demean.1D

dmr=${cens_namep}all_mpar_demean-roll.1D
dmp=${cens_namep}all_mpar_demean-pitch.1D
dmy=${cens_namep}all_mpar_demean-yaw.1D
dmis=${cens_namep}all_mpar_demean-IS.1D
dmrl=${cens_namep}all_mpar_demean-RL.1D
dmap=${cens_namep}all_mpar_demean-AP.1D

# get roll
1dcat -stack ${dm1}[0] ${dm2}[0] ${dm3}[0] ${dm4}[0] > ${dmr}

# get pitch
1dcat -stack ${dm1}[1] ${dm2}[1] ${dm3}[1] ${dm4}[1] > ${dmp}


# get yaw
1dcat -stack ${dm1}[2] ${dm2}[2] ${dm3}[2] ${dm4}[2] > ${dmy}

# get Z motion
1dcat -stack ${dm1}[3] ${dm2}[3] ${dm3}[3] ${dm4}[3] > ${dmis}

# get x motion
1dcat -stack ${dm1}[4] ${dm2}[4] ${dm3}[4] ${dm4}[4] > ${dmrl}

# get y motion
1dcat -stack ${dm1}[5] ${dm2}[5] ${dm3}[5] ${dm4}[5] > ${dmap}


#oc_censor=${boldall}

#censor motion
1deval -a ${blurall_name}_outcount.1D -expr '1-step(a-450)' > ${blurall_name}_oc-censor.1D

#combine multiple censor files -- to be censored out in 3dDeconvolve
1deval -a ${blurall_name}_oc-censor.1D -b ${cens_namep}all_censor.1D -expr 'a*b' > ${blurall_name}_total-censor.1D


