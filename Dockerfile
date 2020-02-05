
# build container image to deploy app 
FROM dva-registry.internal.salesforce.com/dva/sfdc_centos7

#argument APP: the app binary name
ARG APP

#REPO is the source home
ARG REPO

#BIN_HOME:where the binary being deployed, default to /bin
ARG BIN_HOME=/bin
ARG USER=oracle
ARG GROUP=dba

WORKDIR ${BIN_HOME}
ADD ${APP} ${BIN_HOME}/${APP}

#copy the binary file from docker image built in prior stage
# COPY --from=build-env $REPO/${APP} .

# docker run command can overwritten the start up cmd 
CMD ["/bin/ursa"]

EXPOSE 9090
RUN groupadd --system --gid 7447 ${GROUP}
RUN adduser --system --gid 7447 --uid 7447 ${USER}
RUN chmod 755 "${BIN_HOME}/${APP}"

