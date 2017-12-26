# Metacritic Score

[![Build Status](https://travis-ci.org/r-savu/metacritic-score.svg?branch=master)](https://travis-ci.org/r-savu/metacritic-score)

A simple webserver to fetch the top 10 playstation 4 games and their score from metacritic.

## Quick start

### Docker
To run the application in vanilla docker:
```
docker pull rsavu/metacritic-score
docker run -it rsavu/metacritic-score  /opt/server/build/metacritic-score/metacritic-score -p 1234:1234

firefox localhost:1234/games
```

### Kubernetes
To run the kubernetes deployment:
```
kubectl create ns metacritic
kubectl apply -f k8s/
```

A quick localhost kubernetes environment can be obtained by installing minikube, configuring kubectl to use the minikube context and installing the `minikube ingress addon`.
The "external" IP of the ingress can be found by running `kubectl describe ingress --namespace metacritic`.

## Building from source

### Locally
The easiest way of building the application from source is using the latest stable [haskell-stack](https://docs.haskellstack.org/en/stable/README/).

After installing you might need to edit `$HOME/.stack/global-project/stack.yaml` and set `resolver: lts-9.20`, executing `stack solver` after that to install the compiler and initialize the build system.

Once that is done, from the project folder you are ready to build from source:
```
stack build
```
run the tests:
```
stack test
```
and the application:
```
stack exec -- metacritic-scorer
```

You could then access the applcation [locally](http://localhost:1234/games)

### In a docker container

Alternatively, you could run the whole build process (minus the tests) in a docker container by building the Dockerfile:
```
docker build -it my-build .
```
and then run it as described at the top of the README.
