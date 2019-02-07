# from debian stretch backports
FROM gerault/docker-debian-stretch-backports
MAINTAINER Mathieu Gerault <mathieu.gerault@gamil.com>
LABEL Description="Fail2ban server from Mathieu GERAULT"

# fail2ban version
ARG FAIL2BAN_VERSION=0.10.4

# install fail2ban
RUN apt-get update \
	&& apt-get install -y ipset \
	&& apt-get install -y iptables \
	#&& apt-get install -y ip6tables \
	&& apt-get install -y python3 \
	&& apt-get install -y python3-dev \
	&& apt-get install -y ssmtp \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# install fail2ban from sources
RUN wget -O fail2ban.tar.gz "https://github.com/fail2ban/fail2ban/archive/${FAIL2BAN_VERSION}.tar.gz" \
	&& tar --extract --file fail2ban.tar.gz --directory /tmp \
	&& cd /tmp/fail2ban-${FAIL2BAN_VERSION} \
	&& python setup.py install \
	&& rm -rf /tmp/fail2ban-{FAIL2BAN_VERSION} /fail2ban.tar.gz

# entrypoint: the script uses the env parameters to setup fail2ban and then launch the fail2ban-server
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# launch fail2ban in foreground: it is not possible to put fail2ban-client as it creates a fork
CMD ["fail2ban-server", "-f", "-x", "start"]

