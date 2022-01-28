# NIC Functional Pre-Processing Guide

Below are some descriptions of what each pre-processing script in a typical NIC functional pipeline is doing along with some NIC suggested steps to review the output. Your research group may have additional data review steps, please communicate with your PI.

## Slice-Timing Correction

```Bash
cd /data/qb/Atlanta/projects/<projectID>/code/<pipeline>/
./01_tshift.sh
```


### What this script does:

Instead of being collected all at once, fMRI brain volumes are acquired in slices, with each slice taking time to acquire. However, most modeled data analysis assumes the the slices were all acquired simultaneously. In order to reconcile these differences, each slice needs to shifted back in time by the duration it took to acquire that slice.  The 3dTshift tool is used to make this shift and interpolate the data between time points.  For more information see References below.


### References:

[Slice-Timing Correction](https://andysbrainbook.readthedocs.io/en/latest/fMRI_Short_Course/Preprocessing/Slice_Timing_Correction.html)

[3dTshift](https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dTshift.html)


## Motion Correction

```Bash
cd /data/qb/Atlanta/projects/<projectID>/code/<pipeline>/
./02_volreg.sh
```

Review the output motion parameters plot (…mpar.png) via the `ristretto` command, filling in the appropriate `<subID>`, `<sesID>`, and `<task>`:

```Bash
ristretto sub-<subID>_ses-<sesID>_task-<task>_bold_tshift_mpar.png
```

If motion from one volume to the next is greater than half of the voxel size (a spike) or if the total absolute movement is greater than one voxel (drift), then more techniques may be required to correct the motion of the subject or the subject data may need to be removed from analysis.

### What this script does:

This script uses the `3dvolreg` tool to register each volume to a predetermined reference volume called the “base”. The base volume is usually either at the beginning, middle, or end of the scan. `3dvolreg` then moves each other volume to be aligned with the base and outputs how much each volume was moved and in which direction to a .1D file (…mpar.1D).  The script then plots this motion parameter file and saves the plot as a .png file. Volumes where motion exceeds a threshold are censored, which means the volumes are identified in a .1D file (…censor.1D) so that they can be left out of later activation signal analysis. For more information see References below.

### References:

[3dvolreg](https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dvolreg.html)


## Susceptibility-Induced Distortion Correction

```Bash
cd /data/qb/Atlanta/projects/<projectID>/code/<pipeline>/
./03_topup.sh
```

To check the output of this script, open the input and output images in `fsleyes`. Toggle the overlay of one of the images and observe the difference between these images. There should be a noticeable elongation of the output brain image in the Anterior-Posterior (A-P) direction as the susceptibility-induced distortion is corrected.

### What this script does:

This script uses the `topup` tool to estimate the susceptibility-induced magnetic field on the input image from two opposing polarities acquisitions. The `topapply` tool then uses the field estimation from `topup` to correct the input image, removing the warping effect of the subject head susceptibility-induced distortion. For more information see References below.

### References:

[topup](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup)


## Brain Masking

```Bash
cd /data/qb/Atlanta/projects/<projectID>/code/<pipeline>/
./04_automask.sh
```

To check the output of this script, overlay the automasked data (…automask.nii.gz) onto the input image in AFNI or FSLeyes. Look through the slices and make sure there aren’t any brain voxels being cut off or that not too much non-brain voxels are being included as brain.

### What this script does:

This script uses the `3dAutomask` tool to create a brain-only masked dataset.

### References:

[3dAutomask](https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dAutomask.html)


## Independent Component Analysis (ICA) via Melodic

```Bash
cd /data/qb/Atlanta/projects/<projectID>/code/<pipeline>/
./05_melodic.sh
```

To make sure this step completed properly, review the Melodic report log in firefox:

```Bash
cd /data/qb/Atlanta/<projectID>/derivatives/<pipeline>/sub-<subID>/ses-<sesID>/func/sub-<subID>_ses-<sesID>_task-<task>_bold_tshift_volreg_topapply_automask.ica/
firefox report_log.html
```

Scroll to the end of the report.  If there is a "finished!" message, then Melodic completed the ICA successfully.

### What this script does:

This script generates a design.fsf file with settings to be used with the Melodic ICA tool. Then, Melodic is run to decompose the total change in BOLD signal over time at each voxel into individual source components.

### References:

[Melodic](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MELODIC)


## ICA Component Classification

```Bash
cd /data/qb/Atlanta/projects/<projectID>/code/<pipeline>/
./06_fix.sh
```

To make sure this step completed properly, review the output classified components text file (fix4melview...) in the Melodic .ica directory for the subject. If this file does not exist then the `fix` classifier tool may have encounted an error.

### What this script does:

This script uses the `fix` tool to classify the components from the previous Melodic ICA as either noise or signal for the purpose of noise removal. The default is to use a training dataset to classify components.  However, it is also possible to use `fix` to build a custom training dataset based on a subset of user data.  See References below for more information.

### References:

[fix](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FIX)


## Denoising

```Bash
cd /data/qb/Atlanta/projects/<projectID>/code/<pipeline>/
./07_regfilt.sh
```

### What this script does:

This script uses the `fsl_regfilt` tool to regress out the noise components identified classified by `fix` in the previous pre-processing step.

### References:

[fsl_regfilt](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MELODIC#fsl_regfilt_command-line_program)


## Registration to Structural Image

```Bash
cd /data/qb/Atlanta/projects/<projectID>/code/<pipeline>/
./08_EPI_to_MPRAGE.sh
```

### What this script does:

This script aligns an input functional image to the subject's previously processed anatomical image. First, the `3dTstat` tool is used to take the mean of an input functional image.  This mean functional image is then registered to a previously processed structual brain image via the `epi_reg` tool. The resulting registration matrix is then applied to the original input functional image using the `applywarp` tool.

### References:

[3dTstat](https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dTstat.html)\
[epi_reg](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FLIRT/UserGuide#epi_reg)\
[applywarp](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FNIRT/UserGuide#Now_what.3F_--_applywarp.21)


## Resampling

```Bash
cd /data/qb/Atlanta/projects/<projectID>/code/<pipeline>/
./09_resample.sh
```

### What this script does:

This script uses the `3dresample` tool to set the input functional image back to its acquisition resolution after being registered and warped to align with an anatomical image in the previous pre-processing step.

### References:

[3dresample](https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dresample.html)


## Smoothing

```Bash
cd /data/qb/Atlanta/projects/<projectID>/code/<pipeline>/
./10_smoothing.sh
```

### What this script does:

This script utilizes the `3dBlurInMask` tool on an input functional image to replace each voxel with a weighted average of its neighboring voxels in order to cancel out noise and enhance signal.

### References:

[Why Smooth?](https://andysbrainbook.readthedocs.io/en/latest/fMRI_Short_Course/Preprocessing/Smoothing.html)\
[3dBlurInMask](https://afni.nimh.nih.gov/pub/dist/doc/program_help/3dBlurInMask.html)

