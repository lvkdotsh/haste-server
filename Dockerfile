FROM node:15-slim

WORKDIR /app

COPY ./package.json .
COPY ./package-lock.json .

COPY ./about.md .
COPY ./server.js .
COPY ./docker-entrypoint.js .
COPY ./docker-entrypoint.sh .


COPY ./static ./static
COPY ./lib ./lib


RUN npm run-script build

ENV STORAGE_TYPE="file" \
    STORAGE_HOST= \
    STORAGE_PORT= \
    STORAGE_EXPIRE_SECONDS= \
    STORAGE_DB=2 \
    STORAGE_AWS_BUCKET= \
    STORAGE_AWS_REGION= \
    STORAGE_USENAMER= \
    STORAGE_PASSWORD= \
    STORAGE_FILEPATH="./data"

ENV LOGGING_LEVEL=verbose \
    LOGGING_TYPE=Console \
    LOGGING_COLORIZE=true

ENV HOST=0.0.0.0\
    PORT=7777\
    KEY_LENGTH=10\
    MAX_LENGTH=400000\
    STATIC_MAX_AGE=86400\
    RECOMPRESS_STATIC_ASSETS=true

ENV KEYGENERATOR_TYPE=phonetic \
    KEYGENERATOR_KEYSPACE=

ENV RATE_LIMITS_NORMAL_TOTAL_REQUESTS=2000\
    RATE_LIMITS_NORMAL_EVERY_MILLISECONDS=60000 \
    RATE_LIMITS_WHITELIST_TOTAL_REQUESTS= \
    RATE_LIMITS_WHITELIST_EVERY_MILLISECONDS=  \
    # comma separated list for the whitelisted \
    RATE_LIMITS_WHITELIST=example1.whitelist,example2.whitelist \
    \   
    RATE_LIMITS_BLACKLIST_TOTAL_REQUESTS= \
    RATE_LIMITS_BLACKLIST_EVERY_MILLISECONDS= \
    # comma separated list for the blacklisted \
    RATE_LIMITS_BLACKLIST=example1.blacklist,example2.blacklist 
ENV DOCUMENTS=about=./about.md

EXPOSE ${PORT}
ENTRYPOINT [ "bash", "docker-entrypoint.sh" ]

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s \
    --retries=3 CMD [ "curl" , "-f" "localhost:${PORT}", "||", "exit", "1"]

CMD ["node", "."]