FROM ubuntu
MAINTAINER lg
ENV SCALA_VERSION=2.10.4
RUN apt-get update &&     apt-get upgrade -y &&     apt-get install -y curl openjdk-7-jre-headless &&     curl -SL http://packages.confluent.io/deb/1.0/archive.key | apt-key add - &&     echo 'deb [arch=all] http://packages.confluent.io/deb/1.0 stable main' >> /etc/apt/sources.list &&     apt-get update &&     apt-get install -y confluent-platform-${SCALA_VERSION}  
ENV ZK_DATA_DIR=/var/lib/zookeeper
ENV CONFLUENT_USER=confluent
ENV CONFLUENT_GROUP=confluent
ENV KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:/etc/kafka/log4j.properties
RUN curl --location --silent --insecure --output /usr/local/bin/zk-docker.sh https://raw.githubusercontent.com/lgforgithub/mykafka/master/zk-docker.sh
RUN -c rm /etc/kafka/log4j.properties &&    echo 'log4j.rootLogger=INFO, stdout' >> /etc/kafka/log4j.properties &&    echo 'log4j.appender.stdout=org.apache.log4j.ConsoleAppender' >> /etc/kafka/log4j.properties &&    echo 'log4j.appender.stdout.layout=org.apache.log4j.PatternLayout' >> /etc/kafka/log4j.properties &&    echo 'log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n' >> /etc/kafka/log4j.properties &&    groupadd -r ${CONFLUENT_GROUP} &&    useradd -r -g ${CONFLUENT_GROUP} ${CONFLUENT_USER} &&    mkdir ${ZK_DATA_DIR} &&    chown -R ${CONFLUENT_GROUP}:${CONFLUENT_USER} ${ZK_DATA_DIR} /usr/local/bin/zk-docker.sh /etc/kafka/zookeeper.properties &&    chmod +x /usr/local/bin/zk-docker.sh 
USER [confluent]
VOLUME [/var/lib/zookeeper]
EXPOSE 2181/tcp 2888/tcp 3888/tcp