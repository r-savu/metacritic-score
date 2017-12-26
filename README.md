# Metacritic Score

A simple webserver to fetch the top 10 playstation 4 games and their score from metacritic.

## Quick start

In order to build the software from source you need the following dependencies:

 - Nix -- the package manager
 - haskell-stack
 - Minikube

### Build
 ```
 stack build
 ```

### Run tests
```
stack test
```

### Deploy and run

```
kubectl apply -f deployment.yml
```

### Access the API

http://localhost:8080/games

## Technology/Architecture overview

This project is built using the following technology stack:
 - Haskell - the programming language: for the type-safety, maintainability and computational efficiency (compiler optimizations)
 - Kubernetes and Docker - the current state-of-the art in deployment automation, facilitating highly-avaliable and horizontally scalable deployments
 - TravisCI for continuous integration (having nice integration with GitHub)

### Code structure

The software is comprised of three modules, each defined in a single source file:
 - Types:
     - the REST API (allowing to derive the web router and possibly a Swagger definition and native client-side code including JavaScript)
     - the data-structure of interest: a record schema with two fields, the game title and its score on metacritic and the standard JSON derivation
 - Core, containing the core functionality:
     - The capability of of making HTTP requests for fetching the data from upstream
     - The parser implementation, for extracting the data of interest from HTML and basic error detection (returning `Nothing` on failure)
 - Server, containing:
     - the boilerplate for spawning a web-server, instantiating the web-api defined in `Types`
     - error handling, returning appropriate http error codes depending on failure cases

### Testing/Corectness

Some unit tests can be found in test/Spec.hs, covering the functionality of the parser and the filtering function (for getting the game score by title).
Most of the invariants are encoded in the types and ensured at compile-time by the type system. Further improvement for ensuring corectness could be
made by: writing integration tests to check assumptions on the environment, refining type definitions to encode and verify more invariants at compile time, such as termination and value ranges (such as the score being between 0 and 100) and replacing unit tests with property-based tests, allowing to
programatically generate thousands of unit tests and potentially cover corner-cases which would otherwise be ignored.


### Flow  Diagram
http-client            metacritic-score                      metacritic.com
    |        get: /games      |                                      |
    | ----------------------> |         get /playstation-4           |
    |                         | -----------------------------------> |
    |                         |               res HTML               |
    |        res JSON         | <----------------------------------- |
    | <---------------------- |                                      |
    |                         |                                      |
