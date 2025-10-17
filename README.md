# SingularityCoreNeuron

This repository provides a streamlined method to build a Singularity image for CoreNEURON with MPI and/or GPU support, suitable for use in high performance computing (HPC) environments.

## Repository Structure

- `def_files/`: Contains Singularity definition files (`*.def`)
- `install/`: Installer scripts used to build the Singularity image
- `batch/`: Example SLURM batch scripts to run jobs in HPC environment

## Prerequisites

- Singularity (version 3.0+ recommended)
- SLURM-aware OpenMPI libraries (for MPI-based parallel simulations. Use **the same openmpi libraries** as used in the HPC environment)
- NVIDIA HPC SDK (for GPU-based simulations. Note that it is a large download, ~7GB)

> **Note:** The NVIDIA-HPC-SDK and OpenMPI SLRUM-aware libraries are **not included** in the repository. You must download them manually.

## Step-by-Step Instructions

### 1. Clone the Repository
```bash
git clone git@github.com:OliverMount/SingularityCoreNeuron.git
cd SingularityCoreNeuron
```

### 2. Edit Definition File
Navigate to the `def_files` directory and edit the `%files` section of the `cn.def` file. Update the file paths to point to your **locally downloaded**:

- OpenMPI tarball or prebuilt directory (make sure the OpenMPI libraries in the container is the same version as in the HPC for ABI compatibility.)
- NVIDIA HPC SDK tarball

```bash
cd def_files
vim cn.def
```

Update paths under `%files` accordingly.

#### HPC systems using SLURM

If the HPC environment uses the SLURM scheduler, the same version of the MPI libraries should be a container. To find which mpi installed in your HPC is slrum-aware, run the following in your HPC terminal 

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
The output shows that in our HPC pmi2 libraries are used. Find their locations, e.g. by

```
find /usr/include /usr/local/include -name pmi2.h
find /usr/include /usr/local/include -name libpmi2.so
```

Copy them to a local folder in a computer

```
cp /usr/include/slurm/pmi*.h <YourLocalFolder>/include/
cp /lib64/libpmi*.so* <YourLocalFolder>/lib64/
cp /usr/lib64/slurm/libslurm_pmi.so* <YourLocalFolder>/lib64/
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

Written by Oliver James and Sungho Hong, Center for Memory and Glioscience, IBS, South Korea

October 2025
