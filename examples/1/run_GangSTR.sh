BAM=data/nc19_59.sorted.bam
REF=data/fa/hg38_HTT.fa
BED=data/HTT_offset_15.bed
OUT=out/out
INFO=data/HTT_offset_15_info.bed
GangSTR-2.4 \
    --bam $BAM \
    --ref $REF \
    --regions $BED \
    --out $OUT \
    --str-info $INFO
