FROM ubuntu AS pohuy

ARG USSR=hvv 

ARG PSS=user1!

MAINTAINER hvv19890828 <hvv19890828@gmail.com>

LABEL usver="hvv"

RUN apt-get update -y  && \
    apt-get upgrade -y

RUN useradd -m hvv

RUN usermod -aG sudo hvv

RUN echo $USSR:$PSS | chpasswd

USER hvv

WORKDIR /home/hvv/

#ADD ftp://foo.foo.foo.zip .

COPY test .

VOLUME /foo

RUN echo "test build-stage 1" >> test

ONBUILD RUN echo "hello"

ENV TEST1 "test1"
ENV TEST2 "test2"

EXPOSE 22

ENTRYPOINT ["sleep"]

CMD ["300"]



FROM pohuy AS pohuyx2

WORKDIR /root/

COPY --from=pohuy /home/hvv/test .

ENTRYPOINT ["sleep"]

CMD ["300"]
