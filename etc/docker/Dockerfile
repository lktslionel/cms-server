FROM drupal:8.9.1-fpm

LABEL image.maintainer="lktslionel<lktslionel@oui.sncf>"

ARG   PROJECT_NAME
ARG   APP_NAME=$PROJECT_NAME

ARG   CONTAINER_UID=1000
ARG   CONTAINER_GID=1000

ARG DUMB_INIT_PKG_VERSION="1.2.2"

ENV   X_PROJECT_NAME="$PROJECT_NAME"\
      X_DIR="/opt/x"\
      X_BINS_DIR="$X_DIR/bin"\
      X_XTRS_DIR="$X_DIR/extras"\
      # APP 
      X_APP_UID="$CONTAINER_UID"\
      X_APP_GID="$CONTAINER_GID"\
      X_APP_NAME="$APP_NAME"\
      X_APP_HOME_DIR="/home/$X_APP_NAME"\
      X_APP_CONFIG_DIR="$X_APP_HOME/config"\
      X_APP_BINS_DIR="$X_APP_HOME/bin"\
      # OVERRIDES
      PATH="$X_APP_BINS_DIR:$X_BINS_DIR:$PATH"

LABEL x:app:name="$X_PROJECT_NAME"


# SETUP

RUN echo "Create group '$X_APP_NAME($X_APP_GID)'"\
      && addgroup --gid "$X_APP_GID" "$X_APP_NAME"\
      && echo "Create user '$X_APP_NAME($X_APP_UID)'"\
      && useradd $X_APP_NAME --shell /bin/bash --create-home \
            --uid "$X_APP_UID" \
            --gid "$X_APP_GID" \
      && usermod --append --groups sudo $X_APP_NAME \
      && echo "$X_APP_NAME ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN echo "Ensure app core directories are present"\
      && mkdir -p $X_BINS_DIR\
                  $X_XTRS_DIR\
                  $X_APP_HOME_DIR\
                  $X_APP_CONFIG_DIR\
                  $X_APP_BINS_DIR

# Install dumb-init
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_PKG_VERSION}/dumb-init_${DUMB_INIT_PKG_VERSION}_amd64
RUN chmod +x /usr/local/bin/dumb-init


COPY etc/docker/x/* $X_DIR/
RUN chmod -R +x $X_DIR/

# PREPARE
COPY etc/docker/scripts/prepare.sh $X_APP_BINS_DIR/prepare.sh
RUN chmod +x $X_APP_BINS_DIR/prepare.sh
RUN $X_APP_BINS_DIR/prepare.sh

# PROVISION
COPY etc/docker/scripts/provision.sh $X_APP_BINS_DIR/provision.sh
RUN chmod +x $X_APP_BINS_DIR/provision.sh
RUN $X_APP_BINS_DIR/provision.sh

# CONFIGURE
COPY etc/docker/scripts/configure.sh $X_APP_BINS_DIR/configure.sh
RUN chmod +x $X_APP_BINS_DIR/configure.sh
RUN $X_APP_BINS_DIR/configure.sh

# INITIALIZE
COPY etc/docker/scripts/initialize.sh $X_APP_BINS_DIR/initialize.sh
RUN chmod +x $X_APP_BINS_DIR/initialize.sh

# RUN
COPY etc/docker/scripts/run.sh $X_APP_BINS_DIR/run.sh
RUN chmod +x $X_APP_BINS_DIR/run.sh

WORKDIR $X_APP_HOME_DIR

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bash", "-c", "$X_BINS_DIR/entrypoint.sh $X_APP_BINS_DIR/run.sh"]