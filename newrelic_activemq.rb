#! /usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'newrelic_plugin'
require_relative 'lib/queue_data'
require_relative 'lib/activemq_stats'

module NewrelicActiveMQ
  class Agent < NewRelic::Plugin::Agent::Base
    agent_guid 'newrelic.activemq.monitor'
    agent_version '0.0.1'

    agent_config_options :activemq_url
    agent_config_options :activemq_user
    agent_config_options :activemq_password
    agent_config_options :queue_name
    agent_config_options :debug

    agent_human_labels('ActiveMQ') { "Queue #{queue_name}" }

    attr_accessor :last_queue_stats

    def poll_cycle
      queue_data = ActiveMQStats.new(
        activemq_url,
        activemq_user,
        activemq_password
      ).request(queue_name)

      data_to_report = self.last_queue_stats ? (queue_data - self.last_queue_stats) : queue_data

      self.last_queue_stats = queue_data
      report(data_to_report)
    end

    def report(data)
      report_or_print('queue_size', 'jobs', data.size)
      report_or_print('consumers', 'value', data.consumers)
      report_or_print('jobs_enqueued', 'enqueued/min', data.enqueued)
      report_or_print('jobs_dequeued', 'dequeued/min', data.dequeued)
    end

    def report_or_print(metric, unit, value)
      debug ? puts("#{metric}[#{unit}]: #{value}") : report_metric(metric, unit, value)
    end
  end

  config_file = File.join(File.dirname(__FILE__), 'config/newrelic_plugin.yml')
  NewRelic::Plugin::Config.config_file = config_file
  NewRelic::Plugin::Setup.install_agent :activemq, NewrelicActiveMQ
  NewRelic::Plugin::Run.setup_and_run
end
