# Docker ClickHouse
Docker Image for ClickHouse

## Rationale
[ClickHouse](https://clickhouse.yandex/), a powerful OSS Columnar Database by Yandex provides a [Docker Image](https://hub.docker.com/r/yandex/clickhouse-server/) on DockerHub that allows for testing a single-node setup.
However, there was no such thing as an official image for a scale-out deployment, I decided to build one using Compose.

## Usage
There is a standard Dockerfile, based on CentOS, that installs ClickHouse following their documentation.
The image itself starts-up a [Supervisor](http://supervisord.org/) scheduler that will both handle ClickHouse and additional services you might be willing to start up. As an example, a service uses interprocess messaging to deploy TPC-H like samples on the cluster.

The cluster setup is a simple 2+2 nodes cluster (2 nodes for replication, 2 others fetching data) with Replicated and Distributed tables serving as examples.

The cluster itself is managed through multiple pieces:

 - Nodes are defined in the docker-compose.yml file. They store data on persistent volumes
 - There's a Zookeeper instance to be able to play with [ReplicatedMergeTree](https://clickhouse.yandex/docs/en/operations/table_engines/replication/) tables.
 - If you plan to use Distributed tables, you need to edit the `config.d/remote_servers.xml` file. Follow [ClickHouse documentation](https://clickhouse.yandex/docs/en/operations/table_engines/distributed/) for the precise settings.
