FROM mysql:5.7

MAINTAINER Hua(Nelson) Qiao

COPY custom.cnf /etc/mysql/conf.d/ 

# bypass mysql volume configuration to retain data inside container
RUN mkdir /var/lib/mysql-local-datadir
CMD ["--datadir", "/var/lib/mysql-local-datadir"]
