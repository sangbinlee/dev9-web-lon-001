#!/bin/bash
set -e

# WildFly 서버 시작 (백그라운드)
/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 &

# 서버가 뜰 때까지 대기
sleep 20

# 데이터소스 추가
/opt/jboss/wildfly/bin/jboss-cli.sh --connect --file=/opt/jboss/wildfly/configure-datasource.cli

# 포그라운드 유지
fg %1
