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