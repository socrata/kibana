FROM socrata/runit-nodejs-bionic-10x

# $docker_version should be passed here using the --build-arg flag
# configure this in the dockerize jenkins task with DOCKER_BUILD_ARGS
ARG docker_version

# required until runit base image correctly sets ark_host
ENV ARK_HOST aws-private
ENV LOG_LEVEL info

ENV APP kibana
ENV KIBANA_SOURCE src
ENV CONFIG ${APP}.yml
ENV ROOT_DIR /srv/${APP}/
ENV SERVICE_DIR /etc/service
ENV APP_DIR /etc/service/${APP}
ENV SERVICE_PORT 5601

RUN apt-get update && apt-get install -y wget

# get the source
COPY download_kibana.sh $SERVICE_DIR
RUN cd $SERVICE_DIR && $SERVICE_DIR/download_kibana.sh $docker_version
RUN rm $SERVICE_DIR/download_kibana.sh

# cleanup
RUN chown --recursive socrata $APP_DIR
RUN rm $APP_DIR/config/*

# finish setup
COPY runit $APP_DIR
COPY $CONFIG.j2 $APP_DIR/config/$CONFIG.j2

RUN chown socrata $APP_DIR/config/$CONFIG.j2

EXPOSE ${SERVICE_PORT}
