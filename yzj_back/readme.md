#扬子江测试环境启动
服务器: 192.168.188.34
1. 切换到目录: /home/sddt/k8s-saas-test-back
2. 执行命令: 
kubectl create -f ./deployment.apps
kubectl create -f ./secret
kubectl create -f ./serviceaccount

#扬子江测试环境下线
服务器: 192.168.188.34

执行命令: kubectl -n yzj-test delete pvc,configmap,serviceaccount,secret,ingress,service,deployment,statefulset,hpa,job,cronjob --all











