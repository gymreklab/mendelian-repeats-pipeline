# Commands to build the app

Assume we're running in a docker that has dx installed. To get to a working docker do:

```
docker run -itv /storage:/storage --cap-add=SYS_PTRACE --security-opt seccomp=unconfined ryanicky/dnanexus
source dx-toolkit/environment
```

# Build the app
```
dx build -f --create-app str-pipeline
```