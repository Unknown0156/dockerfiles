FROM node:18.12-alpine
RUN npm install -g gitlab-search
RUN gitlab-search setup --api-domain gitlab.example.ru glpat-token
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]