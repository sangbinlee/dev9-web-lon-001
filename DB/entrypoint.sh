#!/bin/bash
# WildFly 실행 백그라운드
/opt/jboss/wildfly/bin/standalone.sh &

# 서버가 뜰 때까지 대기
sleep 20

# CLI 스크립트 실행
/opt/jboss/wildfly/bin/jboss-cli.sh --connect --file=/opt/jboss/wildfly/configure-datasource.cli

# 포그라운드 실행 유지
fg
