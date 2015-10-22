EasyTaxi ActiveMQ monitoring
============================

* This project is unsupported * - use it as you want, but know that we have no
guarantee of support in case of any error. As all we do, we really want to do
our best, and will try to help on any problem, but we give you no guarantee of
time, and solutions.

## What is it?

This is a Newrelic plugin used to monitor ActiveMQ. The main idea is to parse
ActiveMQ stats (`/admin/xml/queues.jsp`) and send them to Newrelic.

Currently, we send the following metrics:
 - Total number of consumers
 - Total queue size
 - Jobs enqueued in the last minute
 - Jobs dequeued in the last minute

## Installation

Simply download the latest release and uncompress it in the desired folder. Ex:

```
$ wget https://github.com/easytaxibr/newrelic_activemq/archive/0.0.1.tar.gz
$ tar -zxvf 0.0.1.tar.gz -C /opt
$ ln -sf /opt/newrelic_activemq-0.0.1/ /opt/newrelic_activemq
$ cd /opt/newrelic_activemq && bundle install
```

## Configuration

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

## Monitor

In the plugin installation folder run:

```shell
$ ./newrelic_activemq.rb
```

We strongly encourage you to create a startup script. We provide an example
under `extra/newrelic_activemq-upstart` for Debian. We appreciate a PR with
a sample script of your own distro.
