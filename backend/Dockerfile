FROM node:8.12.0

WORKDIR /home/node

COPY package.json /home/node

RUN npm install

ADD . /home/node

RUN npm run build; exit 0;

CMD npm run start
#CMD npm run start:prod
