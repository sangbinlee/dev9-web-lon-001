#!/bin/bash

# WildFly 실행 (백그라운드)
/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 &

# 서버가 뜰 때까지 대기 (필요시 조정)
sleep 20

# CLI 스크립트 실행 (서버에 연결)
 /opt/jboss/wildfly/bin/jboss-cli.sh --connect --file=/opt/jboss/wildfly/configure-datasource.cli

# WildFly를 포그라운드로 실행 유지
exec /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0
