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



#### Definition File Organization
Each Singularity definition file is organized into several key sections:

* **%files** — Specifies local files to be copied into the container image (e.g., SDK tarballs, MPI libraries).
* **%post** — Contains commands to install software packages and libraries required inside the container.
* **%environment** — Defines environment variables such as Python virtual environment settings, and paths for NVIDIA, CUDA, and OpenMPI.
* **%labels** — Provides metadata and a brief description of the container.


 
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
cp /usr/include/slurm/pmi*.h <YourLocalFolder>/include/
cp /lib64/libpmi*.so* <YourLocalFolder>/lib64/
cp /usr/lib64/slurm/libslurm_pmi.so* <YourLocalFolder>/lib64/ 
cp /lib64/libpmi*.so* <YourLocalFolder>/lib64/
cp /usr/lib64/slurm/libslurm_pmi.so* <YourLocalFolder>/lib64/
```

These will be transferred into the image during the build (see first lines in `olaf.def`).

---

### **4. Set Installation Path**

Edit the installation script:

```bash
cd install/
vim full.sh
```

Update the following variable to your repository path:

```bash
appDIR=</your/path/to/SingularityCoreNeuron>
```

---


### **5. Create Required Directories**

By default, the installer expects the following directories in your `$HOME`:

```bash
mkdir -p $HOME/tmp $HOME/cache $HOME/image
```

If you use different paths, make sure to specify them in `install/full.sh`.

---

### **6. Run the Installation Script**

Build the Singularity image:

```bash
cd install
./full.sh
```

This process will:

- Build a sandbox container  
- Generate the `.sif` image file  
- Store both outputs in the `image/` directory

---

### **7. Locate the Output**

After successful execution, the build artifacts will be located in:

```
image/
├── olaf.sif
└── olaf_sandbox/
```

---

## Running CoreNEURON on HPC

Example SLURM batch scripts are provided in the `batch/` directory.

1. Open and edit `run.batch` to adjust (we used this for our HPC):
   - Number of GPUs
   - Threads or nodes per job

2. Submit the job:

```bash
cd batch
sbatch run.batch
```

---

 
## Troubleshooting

- **Build fails due to missing MPI libraries:**  
  Ensure you copied the correct `pmi2.h` and `libpmi*.so` files into the image.

- **Version mismatch errors:**  
  Confirm that your container’s OpenMPI matches the HPC’s MPI version. 
 
---

## 📚 References

- [CoreNEURON Documentation](https://github.com/BlueBrain/CoreNeuron)
- [Singularity / Apptainer Official Docs](https://apptainer.org/docs/)
- [NVIDIA HPC SDK](https://developer.nvidia.com/hpc-sdk)
- [OpenMPI Documentation](https://www.open-mpi.org/doc/)

---

Definition files developed solely by Oliver James, Center for Memory and Glioscience, IBS, South Korea, October 2025.
