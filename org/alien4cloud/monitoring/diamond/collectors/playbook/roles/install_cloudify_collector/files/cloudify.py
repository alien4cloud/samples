# coding=utf-8

import diamond.collector
import os
import tempfile

class CloudifyCollector(diamond.collector.Collector):

    def proc_count(self, cmd):
        filename = tempfile.mktemp()
        os.system(cmd + " > " + filename)
        count = open(filename).read().strip()
        os.remove(filename)
        return int(count)

    def get_default_config_help(self):
        config_help = super(CloudifyCollector, self).get_default_config_help()
        config_help.update({
        })
        return config_help

    def get_default_config(self):
        """
        Returns the default collector settings
        """
        config = super(CloudifyCollector, self).get_default_config()
        config.update({
            'path':     'cloudify'
        })
        return config

    def collect(self):

        metric_name = "cloudify.mgmtworker.count"
        metric_value = self.proc_count("ps -ef | grep mgmtworker | grep -v grep | wc -l")
        self.publish(metric_name, metric_value)

        metric_name = "cloudify.cloudify_hostpool_plugin.count"
        metric_value = self.proc_count("ps -ef | grep cloudify_hostpool_plugin | grep -v grep | wc -l")
        self.publish(metric_name, metric_value)

        metric_name = "cloudify.task-plugin.count"
        metric_value = self.proc_count("ps -ef | grep task-plugin | grep -v grep | wc -l")
        self.publish(metric_name, metric_value)

        metric_name = "cloudify.task-script_runner.count"
        metric_value = self.proc_count("ps -ef | grep task-script_runner | grep -v grep | wc -l")
        self.publish(metric_name, metric_value)

        metric_name = "cloudify.celery.count"
        metric_value = self.proc_count("ps -ef | grep celery | grep -v grep | wc -l")
        self.publish(metric_name, metric_value)
