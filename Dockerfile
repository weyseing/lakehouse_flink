FROM flink:1.20.0-scala_2.12

# flink lib jars
COPY lib_jars/lib/*.jar /opt/flink/lib/

# work dir
WORKDIR /lakehouse_flink/cli

# terminal settings
RUN echo 'export PS1="\[$(tput bold)\]\[$(tput setaf 6)\]\\t \\d\\n\[$(tput setaf 2)\][\[$(tput setaf 3)\]\u\[$(tput setaf 1)\]@\[$(tput setaf 3)\]\h \[$(tput setaf 6)\]\w\[$(tput setaf 2)\]]\[$(tput setaf 4)\\]\\$ \[$(tput sgr0)\]"' >> /root/.bashrc \
    && echo "alias grep='grep --color=auto'" >> /root/.bashrc
    
# entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
