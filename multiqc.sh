# Peru eDNA metabarcoding — multiqc
# create working directory and copy files to directory

mkdir /workdir/kja68
cd /workdir/kja68
cp /home/kja68/Peru_metabarcoding/Trimmed/*fastq.gz /workdir/kja68/
ls /workdir/kja68/

# Quality control: run multiqc
fastqc /workdir/kja68/*.gz
export LC_ALL=en_US.UTF-8
export PATH=/programs/miniconda3/bin:$PATH
source activate multiqc
multiqc /workdir/kja68/
conda deactivate
