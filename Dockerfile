
FROM redis:7.4.2-alpine AS redis
COPY conf/redis/redis-conf.sh /redis-conf.sh
RUN chmod +x /redis-conf.sh

FROM billionmail/rspamd:1.2 AS rspamd
COPY conf/rspamd/local.d /etc/rspamd/local.d
COPY conf/rspamd/statistic.conf /etc/rspamd/statistic.conf
COPY conf/rspamd/rspamd.conf /etc/rspamd/rspamd.conf

FROM billionmail/dovecot:1.6 AS dovecot
COPY conf/dovecot/conf.d /etc/dovecot/conf.d
COPY conf/dovecot/dovecot.conf /etc/dovecot/dovecot.conf
COPY conf/dovecot/rsyslog.conf /etc/rsyslog.conf

FROM billionmail/postfix:1.6 AS postfix
COPY conf/postfix/main.cf /etc/postfix/main.cf
COPY conf/postfix/master.cf /etc/postfix/master.cf
COPY conf/postfix/conf /etc/postfix/conf
COPY conf/postfix/sql /etc/postfix/sql
COPY conf/postfix/rsyslog.conf /etc/rsyslog.conf

FROM roundcube/roundcubemail:1.6.11-fpm-alpine AS webmail
COPY conf/webmail /var/roundcube/config
COPY conf/webmail/mime.types /var/roundcube/config/mime.types
COPY conf/php /usr/local/etc

FROM billionmail/core:4.9.3 AS core
COPY conf /opt/billionmail/conf
COPY conf/core/fail2ban/filter.d /etc/fail2ban/filter.d
COPY conf/core/fail2ban/jail.d /etc/fail2ban/jail.d