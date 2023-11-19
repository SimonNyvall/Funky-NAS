FROM postgres:16.1

ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_DB=file_storage

VOLUME /var/lib/postgresql/data

COPY ./init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432


