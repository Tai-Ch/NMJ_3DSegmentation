# 3D Segmentation of Fluorescent signal in Neurons or Glia
This workflow is designed to help (1) create 3D mask from fluorescently labelled neurons or glia and (2) mask smFISH signal within a specific tissue for downstream smFISH analysis, using Fiji macros batch processing.

This is the recommended organisation of the folders.
![Workflow](https://github.com/Tai-Ch/NMJ_3DSegmentation/blob/3971b4b98c79204ac94a45a7f8be80cb83076c31/workflow.png?raw=true)

## 1. Prepare .tif files

If your data files are not .tif, start here. First, put all images in a "raw file" folder.

> In Fiji, go to Process -> Batch -> Convert...
> 
> Choose Input... ("raw file" folder)
> 
> Choose Output... ("tif" folder)
> 
> Output format TIFF, Interpolation = "None", Scale factor 1.00 

Check results

## 2.1 Subtract background of the smFISH channel

Open the following code in Fiji Macros (download file <a href="https://github.com/Tai-Ch/NMJ_3DSegmentation/blob/5e617f2de7e499079939abc6f35e3e88724cd55d/smFISH_background_subtract.ijm"> Here </a>)

> Change the input and output directory
> 
> Check whether your smFISH channel is channel 0, 1, 2, or 3. My code was set as channel 2. 
>
> Note: This macros set default rolling ball radius = 10. 

```
input = "E:/ParentFolder/tif/";
output = "E:/ParentFolder/Segmented/";
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

## 2.2 Create 3D Mask from HRP signal (Neurons) or other fluorescent markers

Open the following code in Fiji Macros (download this file <a href="https://github.com/Tai-Ch/NMJ_3DSegmentation/blob/5e617f2de7e499079939abc6f35e3e88724cd55d/3D_Hys_Seg.ijm"> Here </a>)

> Change the input and output directory
> 
> Check whether your 'mask' channel is channel 0, 1, 2, or 3. My HRP mask was channel 3. 
> 
> Check the range of fluorescence intensity for this channel. Set high and low appropriately.
>
> Note: This macros set default rolling ball radius = 50, median filter radius = 5. The output binary images were converted from (0,255) to (0,1) by dividing the whole image with the value=255. 


```
input = "E:/ParentFolder/tif/";
output = "E:/ParentFolder/Segmented/";
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

In the case where you have HRP signal (or other fluorescent markers) outside of the NMJ (such as in the nerves, trachea, or the muscle), it is recommended that you either crop images manually, or draw ROI around the NMJ and set everything else outside the ROI as zero. This can be done in Fiji by the following:

> Open each 3D Mask image output and evaluate whether the mask represents the actual structure. Repeat Step 2.2 with different high and low values for 3D Hysteresis Thresholding if necessary. If the segmentation goes well but the images include unwated structures around the corner or near the NMJ, do the following:
> 
> Select Freehand selection tool and draw around the NMJ.
> Edit -> Selection -> Make Inverse.
> Press 'delete' frame by frame.

Check results

## 4. Mask smFISH signal 

Open two images at a time: (1) the 3D mask channel and (2) the smFISH channel.

> Process -> Image Calculator
>
> Select Image 1 and Image 2 (in any order), choose operation as 'multiply'. Select 'Create new window'. Do not select '32-bit (float) result'.
>
> Save images. These images are input for bigfish analysis. 

![Masking 3D smFISH signal by 3D HRP Mask](https://github.com/Tai-Ch/NMJ_3DSegmentation/blob/d5497390f89dd77b180d919aad4fb164a72256d5/3D%20Segmentation%20Example.png?raw=true)


