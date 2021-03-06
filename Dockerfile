FROM armhf/alpine:latest
MAINTAINER armswarm

# metadata params
ARG PROJECT_NAME
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF

# metadata
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$PROJECT_NAME \
      org.label-schema.url=$VCS_URL \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor="armswarm" \
      org.label-schema.version="latest"

ARG ODYN_VERSION
ENV ODYN_VERSION=${ODYN_VERSION}

RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \

 && apk add --no-cache ca-certificates \

 && mkdir -p /tmp/dist \

 && curl \
    -s -L "https://github.com/alkar/odyn/releases/download/${ODYN_VERSION}/sha512sum.txt" | \
    grep 'odyn_linux_arm$' > /tmp/sha512sum.txt \

 && curl \
    -so /tmp/dist/odyn_linux_arm \
    -L "https://github.com/alkar/odyn/releases/download/${ODYN_VERSION}/odyn_linux_arm" \

 && cd /tmp \
 && sha512sum -c sha512sum.txt \

 && mv /tmp/dist/odyn_linux_arm /bin/odyn \
 && chmod +x /bin/odyn \

# clean up
 && apk del --purge \
	build-dependencies \
 && rm -rf \
	/tmp/*

ENTRYPOINT ["/bin/odyn"]
