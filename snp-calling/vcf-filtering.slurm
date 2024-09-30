#!/bin/bash

## Note - Slurm script comments require two hash symbols (##).  A single
## hash symbol immediately followed by SBATCuH indicates an SBATCH
## directive.  "##SBATCH" indicates the SBATCH command is commented
## out and is inactive.

## NTasks is not thread count, be sure to leave it set at 1
#SBATCH --ntasks=1

## If your program will be using less than 24 threads, or you
## require more than 24 threads, set cpus-per-task to the 
## desired threadcount.  Leave this commented out for the
## default 24 threads.
##SBATCH --cpus-per-task=2

## You will need to specify a minimum amount of memory in the
## following situaitons:
##   1. If you require more than 128GB of RAM, specify either:
##      a. "--mem=512000" for at least 512GB of RAM (6 possible nodes)
##      b. "--mem=1000000" for at least 1TB of RAM (2 possible nodes)
##   2. If you are running a job with less than 24 threads, you will
##      normally be given your thread count times 5.3GB in RAM.  So
##      a single thread would be given about 5GB of RAM.  If you
##      require more, please specify it as a "--mem=XXXX" option,
##      but avoid using all available RAM so others may share the node.
##SBATCH --mem=512000

## Normally jobs will restart automatically if the cluster experiences
## an unforeseen issue.  This may not be desired if you want to retain
## the work that's been performed by your script so far.   
## --no-requeue

## Normal Slurm options
## SBATCH -p shared
#SBATCH --job-name="SNPfilter"
#SBATCH --output=SNPfilter.output

## Load the appropriate modules first.  Linuxbrew/colsa contains most
## programs, though some are contained within the anaconda/colsa
## module.  Refer to http://premise.sr.unh.edu for more info.
module purge
module load anaconda
conda activate snp-calling

## Instruct your program to make use of the number of desired threads.
## As your job will be allocated an entire node, this should normally
## be 24.

cd /mnt/home/ecogen/path/to/your/vcf

# Step 1: remove indels from vcf file
#vcftools --vcf your-vcf-file.vcf  --remove-indels --recode --recode-INFO-all --out your-vcf-file-snps-only.vcf


# Step 2: filter SNPs based on minor allele count, quality score, and how many individuals they are present in
#vcf=your-vcf-file-snps-only.vcf.recode.vcf
#vcftools --vcf $vcf \
#   --max-missing 0.5 \
#   --mac 3 \
#   --minQ 30 \
#   --recode \
#   --recode-INFO-all \
#   --out snps-filtered-1


# Step 3.1: create list of individuals and how much data they are missing
#vcftools --vcf snps-filtered-2.recode.vcf \
#   --missing-indv


# Step 3.2: make list of individuals missing more than 50% of data
#mawk '$5 > 0.5' out.imiss | cut -f1 > lowDP.indv


# Step 3.3: remove individuals that have excessive missing data
#vcftools --vcf snps-filtered-2.recode.vcf \
#   --remove lowDP.indv \
#   --recode --recode-INFO-all \
#   --out snps-filtered-3


# Step 4: filter SNPs based on how many individuals they are present in, minor allele frequency, and depth
#vcftools --vcf snps-filtered-3.recode.vcf \
#   --max-missing 0.95 \
#   --maf 0.05 \
#   --recode \
#   --recode-INFO-all \
#   --out snps-filtered-4 \
