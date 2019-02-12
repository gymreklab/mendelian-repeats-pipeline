# mendelian-repeats-pipeline
Pipeline for performing analysis of pathogenic tandem repeat mutations from NGS

## To run a minimal example from the command line:
```
./run.sh examples/test.config
```

## To run a minimal example using docker
```
docker build --no-cache -t gangstr-pipeline .
docker run -v /storage:/storage gangstr-pipeline ./run.sh examples/test.config
```