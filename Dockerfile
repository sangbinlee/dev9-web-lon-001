FROM quay.io/wildfly/wildfly:34.0.1.Final-jdk21

# 환경변수 기본값 설정 (운영 시 docker run -e 로 덮어쓰기 가능)
ENV MYSQL_HOST=db \
    MYSQL_PORT=3306 \
	MYSQL_DATABASE=londb \
	MYSQL_USER=lonuser \
	MYSQL_PASSWORD=lonpass

COPY target/lon.war /opt/jboss/wildfly/standalone/deployments/lon.war

COPY ./DB/mysql-connector-j-9.5.0.jar /opt/jboss/wildfly/standalone/deployments/

COPY ./DB/configure-datasource.cli /opt/jboss/wildfly/configure-datasource.cli

COPY --chmod=755 DB/entrypoint.sh /opt/jboss/wildfly/entrypoint.sh

#ENTRYPOINT ["/opt/jboss/wildfly/entrypoint.sh"]