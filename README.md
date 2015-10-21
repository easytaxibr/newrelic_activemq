EasyTaxi ActiveMQ monitoring
============================

* This project is unsupported * - use it as you want, but know that we have no
guarantee of support in case of any error. As all we do, we really want to do
our best, and will try to help on any problem, but we give you no guarantee of
time, and solutions.

## What is it?

This project was created to monitor ActiveMQ. The main idea is to consume
ActiveMQ stats page (`/admin/xml/queues.jsp`) and send it to Newrelic.

By now, the metrics sent are:
 - Total number of consumers
 - Total queue size
 - Jobs enqueued on the last minute
 - Jobs dequeued on the last minute

## Installing

The installation process is a simple download of the last release, uncompress
on the desired folder. Ex:

```
$ wget https://github.com/easytaxibr/newrelic_activemq/archive/0.0.1.tar.gz
$ tar -zxvf 0.0.1.tar.gz -C /opt
$ ln -sf /opt/newrelic_activemq-0.0.1/ /opt/newrelic_activemq
$ cd /opt/newrelic_activemq && bundle install
```

## Configuring

To configure the project, just copy the `config/newrelic_plugin.yml.sample` to
`config/newrelic_plugin.yml`:

```shell
$ cp config/newrelic_plugin.yml.sample config/newrelic_plugin.yml
```

After that configure the queues you want to monitor. For a single queue:

```yaml
  activemq:
    queue_name: lets_monitor
    activemq_url: http://activemq-server.yourdomain.com:8161
    activemq_user: admin
    activemq_password: 123
```

For multiple queues, you can simple use an array:

```yaml
  activemq:
    -
      queue_name: lets_monitor
      activemq_url: http://activemq-server.yourdomain.com:8161
      activemq_user: admin
      activemq_password: 123
    -
      queue_name: lets_monitor_other_queue
      activemq_url: http://activemq-server.yourdomain.com:8161
      activemq_user: admin
      activemq_password: 123
```

## Running

On the plugin installation folder run:

```shell
$ ./newrelic_activemq.rb
```

We strongly encourage to create a startup script. We are providing an example
on `extra/newrelic_activemq-upstart` for Debian. If you use some other linux
distribution, we appreciate any PR with the example for your distro.
