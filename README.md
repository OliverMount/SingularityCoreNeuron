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
Navigate to the `def_files` directory and edit the `%files` section of the `cn.def` file. Update the file paths to point to your **locally downloaded**:

- NVIDIA HPC SDK tarball
- OpenMPI tarball or prebuilt directory

```bash
cd def_files
vim cn.def
```

Update paths under `%files` accordingly.

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
  |-- cn/
```

## Running on OLAF

SLURM batch scripts for running CoreNEURON jobs on OLAF are provided in the `batch/` directory. To run:
```bash
cd batch
sbatch your_script.batch
```
---


