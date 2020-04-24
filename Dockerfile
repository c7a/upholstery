FROM node:10.15-alpine
ARG node_env=production

WORKDIR /upholstery
RUN chown -R node:node .

USER node

ENV NODE_ENV=$node_env

COPY --chown=node:node package.json yarn.lock ./

RUN if [ $NODE_ENV = "development" ]; \
  then yarn install --dev; \
  else yarn install; \
  fi

COPY --chown=node:node *.js ./

# Copy files from the https://github.com/crkn-rcdr/d10n subproject
COPY d10n/workflow/www/demo demo

# Sets default server, which can be overridden at run time
ENV COUCH http://iris.tor.c7a.ca:5984

EXPOSE 8080
CMD yarn run start
