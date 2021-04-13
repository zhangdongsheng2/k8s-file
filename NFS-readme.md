#nfs 示例

在要共享目录的机器上执行
```shell script
mkdir -p /home/data/redis-cluster/pv{1..6}
chmod 777 /home/data/redis-cluster/pv{1..6}
yum -y install nfs-utils

systemctl enable nfs
systemctl enable rpcbind
systemctl start nfs
systemctl start rpcbind

vi /etc/exports
#添加如下
/home/data/redis-cluster/pv1  *(rw,sync,no_root_squash,no_subtree_check)
/home/data/redis-cluster/pv2  *(rw,sync,no_root_squash,no_subtree_check)
/home/data/redis-cluster/pv3  *(rw,sync,no_root_squash,no_subtree_check)

/home/data/redis-cluster/pv4  *(rw,sync,no_root_squash,no_subtree_check)
/home/data/redis-cluster/pv5  *(rw,sync,no_root_squash,no_subtree_check)
/home/data/redis-cluster/pv6  *(rw,sync,no_root_squash,no_subtree_check)

#重新加载
 exportfs -r
#验证是否加载成功,  列出以上目录就代表成功
 showmount -e

#测试, 在另一台机器上 挂载, 然后创建文件,  回到共享文件夹机器查看是否有文件存在
#挂载
mount -t nfs 192.168.188.81:/home/data/redis-cluster/pv3 /home/pv333/
#创建文件写入字符
echo "this is my test" > a.txt

#卸载
umount -t nfs 192.168.188.81:/home/data/redis-cluster/pv3 /home/pv333/

```
#注意
如果报错, 检查目录是否共享成功. 
检查需要访问共享目录的机器是否启动nfs服务. 




  



 

