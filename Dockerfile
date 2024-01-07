FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# title
ENV TITLE=PrusaSlicer \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    firefox-esr \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-pulseaudio \
    gstreamer1.0-qt5 \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    libgstreamer1.0 \
    libgstreamer-plugins-bad1.0 \
    libgstreamer-plugins-base1.0 \
    libwebkit2gtk-4.0-37 \
    libwx-perl \
    libgtk-3-0 \
    unzip \
    pcmanfm \
    vim \
    wget
    

RUN \
  echo "**** install prusaslicer from appimage ****" && \
  cd /tmp && \
  URL=$(curl --silent "https://api.github.com/repos/prusa3d/PrusaSlicer/releases/latest" | grep -i "download_url.*gtk3.*appimage" | sed -E 's/.*"([^"]+)".*/\1/') && \
  wget $URL -O /tmp/prusa.app && \
  chmod +x /tmp/prusa.app && \
  ./prusa.app --appimage-extract && \
  mv squashfs-root /opt/prusaslicer && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
