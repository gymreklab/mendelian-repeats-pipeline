# mendelian-repeats-pipeline
Pipeline for performing analysis of pathogenic tandem repeat mutations from NGS

## To run using docker (you'll need to edit the config file paths)
```
docker build --no-cache -t gangstr-pipeline .
docker run -v /storage:/storage ./run.sh /storage/mgymrek/repeat-expansions/v2/config_files/test.config
```
