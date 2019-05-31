#!/bin/bash

# TODO in future add to resources (instead of user inputs): reffa, strinfo, regionfile
main() {
    ### Download the user inputs to /data folder ###
    mkdir /data
    mkdir -p out/vcfs

    # BAM files
    bamsfiles=""
    for i in ${!bams[@]}
    do
        dx download "${bams[$i]}" -o /data/bams-$i.bam
	bamfiles="${bamfiles},/data/bams-$i.bam"
	dx-docker run -v /data/:/data quay.io/ucsc_cgl/samtools index /data/bams-$i.bam
    done
    bamfiles=$(echo $bamfiles | sed 's/,//')

    # Reference fasta file
    dx download "$reffasta" -o /data/ref.fa
    chroms=$(grep ">" /data/ref.fa | sed 's/^>//' | cut -f 1 -d' ' | grep -v GL | grep -v NC | grep -v hs37)
    dx-docker run -v /data/:/data quay.io/ucsc_cgl/samtools faidx /data/ref.fa
    
    # Regions file
    dx download "$regionfile" -o /data/regions.bed

    # STR info
    dx download "$strinfo" -o /data/strinfo.bed

    # Fam file
    dx download "$famfile" -o /data/famfile.fam
    
    ### Construct the config file ###
    CONFIGFILE="/data/config.txt"
    echo "BAMS=${bamfiles}" > ${CONFIGFILE}
    echo "REFFA=/data/ref.fa" >> ${CONFIGFILE}
    echo "REGIONS=/data/regions.bed" >> ${CONFIGFILE}
    echo "STRINFO=/data/strinfo.bed" >> ${CONFIGFILE}
    echo "FAMFILE=/data/famfile.fam" >> ${CONFIGFILE}
    echo "CHROMS="\"$chroms\" >> ${CONFIGFILE}

    # For debugging
    cat ${CONFIGFILE}
    
    # Write output files to /results
    mkdir /data/results
    echo "OUTPREFIX=/data/results/${outprefix}" >> ${CONFIGFILE}
    
    # Use hard coded numbers for now.
    echo "MINCOV=20" >> ${CONFIGFILE}
    echo "MAXCOV=1000" >> ${CONFIGFILE}
    echo "EXPHET=0" >> ${CONFIGFILE}
    echo "AFFECMINHET=0.8" >> ${CONFIGFILE}
    echo "UNAFFMAXTOT=0.2" >> ${CONFIGFILE}
    echo "THREADS=6" >> ${CONFIGFILE}

    ### Run the docker ###
    dx-docker run -v /data:/data gymreklab/gangstr-pipeline-2.4.2 ./run.sh ${CONFIGFILE}
    
    ### Upload the outputs to DNA Nexus ###
    for chrom in $chroms; do
	# GangSTR VCFs
	vcffile=/data/results/${outprefix}.${chrom}.vcf.gz
	cp ${vcffile} out/vcfs/
	# dumpSTR VCFs
	vcffile=/data/results/${outprefix}.${chrom}.filtered.sorted.vcf.gz
	vcfindex=${vcffile}.tbi
	cp ${vcffile} out/vcfs/
	cp ${vcffile}.tbi out/vcfs/
    done
    vcffile=/data/results/${outprefix}_merged_candidates.vcf.gz
    cp ${vcffile} out/vcfs/
    dx-upload-all-outputs
}
