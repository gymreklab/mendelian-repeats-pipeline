# Commands to build the app

Assume we're running in a docker that has dx installed. To get to a working docker do:

```
docker run -itv /storage:/storage --cap-add=SYS_PTRACE --security-opt seccomp=unconfined ryanicky/dnanexus:App7
source dx-toolkit/environment
cd mendelian-repeats-pipeline
cd dnanexus
```

# Build the app
```
dx build -f --create-app str-pipeline
```

# Run the app
```
dx run str-pipeline
# Run with predefined input file
dx run str-pipeline -f input.json -y --watch
