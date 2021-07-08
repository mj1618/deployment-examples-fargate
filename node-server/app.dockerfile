FROM node:14-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --production
COPY . .
RUN ls /usr/src/app
EXPOSE 8080
CMD [ "node", "server.js" ]
