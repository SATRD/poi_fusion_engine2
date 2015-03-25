FROM ubuntu:14.04.2
WORKDIR /root
COPY install.sh /root/
COPY start.sh /root/
COPY test.sh /root/
RUN sh install.sh
RUN chmod +x /root/start.sh
EXPOSE 8080
CMD ["/root/start.sh"]