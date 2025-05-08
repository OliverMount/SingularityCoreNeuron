# SingularityCoreNeuron

Singularity CoreNeuron installation in OLAF

## Steps to build the singularity image for the CoreNeuron
Singularity image files (.sif) are built from definition (.def) files located in the `def_files` directory. These definition files are executed using installer bash scripts found in the `install` folder.

1. Clone the repository
```
git clone git@github.com:OliverMount/SingularityCoreNeuron.git
```

2. Go to the `install` folder and set the appDIR path in the full.sh script. The appDIR path is the path of the directory where you cloned the repository in step 1. It is set to home directory currently $HOME (see the install/full.sh)

3. Create `tmp` and `cache` directory for singularity to use during image building. Create `image` directory that will store the final sandbox and the .sif files.  The paths of these extra directories has to be set in `install/full.sh`. By default, these directories points to the directory in the home


4. Run the  `full.sh` in the install directory.
```
cd install
./full.sh
```

5. The sandbox and the image are in the image folder after sucessful run of the step 4.

  
