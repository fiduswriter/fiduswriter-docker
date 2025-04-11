# vim: set ts=4 sw=4 sts=0 sta et :
FROM ubuntu:24.04
EXPOSE 8000:8000
ENV VERSION 4.0.8

# Executing group, with fixed group id
ENV EXECUTING_GROUP fiduswriter
ENV EXECUTING_GROUP_ID 999

# Executing user, with fixed user id
ENV EXECUTING_USER fiduswriter
ENV EXECUTING_USER_ID 999

# Data volume, should be owned by 999:999 to ensure the application can
# function correctly. Run `chown 999:999 <data-dir-path>` on the host OS to
# get this right.
VOLUME ["/data"]

# Create user and group with fixed ID, instead of allowing the OS to pick one.
RUN groupadd \
        --system \
        --gid ${EXECUTING_GROUP_ID} \
        ${EXECUTING_GROUP} \
    && useradd \
        --system \
        --create-home \
         --no-log-init \
        --uid ${EXECUTING_USER_ID} \
        --gid ${EXECUTING_GROUP} \
        ${EXECUTING_USER}

# Chain apt-get update, apt-get install and the removal of the lists.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y \
        build-essential \
        gettext \
        git \
        libjpeg-dev \
        npm \
        python3-venv \
        python3-dev \
        python3-pip \
        unzip \
        wget \
        zlib1g-dev \
        curl \
        rsync \
        libmagic-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_22.x | bash
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# Working directories should be absolute.
WORKDIR /fiduswriter

# Data folder must exist. It could be mapped if you like to make it persistent.
RUN mkdir -p /data/media
RUN chown -R ${EXECUTING_USER}:${EXECUTING_GROUP} /data
RUN chmod -R 755 /data

# Create virtual environment with the right permissions
RUN python3 -m venv venv
RUN chown -R ${EXECUTING_USER}:${EXECUTING_GROUP} /fiduswriter

# Install packages
RUN venv/bin/pip install --upgrade setuptools
RUN venv/bin/pip install fiduswriter[books,citation-api-import,languagetool,ojs,pandoc,gitrepo-export,phplist,payment-paddle,website]==${VERSION}
RUN venv/bin/pip install --upgrade pip wheel

COPY start-fiduswriter.sh /etc/start-fiduswriter.sh
RUN chmod +x /etc/start-fiduswriter.sh

# Make sure the data directory is writable by the Fidus Writer user
USER ${EXECUTING_USER}

CMD ["/bin/sh", "/etc/start-fiduswriter.sh"]
