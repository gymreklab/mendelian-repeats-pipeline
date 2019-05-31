# Commands to build the app

Assume we're running in a docker that has dx installed. To get to a working docker do:

```
source /storage/resources/source/dx-toolkit/environment
```

# Build the app
```
dx build -f --create-app str-expansion-pipeline
dx publish str-expansion-pipeline/0.0.1
```

# Run the app
```
dx run str-expansion-pipeline -f example-input.json -y --watch
```