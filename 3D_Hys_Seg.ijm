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