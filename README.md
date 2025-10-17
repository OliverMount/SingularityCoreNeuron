## SingularityCoreNeuron

This repository provides a streamlined method for building a **Singularity (Apptainer)** image of **CoreNEURON** with **GPU** and **MPI** support, ready for deployment in **HPC environments**.


## Repository Structure

| Directory | Description |
|------------|--------------|
| `def_files/` | Singularity definition files (`*.def`) for different systems |
| `install/` | Installer scripts for building the Singularity image |
| `batch/` | Example SLURM batch scripts for running jobs on HPC systems |


## Prerequisites

Before starting, ensure you have the following (if you use NVIDIA HPC SDK and openmpi):

- **NVIDIA HPC SDK** (~7 GB download)  
- **SLURM-aware OpenMPI** (use the same version as your HPC environment)  
- **Singularity / Apptainer** version **3.0+**

> **Note:** The NVIDIA HPC SDK and OpenMPI libraries are **not included** in this repository.  
> You must download them manually before building the image.

## Installation Guide

### 1. Clone the Repository
```bash
git clone git@github.com:OliverMount/SingularityCoreNeuron.git
cd SingularityCoreNeuron
```
---


### 2. Edit Definition File

Navigate to the `def_files/` directory:

```bash
cd def_files
```

This directory contains several example definition (`*.def`) files:

- **`HPCtemplate.def`** – Template for creating new HPC-specific definition files.  
- **`olaf.def`** – Example definition file for our HPC system.  
- **`karina.def` / `levi.def`** – Example workstation builds.

Each definition file consists of sections such as:

- `%files` — lists local files to include in the image (e.g., SDK tarballs, MPI libs).  
- `%post` — commands executed inside the container during image creation.
 
#### 🧩 Including Local MPI & SDK Files

In `olaf.def`, the `%files` section typically includes:

- NVIDIA HPC SDK tarball  
- OpenMPI tarball or prebuilt directory  

⚠️ **Important:**  
Ensure the OpenMPI version inside the container matches the one on your HPC for **ABI compatibility**.

---

### **3. Identify SLURM-aware MPI Libraries**

To determine which MPI type your HPC uses, run:

```bash
srun --mpi=list
```

Example output:
```
srun: MPI types are...
srun: cray_shasta
srun: none
srun: pmi2
```

In this example, `pmi2` is the MPI interface used.  
Locate the corresponding headers and libraries:

```bash
find /usr/include /usr/local/include -name pmi2.h
find /usr/include /usr/local/include -name libpmi2.so
```

Then copy them to a local folder:

```bash
cp /usr/include/slurm/pmi*.h YourLocalFolder/include/
cp /lib64/libpmi*.so* YourLocalFolder/lib64/
cp /usr/lib64/slurm/libslurm_pmi.so* YourLocalFolder/lib64/
```

These will be transferred into the image during the build (see first lines in `olaf.def`).

---

### 3. Set Installation Path
Edit the `install/full.sh` script and update the `appDIR` variable to reflect the path where you cloned the repository:

```bash
cd install
vim full.sh
```

Set:
```bash
appDIR=</your/path/to/SingularityCoreNeuron>
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
  |-- olaf.sif
  |-- olaf_sandbox/
```

## Running on HPC 

SLURM batch scripts for running CoreNEURON jobs on HPC are provided in the `batch/` directory. To run:
Change the GPU numbers, threads in the batch file
```bash
cd batch
sbatch run.batch
```
---


