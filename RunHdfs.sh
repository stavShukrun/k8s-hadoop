#!/bin/bash
echo "----------------------- Start! ----------------------------"
# Start minikube
echo -e "\nStart minikube :\n"
minikube --memory 4096 --cpus 2 start

# Move to workdir
cd hdfs

# Export vars
export HADOOP_VERSION=${HADOOP_VERSION:-3.2.1}

# Installing chart with helm
echo -e "\nInstall hadoop helm please wait....\n"
helm install hdfs . \
  --set hdfs.namenode.tag=${HADOOP_VERSION} \
  --set hdfs.datanode.tag=${HADOOP_VERSION} \
  --set hdfs.shell.tag=${HADOOP_VERSION} \
  --wait

echo -e "\nYou can enter http://localhost:9870\n"
echo "----------------------- Ready! ----------------------------"

#Accessing Web UI
kubectl port-forward svc/hdfs-namenodes 9870:9870