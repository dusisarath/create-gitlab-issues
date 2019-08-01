#license: Licensed Materials - Property of IBM
#copyright: (c) Copyright IBM Corporation 2019 All Rights Reserved.
#note: Note to U.S. Government Users Restricted Rights: Use, duplication or disclosure restricted by GSA ADP
#Schedule Contract with IBM Corp.

FROM node:8.12-alpine

# apk packages we want
RUN apk add --no-cache tini bash

# Docker run settings
EXPOSE 8000
ENTRYPOINT ["/sbin/tini", "-vg", "--"]

# COPY dependencies
WORKDIR /usr/src/app
COPY package.json .

# INSTALL dependencies
RUN npm install --silent \
    # app should create its own logging dirs...
    && mkdir -p /usr/src/app/logs

# add group and user - uid = 1104, gid = 1105
RUN addgroup -g 1105 coreuser && \
    adduser -u 1104 -G coreuser -s /bin/sh -D coreuser
USER coreuser

# Bundle app source (see .dockerignore)
COPY . .

CMD ["node gitlab-issue-creator.js"]
