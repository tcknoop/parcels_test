#!/bin/bash
#SBATCH --job-name=north-sea_oysters_fieldset_test
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=24G
#SBATCH --time=05:00:00
#SBATCH --partition=data

# make sure we have Singularity
module load singularity/3.5.2

# to get the image (need to be on a partition which has internet access --> data), run
#singularity pull --disable-cache --dir "${PWD}" docker://quay.io/willirath/parcels-container:2021.09.29-09ab0ce

# make sure the output exists
mkdir -p executed_notebooks

# run for single notebook and put into background
srun --ntasks=1 --exclusive singularity run -B /sfs -B /gxfs_work1 -B $PWD:/work --pwd /work parcels-container_2021.09.29-09ab0ce.sif bash -c \
    ". /opt/conda/etc/profile.d/conda.sh && conda activate base \
    && papermill --cwd notebooks \
        notebooks/fieldset_test.ipynb \
        executed_notebooks/fieldset_test_output_monthly.ipynb \
        -k python" &

# wait till background task is done
wait

# print resource infos
jobinfo
