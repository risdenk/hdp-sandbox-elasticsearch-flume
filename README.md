# hdp-sandbox-elasticsearch-flume
Hortonworks Blog Post - http://hortonworks.com/blog/configure-elastic-search-hadoop-hdp-2-0/

##Getting Started
### Clone the Repo
1. `git clone https://github.com/risdenk/hdp-sandbox-elasticsearch-flume.git`
2. `cd hdp-sandbox-elasticsearch-flume`

### Run the install
1. `sudo ./install.sh`

### Setup Port Forwarding
Elasticsearch requires port 9200 to be forwarded to use the http interface for Kibana

### View the Result
1. Open [http://localhost:42080/kibana/#/dashboard/file/flume.json](http://localhost:42080/kibana#/dashboard/file/flume.json)
*** By default port 80 is forwarded to 42080 on the HDP 2.0 Sandbox
