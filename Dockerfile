FROM docker:20.10.6

RUN apk add --no-cache ca-certificates

ENV GOLANG_VERSION 1.16.3


COPY *.patch /go-alpine-patches/

RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		bash \
		gcc \
		musl-dev \
		openssl \
		go \
	; \
	export \
# set GOROOT_BOOTSTRAP such that we can actually build Go
		GOROOT_BOOTSTRAP="$(go env GOROOT)" \
# ... and set "cross-building" related vars to the installed system's values so that we create a build targeting the proper arch
# (for example, if our build host is GOARCH=amd64, but our build env/image is GOARCH=386, our build needs GOARCH=386)
		GOOS="$(go env GOOS)" \
		GOARCH="$(go env GOARCH)" \
		GO386="$(go env GO386)" \
		GOARM="$(go env GOARM)" \
		GOHOSTOS="$(go env GOHOSTOS)" \
		GOHOSTARCH="$(go env GOHOSTARCH)" \
	; \
	\
	wget -O go.tgz "https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz"; \
	echo '4949fd1a5a4954eb54dd208f2f412e720e23f32c91203116bed0387cf5d0ff2d *go.tgz' | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
	cd /usr/local/go/src; \
	for p in /go-alpine-patches/*.patch; do \
		[ -f "$p" ] || continue; \
		patch -p2 -i "$p"; \
	done; \
	./make.bash; \
	\
	rm -rf /go-alpine-patches; \
	apk del .build-deps; \
	\
	export PATH="/usr/local/go/bin:$PATH"; \
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

# Install xgo
RUN \
	apk add --no-cache git && \
	go get github.com/vdovhanych/xgo
