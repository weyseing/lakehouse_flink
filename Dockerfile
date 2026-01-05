FROM flink:1.20.0-scala_2.12

# flink lib jars
COPY lib_jars/lib/*.jar /opt/flink/lib/

# terminal settings
RUN echo 'export PS1="\[\e[1;36m\]\t \d\n\[\e[32m\][\[\e[33m\]\u\[\e[31m\]@\[\e[33m\]\h \[\e[36m\]\w\[\e[32m\]]\\$ \[\e[0m\]"' >> /root/.bashrc \
    && echo "alias grep='grep --color=auto'" >> /root/.bashrc \
    && echo "cd /lakehouse_flink/cli" >> /root/.bashrc
    
# entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
