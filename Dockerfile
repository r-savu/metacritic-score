FROM haskell:8 as builder

WORKDIR /opt/server
RUN cabal update
COPY metacritic-score.cabal .
RUN cabal install --dependencies-only -j4
ADD . .
RUN cabal install

FROM phusion/baseimage
WORKDIR /opt/server
COPY --from=builder /opt/server/dist .
