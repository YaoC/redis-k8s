# FROM sporkmonger/redis-k8s:3.2.6
FROM harbor.qyvideo.net/cy/redis-k8s:3.2.6

RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian/ jessie main non-free contrib \n deb http://mirrors.tuna.tsinghua.edu.cn/debian/ jessie-updates main non-free contrib \n deb http://mirrors.tuna.tsinghua.edu.cn/debian/ jessie-backports main non-free contrib \n deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ jessie main non-free contrib \n deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ jessie-updates main non-free contrib \n deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ jessie-backports main non-free contrib \n deb http://mirrors.tuna.tsinghua.edu.cn/debian-security/ jessie/updates main non-free contrib \n deb-src http://mirrors.tuna.tsinghua.edu.cn/debian-security/ jessie/updates main non-free contrib" > /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    dnsutils \
  && rm -rf /var/lib/apt/lists/*

COPY cluster-meet.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/cluster-meet.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD [ "/usr/local/bin/redis-server" ]