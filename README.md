# 3D Segmentation of Fluorescent signal in Neurons or Glia
This workflow is designed to (1) create 3D mask from fluorescently labelled neurons or glia and (2) mask smFISH signal within a specific tissue for downstream smFISH analysis, using Fiji macros batch processing.

This is the recommended organisation of the folders for the workflow.
![Workflow](https://github.com/Tai-Ch/NMJ_3DSegmentation/blob/3971b4b98c79204ac94a45a7f8be80cb83076c31/workflow.png?raw=true)

## 1. Prepare .tif files

If your data files are not .tif, start here. Put all images in a "raw file" folder.

> In Fiji, go to Process -> Batch -> Convert...
> Choose Input... ("raw file" folder)
> Choose Output... ("tif" folder)
> Output format TIFF, Interpolation = "None", Scale factor 1.00 

Check results

## 2.1 Subtract background

Open the following code in Fiji Macros (download this file <a href="https://github.com/Tai-Ch/NMJ_3DSegmentation/blob/5e617f2de7e499079939abc6f35e3e88724cd55d/smFISH_background_subtract.ijm"> Here </a>
> Change the input and output directory
> Check whether your smFISH channel is channel 0, 1, 2, or 3. Mine was channel 2. 

```
input = "E:/ImpRNAi_Kstim_smFISH_1/tif/";
output = "E:/ImpRNAi_Kstim_smFISH_1/Segmented/";
setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++){
		action(input, output, list[i]);
}
setBatchMode(false);
function action (input, output, filename) {
		open(input + filename);
		run("Duplicate...", "duplicate channels=2");
		run("Subtract Background...", "rolling=10 stack");
		saveAs("Tiff", output + "smFISH_" + filename);
}
```
Check results

## 2.2 Create 3D Mask

Open the following code in Fiji Macros (download this file ![here](https://github.com/Tai-Ch/NMJ_3DSegmentation/blob/5e617f2de7e499079939abc6f35e3e88724cd55d/3D_Hys_Seg.ijm))
> Change the input and output directory
> Check whether your 'mask' channel is channel 0, 1, 2, or 3. My HRP mask was channel 3. 
> Check the range of fluorescence intensity for this channel. Set high and low appropriately.

```
input = "E:/ImpRNAi_Kstim_smFISH_1/tif/";
output = "E:/ImpRNAi_Kstim_smFISH_1/Segmented/";
setBatchMode(true);
list = getFileList(input);
for (i = 0; i < list.length; i++){
		action(input, output, list[i]);
}
setBatchMode(false);
function action (input, output, filename) {
		open(input + filename);
		run("Duplicate...", "duplicate channels=3");
		run("Subtract Background...", "rolling=50 stack");
		run("Median...", "radius=5 stack");
		run("3D Hysteresis Thresholding", "high=1000 low=500");
		run("Divide...", "value=255 stack");
		saveAs("Tiff", output + "Hys_" + filename);
}
```
Check results

## 3. Clean 3D Mask

## 4. Mask smFISH signal 

![Masking 3D smFISH signal by 3D HRP Mask](https://github.com/Tai-Ch/NMJ_3DSegmentation/blob/d5497390f89dd77b180d919aad4fb164a72256d5/3D%20Segmentation%20Example.png?raw=true)
