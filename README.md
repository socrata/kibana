# Kibana

We use Kibana to monitor the [catalog
service](https://github.com/socrata/catalog-service) and
[spandex](https://github.com/socrata-platform/spandex) Elasticsearch clusters.
This repository doesn't contain the source for Kibana. It exists so that we can
build our own Kibana docker image with Jenkins for deployment to whatever
environment.

To learn more about Kibana, check out Elastic's [Kibana
repository](https://github.com/elastic/kibana).

## Getting Started

If you'd like to start and stop Kibana with [solo](https://github.com/socrata/solo)
then run `solo register` from the root of this repository. Now you'll be able to
run `solo start kibana` or `solo start kibana --container`. The former will
download the kibana source in the `src` dir at the root of this repository,
where the latter will pull a docker imag from our `internal/kibana` ecr
repository.

## Making Changes

If you plan to make changes to the kibana application in any of our
environments, you may want to take a look at
- [apps marathon](https://github.com/socrata/apps-marathon/)
  - look for `json` / `toml` files named `kibana-catalog` or `kibana-spandex`. 
- [jenkinks > jobs > kibana](https://jenkins-build.socrata.com/job/kibana/)
  - there are a few command line arguments that the `kibana` job passes to the
    `dockerize` job that distinguish the spandex and catalog builds

If you are making changes to the docker image, you'll probably want to build a
local image with this command:

```
docker build -t "kibana:test_build" --build-arg docker_version=7.3.2 .
```

## Deploying

The following command will deploy the kibana-catalog application via apps-marathon
to our staging environment:

```sh
bundle exec rake "marathon:app:deploy[kibana-catalog,kibana:7.3.2_37_d3247d33,staging]"
```

Swap out the `kibana-catalog` app identifer for `kibana-spandex` to deploy a version for the
Spandex cluster and swap out the environment by changing `staging` to your environment of choice.
