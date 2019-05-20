# mendelian-repeats-pipeline
Pipeline for performing analysis of pathogenic tandem repeat mutations from NGS. The pipeline performs the following steps:

## Pipeline overview

### Input
The pipeline takes an input configuration file (e.g. `examples/text.config`). This file specifies paths to input files and user-specified parameters.

Main fields:
* `OUTPREFIX`: output files are named `$OUTPREFIX.*`
* `BAMS`: a comma-separated list of BAM paths to process. BAMs must be sorted and indexed
* `REFFA`: input fasta reference genome file
* `REGIONS`: list of STRs to process (e.g. GangSTR reference TR set)
* `STRINFO`: File used as input to GangSTR's `--strinfo`. Contains expansion thresholds for each locus.
* `FAMFILE`: Pedigree file in Plink .fam format.
* `CHROMS`: list of chromosomes to process. e.g. "chr1 chr2 ..."
* `THREADS`: number of threads to use

GangSTR specific fields:
* `OPTGANGSTR`: additional command-line options to pass to GangSTR

DumpSTR specific fields:
* `MINCOV`: filter calls with less than this coverage
* `MAXCOV`: filter calls with more than this coverage
* `EXPHET`: filter calls with P(heterozygous expansion) less than this
* `OPTDUMPSTR`: additional command-line options to pass to dumpSTR

PostMaSTR specific fields:
* `AFFECMINHET`: Require affecteds to have at least this P(heteorzygous expansion)
* `UNAFFMAXTOT`: Require unaffects to have at most this P(het)+p(hom) (low probability of either homozygous or heterozygous expansion)

### Pipeline steps

The main pipeline file is `run.sh`, which runs the following steps:

1. GangSTR
Inputs: `BAM`, `REFFA`, `STRINFO`, `REGIONS`
Outputs: bgzipped `${OUTPREFIX}.${chrom}.vcf.gz` for each chromosome

2. DumpSTR
Inputs: `${OUTPREFIX}.${chrom}.vcf.gz` for each chromosome
Outputs: `${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz`, `${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz.tbi`: indexed, bgzipped VCF files with filter field set

3. PostMaSTR
Inputs: `${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz`: bgzipped, indexed VCFs from dumpSTR
Outputs: `${OUTPREFIX}.${chrom}.candidates.sorted.vcf.gz`: VCF file with candidate expansions

## To set up the docker
```
docker build -t gymreklab/gangstr-pipeline-2.4 .
docker push gymreklab/gangstr-pipeline-2.4
```
## To run using docker (you'll need to edit the config file paths)
```
docker run -v examples:/pipeline/examples gymreklab/gangstr-pipeline-2.4 ./run.sh examples/test.config
```
