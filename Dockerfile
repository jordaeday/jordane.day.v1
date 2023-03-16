FROM crystallang/crystal:1.7.2-alpine

RUN apk --update --no-cache add \
  bash \
  ca-certificates \
  tzdata

WORKDIR /app/

COPY ./shard.yml ./shard.lock /app/

RUN shards install --frozen

COPY . /app/

ENV CRYSTAL_LOAD_DEBUG_INFO=0
RUN crystal build webby.cr -o /app/jordwebby
EXPOSE 8080
CMD ["/app/jordwebby"]