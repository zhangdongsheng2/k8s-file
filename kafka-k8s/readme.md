
#K8s 集群内测试命令
```
kafka-topics --create --topic lrdtest --replication-factor 2 --partitions 2 --zookeeper 10.10.13.224:2181
kafka-console-producer --broker-list 10.10.156.80:30092  --topic lrdtest
kafka-console-consumer --bootstrap-server 10.10.156.80:30092   --topic lrdtest
```

#集群外部使用
先配置HostName映射

```
vim /etc/hosts
192.168.188.81 kafka-0
192.168.188.82 kafka-1
192.168.188.83 kafka-2
```
Windows下载工具: SwitchHosts

外部访问地址: 
```
192.168.188.81:30092 
192.168.188.82:30092
192.168.188.83:30092
测试命令
kafka-console-producer --broker-list 192.168.188.81:30092  --topic lrdtest
kafka-console-consumer --bootstrap-server 192.168.188.81:30092  --topic lrdtest
```



##下面暂时不需要,  机器内部设置hostname访问可以设置为
${HOSTNAME}.kafka-headless.lrd-bigdata.svc.cluster.local   : 用这个域名可以在集群内部 pod 之间访问.
hostname + svc:name + 命名空间 + svc + cluster + local

~~#容器修改host~~
1. 安装vim
```shell script
apt-get install vim
#如果显示
Reading package lists... Done
Building dependency tree       
Reading state information... Done
E: Unable to locate package vi
#则需要执行
apt-get update
#然后再执行
apt-get install vim
```

2. 修改hosts  
 **待改进, 对pod设置 svc, 制作镜像时加入host**
```shell script
#示例
vim /etc/hosts
#添加如下, 对应的ip 需要根据pod ip 调整
10.122.208.29   kafka-1.kafka-headless.lrd-bigdata.svc.cluster.local    kafka-1
10.122.201.214  kafka-2.kafka-headless.lrd-bigdata.svc.cluster.local    kafka-2
10.122.146.226  kafka-0.kafka-headless.lrd-bigdata.svc.cluster.local    kafka-0
```


