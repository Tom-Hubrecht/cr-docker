cr-docker
=========

This project aims at simplifying the generation of correctly-rounded mathematical functions.

It generates docker image archives containing all the tools needed to design a correctly rounded mathematical function:

- sollya
- gappa

TODO: Add more tools

The docker image is layered to reduce the space required between each versions of the 

## Getting an archive

### From GitHub

GitHub Actions is used to produce an archive for each revision pushed, it can be downloaded as an artifact of the workflow runs.

### Using nix

Running `nix-build -A dockerFile` will produce the requested docker archive.

### Loading the archive

Using podman:

```
podman load --input archive.tar.gz
```

### Entering the image

Using podman:

```
podman run -it localhost/cr-workspace:...
```

