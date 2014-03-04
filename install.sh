#!/usr/bin/env bash
set -e 
set -o pipefail

# Install Elasticsearch
ES_VER="1.0.1"
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VER}.noarch.rpm
yum install -y elasticsearch-${ES_VER}.noarch.rpm

# Configure Elasticsearch
cp elasticsearch.yml /etc/elasticsearch/
service elasticsearch restart

# Download Kibana
KIBANA_HOME="/opt/kibana"
KIBANA_VER="3.0.0milestone5"
wget https://download.elasticsearch.org/kibana/kibana/kibana-${KIBANA_VER}.tar.gz
tar -C /opt/ -zxvf kibana-${KIBANA_VER}.tar.gz
ln -s /opt/kibana-${KIBANA_VER} $KIBANA_HOME

# Configure Kibana
cp config.js $KIBANA_HOME
cp flume.json ${KIBANA_HOME}/app/dashboards/

# Install Flume
yum install -y flume-agent flume

# Setup Flume
FLUME_HOME=/usr/lib/flume
ES_HOME=/usr/share/elasticsearch

mkdir -p ${FLUME_HOME}/plugins.d/elasticsearch/lib

cp ${ES_HOME}/lib/elasticsearch-*.jar ${FLUME_HOME}/plugins.d/elasticsearch/lib/
cp ${ES_HOME}/lib/lucene-*.jar ${FLUME_HOME}/plugins.d/elasticsearch/lib/

# FIX for https://issues.apache.org/jira/browse/FLUME-2174
rm -f ${FLUME_HOME}/lib/lucene-*.jar

#Update Flume configuration to consume a local file and index into
#Elasticsearch in logstash format.
FLUME_CONF=/etc/flume/conf/
cp flume.conf $FLUME_CONF

# Add test data to /tmp/
cp es_log.log /tmp/

service flume-agent start

# Setup Kibana Web Server
echo "Alias /kibana /opt/kibana" > /etc/httpd/conf.d/kibana.conf

# Fix for Hue Proxy on Sandbox
echo 'ProxyPass /kibana !' | cat - /etc/httpd/conf.d/hue.conf > /tmp/tempHueConf && mv -f /tmp/tempHueConf /etc/httpd/conf.d/hue.conf

service httpd restart
