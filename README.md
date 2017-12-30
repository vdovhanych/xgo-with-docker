# xgo-with-docker

## About this repository

This repository added `go` and `xgo` on top of the official docker image. It is used for running `xgo` in **GitLab CI** pipeline with **Docker** executor.

The installed `xgo` is forked from the official repository with the following changes.

1. Added `libpcap` library in the `xgo` base image.
1. Make the `xgo` container mount point writable.
1. Copy the built binary by `xgo` to a folder named `xgo-dist`.

Without point number 2 and 3, i couldn't get the built binary in the GitLab pipeline. For more info, you could refer to the following issue.

- [Problem when compilng go binary using xgo with dind](https://gitlab.com/gitlab-com/support-forum/issues/2620)

### Versions

1. Docker: docker:17.09.0-ce (alpine:3.6 base)
1. Go: 1.8.5 (alpine:3.6 base)
1. xgo: [ykyuen/xgo:latest](https://github.com/ykyuen/xgo)

## Docker Hub

This **Docker** image is available on [Docker Hub](https://hub.docker.com/r/ykyuen/xgo-with-docker/).