# helm-charts

This guide will show you how to install all essential components of webtor backend api to local k8s cluster.

## Minimum system requirements
vCPU: 4
RAM: 4GB

## Short way at Ubuntu

```
curl https://raw.githubusercontent.com/webtor-io/helm-charts/master/scripts/get-webtor.sh | sh
```

This will install single-node microk8s cluster and setup webtor on it (api + web-ui).

This was tested on Ubuntu 20.04.

### Ports
* 30080 - Web UI
* 30180 - API
* 30151 - GRPC

### Swagger

http://{YOUR_SERVER_IP}:30180/rest/swagger/index.html

### Update

To update webtor components to the latest stable versions just use the following script:
```
curl https://raw.githubusercontent.com/webtor-io/helm-charts/master/scripts/update-webtor.sh | sh
```

## Long way [DEPRECATED]

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
## Adjusting components

Every component can be configured separately by providing your own configuration file.
For example if you wish to reconfigure `web-ui` you have to do the following: 
1. Add `web-ui.yaml` file to the same folder where your `helmfile.yaml` located
2. Adjust configuration in `web-ui.yaml`
3. `helmfile apply`

## Secure your API

Just put additional file called `clients.yaml` in the same directory where your `helmfile.yaml` located with the following content:

```
clients:
  - name: client1
    apiKey: client1-api-key
    secret: client1-secret
```

**Don't forget to change values of name, apiKey and secret.**

Also make sure that you have the latest version of `helmfile.yaml`.

And do `helmfile apply` to apply changes.

After this, all requests to the API will require auth-token. It is simple [JWT-token](https://jwt.io/).
Also it is possible to pass additional params in token payload such as:
1. rate - this will do rate limitting (could be '1M', '10M' and so on, bits per second)
2. agent - User-Agent
3. remoteAddress - remote IP-address
4. sessionID - some generated session ID, it should be provided for more precise rate-limitting

If `agent` and `remoteAddress` are defined there will be additional check to prevent user from url-sharing.
