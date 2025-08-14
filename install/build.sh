# Define base and subdirectories
appDIR="/home/oli/Apptain"

# The following are the empty directories
defDIR="$appDIR/def_files"
imageDIR="$appDIR/images"
tmpDIR="$appDIR/tmp"
cacheDIR="$appDIR/cache"

# Export for Apptainer
export APPTAINER_TMPDIR="$tmpDIR"
export APPTAINER_CACHEDIR="$cacheDIR"

 
########### for levi ############# 
# Build the sandbox image 
sudo apptainer build --fix-perms --sandbox "$imageDIR/levi" "$defDIR/levi.def" 
# Convert  sandbox to sif 
sudo apptainer build --fix-perms "$imageDIR/levi.sif" "$imageDIR/levi" 

########### for karina ############# 
sudo apptainer build --fix-perms --sandbox "$imageDIR/karina" "$defDIR/karina.def"
sudo apptainer build --fix-perms "$imageDIR/karina.sif" "$imageDIR/karina"  
