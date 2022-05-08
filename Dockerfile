ARG WORK_DIR=/trade_build

FROM node:14.18 as builder

ARG WORK_DIR
ENV PATH ${WORK_DIR}/node_modules/.bin:$PATH

RUN mkdir ${WORK_DIR}
WORKDIR ${WORK_DIR}

COPY package.json ${WORK_DIR}
COPY package-lock.json ${WORK_DIR}

RUN npm install @angular/cli
RUN npm install

COPY . ${WORK_DIR}

RUN ng build --configuration production

FROM nginx:latest

ARG WORK_DIR

COPY --from=builder ${WORK_DIR}/dist/trade-report /usr/share/nginx/html/trade

COPY ./nginx/nginx.conf /etc/nginx/conf.d/trade.conf

CMD nginx -g "daemon off;"