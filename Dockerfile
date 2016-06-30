FROM dklawren/docker-bugzilla
MAINTAINER Simon Xie <thimoon@sina.com>

# Environment configuration
ENV GITHUB_BASE_BRANCH 5.0


# data vol
VOLUME ['/bak']

# Clean v4.4 codes and use 5.0.2
COPY bugzilla-5.0.2.tar.gz  /bugzilla-5.0.2.tar.gz
RUN rm -rf $BUGZILLA_ROOT/* ;tar zxf /bugzilla-5.0.2.tar.gz; mv /bugzilla-5.0.2/* $BUGZILLA_ROOT/ ; rm -rf /bugzilla-5.0.2/


# MySQL configuration
COPY my.cnf /etc/my.cnf
RUN chmod 644 /etc/my.cnf \
    && chown root.root /etc/my.cnf \
    && rm -rf /etc/mysql \
    && rm -rf /var/lib/mysql/* \
    && /usr/bin/mysql_install_db --user=$BUGZILLA_USER --basedir=/usr --datadir=/var/lib/mysql

# Bugzilla dependencies and setup
RUN rm -rf  /checksetup_answers.txt /install_deps.sh /bugzilla_config.sh /my_config.sh
COPY checksetup_answers.txt *.sh /
RUN chmod +x /*.sh; /install_deps.sh
RUN /bugzilla_config.sh ; rm -f /*.tar.gz


# Final permissions fix
RUN chown -R $BUGZILLA_USER.$BUGZILLA_USER $BUGZILLA_HOME

# Networking
EXPOSE 80
EXPOSE 22
EXPOSE 5900


# Start
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]