# build environment
FROM node:9.11.2-alpine as builder
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package*.json /usr/src/app/
RUN npm install --silent
COPY . /usr/src/app/
RUN npm run build

# production environment
FROM nginx:1.15.1-alpine
RUN rm -rf /etc/nginx/conf.d
COPY nginx.conf /etc/nginx/conf.d
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]