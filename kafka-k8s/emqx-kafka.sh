#!/bin/bash

local timeNum=$1
sleep $timeNum
#wait #这个只等待wait前面sleep
cp  /opt/kafka/data/emqx-kafka/{connect-standalone.properties,mqtt-kafka.properties} /etc/kafka
cp  /opt/kafka/data/emqx-kafka/kafka-connect-mqtt-1.1-SNAPSHOT.jar /usr/share/java
cp  /opt/kafka/data/emqx-kafka/org.eclipse.paho.client.mqttv3-1.2.0.jar /usr/share/java/kafka
cd /etc/kafka
connect-standalone ./connect-standalone.properties ./mqtt-kafka.properties    >   /opt/kafka/data/emqx-kafka/out.file  2>&1  &


#下面是后台子线程执行操作
#fun(){
#    local timeNum=$1
#    sleep $timeNum
#    #wait #这个只等待wait前面sleep
#    cp  /opt/kafka/data/emqx-kafka/{connect-standalone.properties,mqtt-kafka.properties} /etc/kafka
#    cp  /opt/kafka/data/emqx-kafka/kafka-connect-mqtt-1.1-SNAPSHOT.jar /usr/share/java
#    cp  /opt/kafka/data/emqx-kafka/org.eclipse.paho.client.mqttv3-1.2.0.jar /usr/share/java/kafka
#    cd /etc/kafka
#    connect-standalone ./connect-standalone.properties ./mqtt-kafka.properties    >   /opt/kafka/data/emqx-kafka/out.file  2>&1  &
#}
#
#fun 120 &
##wait #如果fun里面没有wait，则整个脚本立刻退出，不会等待fun里面的sleep
#echo "all is ending"











