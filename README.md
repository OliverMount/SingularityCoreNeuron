# SingularityCoreNeuron

This repository provides a streamlined method to build a Singularity image for CoreNEURON with GPU and MPI support, suitable for use in HPC environments.

## Repository Structure

- `def_files/`: Contains Singularity definition files (`*.def`)
- `install/`: Installer scripts used to build the Singularity image
- `batch/`: Example SLURM batch scripts to run jobs in HPC environment

## Prerequisites

- NVIDIA HPC SDK (large download, ~7GB)
- SLURM-aware OpenMPI libraries (use the same openmpi libraries as used in the HPC environment)
- Singularity (version 3.0+ recommended)

> **Note:** The NVIDIA-HPC-SDK and OpenMPI SLRUM-aware libraries are **not included** in the repository. You must download them manually.

## Step-by-Step Instructions

### 1. Clone the Repository
```bash
git clone git@github.com:OliverMount/SingularityCoreNeuron.git
cd SingularityCoreNeuron
```

### 2. Edit Definition File

1. Navigate to the `def_files` directory. It contains HPCtemplate.def (which can be used as a guide for your HPC). Particular def files used in our lab are also present in this directory. For example, the def file for the HPC in our center is available in the olaf.def

2. Edit the sections of the `your_def_file.def` file. For example, edit the section `%files` to include any local files you want them to the included in the apptainer image. In our olaf.def, this includes the 
- NVIDIA HPC SDK tarball
- OpenMPI tarball or prebuilt directory (make sure the OpenMPI libraries in the container is the same version as in the HPC for ABI compatibility.)

```bash
cd def_files
vim olaf.def
```

Update paths under `%files` accordingly.

A way to find which mpi installed in your HPC is slrum-aware, run the following in your HPC terminal 
```bash
srun --mpi=list
```
The output (in our HPC) would be like 

```
srun: MPI types are...
srun: cray_shasta
srun: none
srun: pmi2
```
The output shows that in our HPC pmi2 libraries are used. Find their locations by

```
find /usr/include /usr/local/include -name pmi2.h
find /usr/include /usr/local/include -name libpmi2.so
```

copy them to a local folder in a computer 

```
cp /usr/include/slurm/pmi*.h YourLocalFolder/include/
cp /lib64/libpmi*.so* YourLocalFolder/lib64/
cp /usr/lib64/slurm/libslurm_pmi.so* YourLocalFolder/lib64/

```
and transfer them during image formation (These are the first five lines in our cn.def file).


### 3. Set Installation Path
Edit the `install/full.sh` script and update the `appDIR` variable to reflect the path where you cloned the repository:

```bash
cd install
vim full.sh
```

Set:
```bash
appDIR=/your/path/to/SingularityCoreNeuron
```

### 4. Create Required Directories
Ensure the following directories exist. By default, these are located in your `$HOME`:

- `tmp/`
- `cache/`
- `image/`

If you change their paths, update them in `install/full.sh`.

```bash
mkdir -p $HOME/tmp $HOME/cache $HOME/image
```

### 5. Run the Installation Script
```bash
cd install
./full.sh
```

This will build the Singularity sandbox and `.sif` image and place them in the `image/` directory.

### 6. Locate the Output
After successful execution, the output files will be located in:
```
image/
  |-- cn.sif
  |-- cn_sandbox/
```

## Running on HPC 

SLURM batch scripts for running CoreNEURON jobs on HPC are provided in the `batch/` directory. To run:
Change the GPU numbers, threads in the batch file
```bash
cd batch
sbatch run.batch
```
---


