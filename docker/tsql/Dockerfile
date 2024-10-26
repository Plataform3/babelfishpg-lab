# Use an official Debian or Alpine image as a base image
FROM debian:latest

# Install FreeTDS package
RUN apt-get update && \
    apt-get install -y freetds-bin && \
    rm -rf /var/lib/apt/lists/*

# Create a configuration file for FreeTDS
RUN echo "[bbf]\n\
    host = bbf\n\
    port = 1433\n\
    tds version = 7.4\n" > /etc/freetds/freetds.conf

# Define entrypoint as tsql
# ENTRYPOINT ["tsql"]
