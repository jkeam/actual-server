FROM registry.access.redhat.com/ubi9/nodejs-22:9.5-1736454190
USER 0
RUN mkdir -p /opt/app-root/src/.yarn/berry
RUN chown 1001:0 -R /opt/app-root
USER 1001

# install deps
ENV NODE_ENV=production
COPY .yarn ./.yarn
COPY yarn.lock package.json .yarnrc.yml ./

RUN npm install --global yarn
RUN yarn workspaces focus --all --production

# app files
COPY app.js ./
COPY src ./src
COPY migrations ./migrations

# app
ENTRYPOINT ["/usr/bin/tini","-g",  "--"]
CMD ["node", "app.js"]

