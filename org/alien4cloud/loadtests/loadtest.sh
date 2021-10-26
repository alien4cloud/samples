#!/bin/bash -e

export A4C_LOOP_COUNT=2
export A4C_TEST_NAME=MockLoadTest
export A4C_USER_COUNT=2
export A4C_RAMPUP_DELAY=0
export JMETER_HOME=/opt/jmeter/apache-jmeter
export JMETER_RESULT_DIR=/opt/jmeter/results
export A4C_PROTOCOL=http
export A4C_IP=34.255.161.200
export A4C_PORT=8088
export A4C_BASE=
export A4C_USR=admin
export A4C_PWD=admin
export A4C_TEARDOWN=true
export A4C_TEMPLATE=2ParallelMocks:2.1.0-SNAPSHOT

# to Create Deploy, wait for deployment finished, then eventually Undeploy Delete
export JMETER_PLAN=/opt/jmeter/loadtests/application.jmx
 
echo "StartUp" && export A4C_UP_COUNT=${A4C_USER_COUNT} && $JMETER_HOME/bin/jmeter.sh -n -JloopCount=${A4C_LOOP_COUNT} -JtearDown=${A4C_TEARDOWN} -JresultFolder=$JMETER_RESULT_DIR -JstartUp_user_count=$A4C_UP_COUNT -JtearDown_user_count=$A4C_DOWN_COUNT -JapplicationNamePrefix=${A4C_TEST_NAME} -JtopologyTemplateVersionId=$A4C_TEMPLATE -Ja4c_ip=$A4C_IP -JrampUp=$A4C_RAMPUP_DELAY -Ja4c_port=$A4C_PORT -Ja4c_user=$A4C_USR -Ja4c_pwd=$A4C_PWD -Ja4c_protocol=$A4C_PROTOCOL -Ja4c_base=$A4C_BASE -t $JMETER_PLAN -l $JMETER_RESULT_DIR/$A4C_TEST_NAME.jtl -j $JMETER_RESULT_DIR/$A4C_TEST_NAME.log

