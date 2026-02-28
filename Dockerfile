#FROM quay.io/wildfly/wildfly:latest
#FROM quay.io/wildfly/wildfly:latest-legacy

#FROM quay.io/wildfly/wildfly:26.1.2.Final
#jdk 11 버전까지만 지원하므로 jdk 21 버전지원하는 이미지 변경해야함. -

# WildFly 34.0.1.Final with JDK 21
FROM quay.io/wildfly/wildfly:34.0.1.Final-jdk21

USER root
ADD DB/mysql-connector-j-9.5.0.jar /opt/jboss/wildfly/modules/system/layers/base/com/mysql/main/
ADD DB/module.xml /opt/jboss/wildfly/modules/system/layers/base/com/mysql/main/
ADD DB/configure-datasource.cli /opt/wildfly/configure-datasource.cli

USER jboss
RUN /opt/wildfly/bin/jboss-cli.sh --file=/opt/wildfly/configure-datasource.cli




COPY target/lon.war /opt/jboss/wildfly/standalone/deployments/lon.war
#   sangbinlee9@k8s-master1:~$ kubectl logs wildfly-app-7875499fc8-7b89f
#Fatal glibc error: CPU does not support x86-64-v2

# Prometheus JMX Agent
#COPY jmx_prometheus_javaagent-0.20.0.jar /opt/jboss/wildfly/jmx_prometheus_javaagent.jar
#COPY config.yml /opt/jboss/wildfly/config.yml

# JBoss LogManager 추가
#COPY jboss-logmanager-2.1.17.Final.jar \
#	/opt/jboss/wildfly/modules/system/layers/base/org/jboss/logmanager/main/
#
#COPY module.xml \
#	/opt/jboss/wildfly/modules/system/layers/base/org/jboss/logmanager/main/


#ENV JAVA_OPTS="-Djava.util.logging.manager=org.jboss.logmanager.LogManager \
#               -javaagent:/opt/jboss/wildfly/jmx_prometheus_javaagent.jar=9404:/opt/jboss/wildfly/config.yml"



#COPY target/dev9-web-lon-001-0.0.1-SNAPSHOT.war /opt/jboss/wildfly/standalone/deployments/lon.war

#COPY target/dev9-web-lon-001-0.0.1-SNAPSHOT.war /opt/jboss/wildfly/standalone/deployments/lon.war
