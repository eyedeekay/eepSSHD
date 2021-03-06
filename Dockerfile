FROM debian:sid
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y gpg ca-certificates
RUN echo "deb http://repo.lngserv.ru/debian stretch main" | tee /etc/apt/sources.list.d/i2pd.list
RUN echo "deb-src http://repo.lngserv.ru/debian stretch main" | tee -a /etc/apt/sources.list.d/i2pd.list
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv 66F6C87B98EBCFE2 || \
    apt-key adv --keyserver pgp.mit.edu --recv-keys 66F6C87B98EBCFE2 || \
    apt-key adv --keyserver keyserver.ubuntu.com --recv 66F6C87B98EBCFE2 || \
    apt-key adv --keyserver keyserver.pgp.com --recv 66F6C87B98EBCFE2
RUN apt-get update && apt-get install -y i2pd
COPY etc/i2pd/tunnels.sshd.conf /etc/i2pd/tunnels.conf
COPY etc/i2pd/i2pd.sshd.conf /etc/i2pd/i2pd.conf
CMD chown -R i2pd:i2pd /var/lib/i2pd; \
    ln -sf /usr/share/i2pd/certificates /var/lib/i2pd/certificates; \
    ln -sf /etc/i2pd/subscriptions.txt /var/lib/i2pd/subscriptions.txt; \
    su - -c "i2pd i2pd --service --loglevel=info \
        --conf=/etc/i2pd/i2pd.conf \
        --tunconf=/etc/i2pd/tunnels.conf \
        --log=/var/log/i2pd/log"; \
    sleep 5; \
    tail -f /var/log/i2pd/log
