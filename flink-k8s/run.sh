#!/bin/bash

FLINK_JOB_MANAGER_SH=$FLINK_HOME/bin/jobmanager.sh
FLINK_TASK_MANAGER_SH=$FLINK_HOME/bin/taskmanager.sh

case "$1" in
"jobmanager")
$FLINK_JOB_MANAGER_SH start # 后台启动, 然后用下面代码, 找到日志文件并持续输出
while :;
  do
    if [[ -f $(find $FLINK_HOME/log -name '*standalonesession*.log' -print -quit) ]];
      then tail -f -n +1 $FLINK_HOME/log/*standalonesession*.log;
    fi;
  done
;;

"taskmanager")
$FLINK_TASK_MANAGER_SH start  # 后台启动, 然后用下面代码, 找到日志文件并持续输出 这样可以保留日志文件
while :;
do
  if [[ -f $(find $FLINK_HOME/log -name '*taskexecutor*.log' -print -quit) ]];
    then tail -f -n +1 $FLINK_HOME/log/*taskexecutor*.log;
  fi;
done
;;
*)
echo "COMMAND ERROR"
;;
esac