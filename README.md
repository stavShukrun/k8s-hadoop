# K8s(minikube) and Hadoop HDFS(Hadoop Distributed File System)
Hadoop is a collection of open-source software utilities that facilitates using a network of many computers to solve problems involving massive amounts of data and computation. It provides a software framework for distributed storage and processing of big data using the MapReduce programming model.

## Setup
Copy the project and set up kubernetes.
[Download minikube](https://minikube.sigs.k8s.io/docs/start/)
When starting minikube we should increase its memory limit since our Hadoop node's pods need at least 2GB: ```minikube --memory 4096 --cpus 2 start ```(minikube's default is 1GB). NOTE: actually the Hadoop cluster by default uses about 10GB in memory limits and about 3GB running memory. From what I looked my k8s will overprovision to 300% of its capacity limits but use far less.

## Work tree
```
.
├── README.md
├── RunHdfs.sh
└── hdfs
    ├── Chart.yaml
    ├── README.md
    ├── docs
    │   ├── aws-eks-deployment.md
    │   └── kind-deployment.md
    ├── templates
    │   ├── _helpers.tpl
    │   ├── config.yaml
    │   ├── datanodes-netpol.yaml
    │   ├── datanodes-service.yaml
    │   ├── datanodes.yaml
    │   ├── ingress.yaml
    │   ├── namenode-netpol.yaml
    │   ├── namenode-service.yaml
    │   ├── namenode-serviceaccount.yaml
    │   ├── namenode.yaml
    │   ├── post-install-cmds.yaml
    │   ├── rack-awareness-rbac.yaml
    │   ├── rack-awareness-script.yaml
    │   ├── secrets.yaml
    │   ├── shell.yaml
    │   └── tests
    │       ├── auth-test.yaml
    │       ├── rack-awareness-test.yaml
    │       └── webhdfs-test.yaml
    ├── values-eks-alb.yaml
    ├── values-host-based-ingress.yaml
    └── values.yaml
```

## Quick start
Run- 
```
./RunHdfs.sh
```

## Run locally
```
cd hdfs

export HADOOP_VERSION=${HADOOP_VERSION:-3.2.1}

helm install hdfs . \
  --set hdfs.namenode.tag=${HADOOP_VERSION} \
  --set hdfs.datanode.tag=${HADOOP_VERSION} \
  --set hdfs.shell.tag=${HADOOP_VERSION}
```

## Accessing Web UI (via kubectl port-forward)
```  
kubectl port-forward svc/hdfs-namenodes 9870:9870
```

## cleaning
```
kubectl delete deployments.apps --all
kubectl delete secrets --all
kubectl delete service --all
```
If port forward proses is still up :
```
ps -ef | grep port-forward
kill -9 <process number>
```

stop minikube :
```
minikube delete
minikube stop
```