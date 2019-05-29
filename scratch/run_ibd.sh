1;95;0c#!/bin/bash

BAM1=/storage/resources/datasets/WGSdata_LaSpada/LP6008104-DNA_A01/Assembly/LP6008104-DNA_A01.bam
BAM2=/storage/resources/datasets/WGSdata_LaSpada/LP6008104-DNA_B01/Assembly/LP6008104-DNA_B01.bam
BAM3=/storage/resources/datasets/WGSdata_LaSpada/LP6008104-DNA_C01/Assembly/LP6008104-DNA_C01.bam
BAM4=/storage/resources/datasets/WGSdata_LaSpada/LP6008104-DNA_D01/Assembly/LP6008104-DNA_D01.bam

REFFASTA=/storage/resources/dbase/human/hg19/Illumina/Homo_sapiens/UCSC/hg19/Sequence/WholeGenomeFasta/genome.fa

PRUNESNPS=23andme_snps.bed
OUTDIR=/storage/mgymrek/del/testIBD/

# Run GATK
#java -jar /storage/resources/source/GenomeAnalysisTK.jar \
#    -R ${REFFASTA} \
#    -T HaplotypeCaller \
#    -I ${BAM1} -I ${BAM2} -I ${BAM3} -I ${BAM4} \
#    -U ALLOW_SEQ_DICT_INCOMPATIBILITY \
#    -L ${PRUNESNPS} \
#    -o ${OUTDIR}/output.raw.snps.indels.vcf

# Select SNPs
#java -jar /storage/resources/source/GenomeAnalysisTK.jar \
#    -R ${REFFASTA} \
#    -T SelectVariants \
#    -V ${OUTDIR}/output.raw.snps.indels.vcf \
#    -selectType snp \
#    -o ${OUTDIR}/output.raw.snps.vcf

# Filter SNPs
#java -jar /storage/resources/source/GenomeAnalysisTK.jar \
#    -R ${REFFASTA} \
#    -T VariantFiltration \
#    -V ${OUTDIR}/output.raw.snps.vcf \
#    --filterExpression "DP<20 || QD < 2.0 || FS > 60.0 || MQ < 40.0" \
#    --filterName "snp_filter" \
#    --setFilteredGtToNocall \
#    -o ${OUTDIR}/output.filtered.snps.vcf

# Phase SNPs 
#java -jar /storage/mgymrek/del/testIBD/beagle.r1399.jar \
#    gt=${OUTDIR}/output.filtered.snps.vcf \
#    ped=${OUTDIR}/test.fam \
#    out=${OUTDIR}/output.phased

# Convert to plink format
#plink \
#    --vcf ${OUTDIR}/output.phased.vcf.gz --keep-allele-order \
#    --id-delim _ \
#    --recode --snps-only --biallelic-only --geno 0 \
#     --out ${OUTDIR}/output.phased

# Split by chrom
for chrom in $(seq 1 23)
do
    plink --file ${OUTDIR}/output.phased \
	--chr ${chrom} \
	--out ${OUTDIR}/output.phased.chr${chrom} \
	--recode

    # Germline
    /storage/mgymrek/del/testIBD/germline \
	-input ${OUTDIR}/output.phased.chr${chrom}.ped ${OUTDIR}/output.phased.chr${chrom}.map \
	-output ${OUTDIR}/output.chr${chrom}
#	-min_m 0.1 -err_hom 20 -err_het 10 \
#	-bits 64 \
done

# java -jar refined-ibd.16May19.ad5.jar gt=/storage/mgymrek/del/testIBD/output.phased.vcf.gz out=test window=5 length=1
./summarize_ibd.sh
