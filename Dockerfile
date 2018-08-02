FROM ubuntu:18.04

# apt downloadable tools
RUN /usr/bin/apt-get update && \
    /usr/bin/apt-get -y install \
        apt-transport-https \
        awscli \
        bzip2 \
        ca-certificates \
        curl \
        dnsutils \
        gnupg \
        iputils-ping \
        jq \
        libpython2.7-stdlib \
        libyaml-0-2 \
        locales \
        make \
        man-db \
        mysql-client \
        netcat-openbsd \
        ngrep \
        openssh-client \
        postgresql-client \
        python-virtualenv \
        python2.7 \
        python2.7-minimal \
        rsync \
        runit \
        screen \
        sudo \
        vim \
        wget \
        whois \
        zsh && \
    /usr/bin/apt-get clean && \
    /bin/rm -rf /var/lib/apt/lists/*

# Google Cloud SDK
ENV GOOGLE_SDK_LOCATION /opt
ENV GOOGLE_SDK_VERSION 192.0.0
RUN /bin/mkdir -p "${GOOGLE_SDK_LOCATION}" && \
    /usr/bin/curl --fail https://storage.googleapis.com/cloud-sdk-release/google-cloud-sdk-${GOOGLE_SDK_VERSION}-linux-x86_64.tar.gz | /bin/tar -C "${GOOGLE_SDK_LOCATION}" -xvzf - && \
    cd "${GOOGLE_SDK_LOCATION}/google-cloud-sdk" && \
    CLOUDSDK_CORE_DISABLE_PROMPTS=1 ./install.sh

# Install kubectl into the SDK deployment.
RUN CLOUDSDK_CORE_DISABLE_PROMPTS=1 "${GOOGLE_SDK_LOCATION}/google-cloud-sdk/bin/gcloud" components install kubectl

# Prevent annoying notifications about updates.
RUN "${GOOGLE_SDK_LOCATION}/google-cloud-sdk/bin/gcloud" config set component_manager/disable_update_check true

ADD etc /etc
RUN /usr/sbin/locale-gen
