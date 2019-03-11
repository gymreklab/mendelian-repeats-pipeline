# mendelian-repeats-pipeline
Pipeline for performing analysis of pathogenic tandem repeat mutations from NGS. The pipeline performs the following steps:

1. Run GangSTR
2. Run DumpSTR
3. Summarize candidate expansions.

All paths and options are specified in a config file. See `examples/test.config` for an example config file.

To build the docker
```
docker build -t gymreklab/gangstr-pipeline-2.4 .
```

To run a minimal example from the command line:
```
./run.sh examples/test.config
```

To run a minimal example using docker:
```
docker run -v examples:/pipeline/examples ./run.sh examples/test.config
```
