FROM quay.io/wildfly/wildfly:latest
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.20.0/jmx_prometheus_javaagent-0.20.0.jar /opt/jboss/wildfly/jmx_prometheus_javaagent.jar
COPY config.yml /opt/jboss/wildfly/config.yml

ENV JAVA_OPTS="-javaagent:/opt/jboss/wildfly/jmx_prometheus_javaagent.jar=9404:/opt/jboss/wildfly/config.yml"

COPY target/lon.war /opt/jboss/wildfly/standalone/deployments/
