FROM golang:1.14.2-alpine3.11 AS build
RUN set -ex; \
    apk update; \
    apk add git binutils; \
    git clone https://github.com/Lusitaniae/phpfpm_exporter.git /phpfpm_exporter; \
    cd /phpfpm_exporter; \
    git checkout v0.5.0; \
    go get -d ./...; \
    go build --ldflags '-extldflags "-static"'; \
    ls .; \
    strip phpfpm_exporter


FROM alpine:3.11
COPY --from=build /phpfpm_exporter/phpfpm_exporter /bin/phpfpm_exporter
ENTRYPOINT ["/bin/phpfpm_exporter"]
EXPOSE     9253
