#基于kubernetes部署的两种方式
* 直接使用kubernetes作为集群管理器(Cluster Manager)，类似与mesos和yarn,使用方式可以看running-on-kubernetes。k8s版本大于1.6，Spark版本2.3.0 或以上
* 第二种方式是standalone的方式, 自己制作镜像在K8s上部署集群
* 相关文件: 链接: https://pan.baidu.com/s/1GwMTqoKxQyjpz8ZPtxumQw 提取码: km1r 
#使用第一种方式
https://spark.apache.org/docs/2.3.0/running-on-kubernetes.html  官方地址


* 应用程序打包放到 jars 下面. 构建完成镜像后提交任务.

###Dockerfile
```dockerfile
#Spark Dockerfile 中添加如下内容, 如果不更新这个jar会出现 http 403 错误 
#关联连接: https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/issues/591
RUN rm $SPARK_HOME/jars/kubernetes-client-3.0.0.jar
ADD https://repo1.maven.org/maven2/io/fabric8/kubernetes-client/4.4.2/kubernetes-client-4.4.2.jar $SPARK_HOME/jars
```

###镜像制作示例

```shell script
bin/docker-image-tool.sh  -t  my-tag-SparkDemo3  build  #构建镜像
sudo docker tag [ImageId] registry.cn-shanghai.aliyuncs.com/zhangdongsheng/spark-k8s:2.3.2.3.0
sudo docker push registry.cn-shanghai.aliyuncs.com/zhangdongsheng/spark-k8s:2.3.2.3.0  #推送镜像到阿里云
```

###根据命名空间创建授权, 在启用了RBAC的 Kubernetes群集中
```shell script
--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark
kubectl create serviceaccount spark
kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=lrd-bigdata:spark --namespace=lrd-bigdata
``` 


### 提交任务的文件夹需要替换文件  kubernetes-client-4.4.2.jar kubernetes-model-4.4.2.jar  kubernetes-model-common-4.4.2.jar
##提交任务示例
```shell script
bin/spark-submit \
    --master k8s://https://192.168.188.34:6443  \
    --deploy-mode cluster \
    --name spark-pi \ //应用名称
    --class com.spark.demo.SparkKafkaDemo \
    --conf spark.executor.instances=2 \   //多少executor
    --conf spark.kubernetes.namespace=lrd-bigdata \   //指定名称控件
    --conf spark.kubernetes.node.selector.lrd-node-type=bigdata \  //指定集群哪个节点启动
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \  //权限认证
    --conf spark.kubernetes.container.image=registry.cn-shanghai.aliyuncs.com/zhangdongsheng/spark-k8s:2.3.2.3.0 \
    local:///opt/spark/examples/jars/sparkDemo-1.0-SNAPSHOT-jar-with-dependencies.jar //在容器中的位置

#HelloWorld  计算 pi
bin/spark-submit \
    --master k8s://https://192.168.188.34:6443  \
    --deploy-mode cluster \
    --name spark-pi \
    --class com.spark.demo.SparkKafkaDemo \
    --conf spark.executor.instances=2 \
    --conf spark.kubernetes.namespace=lrd-bigdata \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.container.image=registry.cn-shanghai.aliyuncs.com/zhangdongsheng/spark-k8s:2.3.2.3.0 \
    local:///opt/spark/examples/jars/spark-examples_2.11-2.3.0.jar


#扬子江测试环境, spark消费Kafka到Hbase数据库
#镜像脚本 kubernetes/dockerfiles/spark/entrypoint.sh  顶部添加如下 修改houts 
echo "172.16.24.51 cdh-51"  >> /etc/hosts
echo "172.16.24.52 cdh-52"  >> /etc/hosts
echo "172.16.24.53 cdh-53"  >> /etc/hosts

bin/spark-submit \
    --master k8s://https://192.168.188.34:6443  \
    --deploy-mode cluster \
    --name streaming-kafka \
    --class lrd.iot.streaming_kafka.streaming \
    --conf spark.executor.instances=1 \
    --conf spark.kubernetes.namespace=lrd-bigdata \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.node.selector.lrd-node-type=bigdata \
    --conf spark.kubernetes.container.image=registry.cn-shanghai.aliyuncs.com/larunda-test/spark-2.3.0-k8s:2.1 \
    local:///opt/spark/jars/iot-1.0-SNAPSHOT.jar
```


    
    
    local:///opt/spark/examples/jars/sparkDemo-1.0-SNAPSHOT-jar-with-dependencies.jar
    
    local:///opt/spark/examples/jars/iot-1.0-SNAPSHOT.jar







根据lables 选定pod 对外开放web端口可以在外部查看.
```yaml
kind: Service
apiVersion: v1
metadata:
  labels:
    elastic-app: spark
  name: spark-service
  namespace: lrd-bigdata
spec:
  ports:
    - port: 4040
      targetPort: 4040
  selector:
    spark-app-selector: spark-769f39bfed734315bc478e1fb1f21c71
    spark-role: driver
  type: NodePort
```



