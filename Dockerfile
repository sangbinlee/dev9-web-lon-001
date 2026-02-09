FROM quay.io/wildfly/wildfly:latest
COPY jmx_prometheus_javaagent-0.20.0.jar /opt/jboss/wildfly/jmx_prometheus_javaagent.jar
COPY config.yml /opt/jboss/wildfly/config.yml


# JBoss LogManager 추가
COPY jboss-logmanager-2.1.17.Final.jar /opt/jboss/wildfly/modules/system/layers/base/org/jboss/logmanager/main/


#ENV JAVA_OPTS="-javaagent:/opt/jboss/wildfly/jmx_prometheus_javaagent.jar=9404:/opt/jboss/wildfly/config.yml"
ENV JAVA_OPTS="-Djava.util.logging.manager=org.jboss.logmanager.LogManager \
               -javaagent:/opt/jboss/wildfly/jmx_prometheus_javaagent.jar=9404:/opt/jboss/wildfly/config.yml"



COPY target/*.war /opt/jboss/wildfly/standalone/deployments/
