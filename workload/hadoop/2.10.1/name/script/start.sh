#!/bin/bash

if [ ! -d '/opt/hadoop/data/current' ]; then
  /usr/local/lib/hadoop/bin/hdfs namenode -format hadoop-cluster
fi
/usr/local/lib/hadoop/sbin/hadoop-daemon.sh start namenode
