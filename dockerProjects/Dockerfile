FROM ubuntu
MAINTAINER hvv19890828 <hvv19890828@gmail.com>
RUN apt-get update -y  && \
    apt-get upgrade -y

WORKDIR /root/

COPY Dockerfile /

ENV TEST1 "test1"
ENV TEST2 "test2"

EXPOSE 22

ENTRYPOINT ["sleep"]

CMD ["60"]

