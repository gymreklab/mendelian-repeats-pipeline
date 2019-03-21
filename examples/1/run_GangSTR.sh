BAM=data/test.bam
REF=data/test.fa
BED=data/test_regions.bed
OUT=out/test
INFO=data/test_strinfo.bed
GangSTR-2.4 \
    --bam $BAM \
    --ref $REF \
    --regions $BED \
    --out $OUT \
    --str-info $INFO
