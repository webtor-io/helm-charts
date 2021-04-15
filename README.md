# helm-charts

This guide will show you how to install all essential components of webtor backend api to local k8s cluster.

## Minimum system requirements
vCPU: 4
RAM: 4GB

## Short way at Ubuntu

```
curl https://raw.githubusercontent.com/webtor-io/helm-charts/master/scripts/get-webtor.sh | sh
```

This will install single-node microk8s cluster and setup webtor on it, at the end of installation you will
get values of listening GRPC and HTTP ports. All operations can take a long time.

This was tested at Ubuntu 20.04.

To update webtor components to the latest stable versions just use the following script:
```
curl https://raw.githubusercontent.com/webtor-io/helm-charts/master/scripts/update-webtor.sh | sh
```

## Long way

Let's start:

1. [Install Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) and check it:

   ```
   % kubectl get no
   NAME       STATUS   ROLES    AGE   VERSION
   minikube   Ready    master   23h   v1.17.0
   ```
   
   (Tested with VirtualBox (Windows/Linux) and HyperKit (Mac) drivers)
   
2. [Install Helm and init it](https://helm.sh/docs/intro/install/) and check it:

   ```
   % helm version
   Client: &version.Version{SemVer:"v2.15.1", GitCommit:"cf1de4f8ba70eded310918a8af3a96bfe8e7683b", GitTreeState:"clean"}
   Server: &version.Version{SemVer:"v2.15.1", GitCommit:"cf1de4f8ba70eded310918a8af3a96bfe8e7683b", GitTreeState:"clean"}
   ```

3. [Install Helmfile](https://github.com/roboll/helmfile#installation) and check it:

   ```
   % helmfile -v
   helmfile version v0.90.2
   ```

4. [Install helm-diff](https://github.com/databus23/helm-diff#install)

5. Add Webtor charts repository with:

   ```
   helm repo add webtor https://charts.webtor.io

   ```

6. Clone this repository:

    ```
    git clone https://github.com/webtor-io/helm-charts.git
    ```

7. Run Helmfile there:

    ```
    helmfile apply

    ```

7. Check installation, all pods should be started at webtor namespace

   ```
   % kubectl get po -n webtor
   NAME                             READY   STATUS    RESTARTS   AGE
   content-prober-ddcfcf847-cmbt9   1/1     Running   0          37s
   magnet2torrent-5df84c855-2c8t6   1/1     Running   0          34s
   redis-master-0                   1/1     Running   0          35s
   torrent-http-proxy-mwktl         1/1     Running   0          37s
   torrent-store-65c6bd4659-jjfqf   1/1     Running   0          34s
   ...
   ```

8. Get api url at last!

   ```
   % minikube service torrent-http-proxy --url -n webtor
   http://192.168.64.3:30749
   ```
   
   and check it:
   
   ```
   % curl -I http://192.168.64.3:30749
   HTTP/1.1 200 OK
   Date: Thu, 19 Dec 2019 19:44:43 GMT
   ```
   
   it will return "Internal Server Error" for direct calls.

That's all!

For update do next three things:

 ```
 git pull
 helm repo update
 helmfile apply
 ```
