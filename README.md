
# SingularityCoreNeuron

Singularity-based CoreNEURON Installation on OLAF

## Building the Singularity Image for CoreNEURON

Singularity image files (`*.sif`) are built using definition files (`*.def`) located in the `def_files` directory. These definition files are processed through installer scripts available in the `install` directory.

### Step-by-Step Instructions

1. **Clone the Repository**

   ```bash
   git clone git@github.com:OliverMount/SingularityCoreNeuron.git
   ```

2. **Set the Installation Path** Navigate to the `install` directory and edit the `full.sh` script. Update the `appDIR` variable to reflect the path where you cloned the repository. By default, this is set to your home directory (`$HOME`).

3. **Create Required Directories** You need to create the following directories for Singularity to use during the build process:

   - `tmp`
   - `cache`
   - `image`

   These paths must also be specified in the `install/full.sh` script. By default, they are set to locations inside your home directory.

4. **Run the Installation Script** Execute the full installation script:

   ```bash
   cd install
   ./full.sh
   ```

5. **Locate the Output** After a successful run, the resulting sandbox and `.sif` image files will be located in the `image` directory.



## Run batch files in OLAF

(will be updated soon ..)

