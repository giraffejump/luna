# Use base image to build the project avoid npm install every time
FROM giraffejump/luna-base:20250609_105214 AS stage-build

ARG VERSION
ENV VERSION=$VERSION

ADD . /data

RUN sed -i "s@version =.*;@version = '${VERSION}';@g" src/environments/environment.prod.ts \
    && yarn build \
    && cp -R src/assets/i18n dist/luna/

FROM nginx:1.24-bullseye
COPY --from=stage-build /data/dist/luna /opt/luna
COPY nginx.conf /etc/nginx/conf.d/default.conf
