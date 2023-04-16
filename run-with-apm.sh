#!/bin/bash
# set -x

AGENT_VERSION=1.2.0
AGENT_FILE=dd-java-agent-${AGENT_VERSION}.jar

if [ ! -f "${AGENT_FILE}" ]; then
  curl -O  https://repo1.maven.org/maven2/com/datadoghq/dd-java-agent/${AGENT_VERSION}/dd-java-agent-${AGENT_VERSION}.jar
fi
 
./mvnw clean package -Dmaven.test.skip=true

java -javaagent:./${AGENT_FILE} \
-Ddd.profiling.enabled=true \
-XX:FlightRecorderOptions=stackdepth=256 \
-Ddd.logs.injection=true \
-Ddd.service=petclinic \
-Ddd.env=staging \
-Ddd.version=1.0 \
-jar target/spring-petclinic-3.0.0-SNAPSHOT.jar 



# Add this to above if you have a self signed cert for testing 
#-Delastic.apm.profiling_inferred_spans_enabled=true \
#-Delastic.apm.verify_server_cert=false \
#-Delastic.apm.trace_methods="com.bvader.estimator.*" \
#-Delastic.apm.transaction_sample_rat="0.5" \
