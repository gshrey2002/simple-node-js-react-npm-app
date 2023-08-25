FROM node:12.2.0-alpine
WORKDIR app
COPY . .
RUN apk update && \
    apk upgrade && \
    apk add --no-cache npm
RUN npm install
EXPOSE 3000
CMD ["node","App.js"]
