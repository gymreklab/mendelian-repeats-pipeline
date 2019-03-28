# mendelian-repeats-pipeline
Pipeline for performing analysis of pathogenic tandem repeat mutations from NGS. The pipeline performs the following steps:

## To set up the docker
```
docker build -t gymreklab/gangstr-pipeline-2.4 .
docker push gymreklab/gangstr-pipeline-2.4
```
## To run using docker (you'll need to edit the config file paths)
```
docker run -v examples:/pipeline/examples gymreklab/gangstr-pipeline-2.4 ./run.sh examples/test.config
```
