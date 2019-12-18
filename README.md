# helm-charts

This guide will show you how to install all essential components of webtor backend api to local k8s cluster (Minikube).

Let's start:

1. [Install Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
2. [Install Helm and init it](https://helm.sh/docs/intro/install/)
3. [Install Helmfile](https://github.com/roboll/helmfile#installation)

4. Add Webtor charts repository with:

   ```
   helm repo add webtor https://charts.webtor.io

   ```

5. Clone this repository:

    ```
    git@github.com:webtor-io/helm-charts.git
    ```

6. Run Helmfile there:

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
   ```

8. Get api url at last!

   ```
   % minikube service torrent-http-proxy --url -n webtor
   http://192.168.64.3:30749
   ```

That's all!