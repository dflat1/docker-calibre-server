FROM --platform=linux/amd64 ubuntu:latest

# Linux install instructions: 
# https://calibre-ebook.com/download_linux
# https://manual.calibre-ebook.com/generated/en/calibre-server.html
# https://manual.calibre-ebook.com/server.html

RUN apt-get update && apt-get install -y curl xz-utils wget 

ARG CALIBRE_RELEASE="7.12.0"

RUN curl -o /tmp/calibre-tarball.txz -L "https://download.calibre-ebook.com/${CALIBRE_RELEASE}/calibre-${CALIBRE_RELEASE}-x86_64.txz" && \
    mkdir -p /opt/calibre && \
    tar xvf /tmp/calibre-tarball.txz -C /opt/calibre && \
    rm -rf /tmp/*


FROM --platform=linux/amd64 debian:stable-slim

RUN apt-get update && apt-get install -y \
    dnsutils \
    iproute2 \
    python3 xdg-utils \
    libegl1 libopengl0 	libfontconfig1 libxkbcommon0 libnss3 libxcomposite1 libqt6pdf6 qt6-image-formats-plugin-pdf libqpdf-dev  ## libxcb-xinerama0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 
    && rm -rf /var/lib/apt/lists/*
COPY --from=0 /opt/calibre /opt/calibre
RUN /opt/calibre/calibre_postinstall && \
    mkdir /library && \
    touch /library/metadata.db

COPY start-calibre-server.sh .

EXPOSE 8080
CMD [ "/start-calibre-server.sh" ]
