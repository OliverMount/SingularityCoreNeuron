# Define base and subdirectories
appDIR=$HOME
defDIR="$appDIR/def_files"
imageDIR="$appDIR/images"
tmpDIR="$appDIR/tmp"
cacheDIR="$appDIR/cache"

# Export for Apptainer
export APPTAINER_TMPDIR="$tmpDIR"
export APPTAINER_CACHEDIR="$cacheDIR"

# Build the sandbox image (cn for CoreNEURON)
sudo apptainer build --fix-perms --sandbox "$imageDIR/cn_sandbox" "$defDIR/cn.def"

# Build the image sif from sandbox
sudo apptainer build --fix-perms "$imageDIR/cn.sif" "$imageDIR/cn_sandbox"
