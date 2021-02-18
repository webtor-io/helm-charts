sudo apt update
sudo apt-get -y install snapd git curl
sudo snap install microk8s --classic --channel=1.19/stable
sudo microk8s status --wait-ready
sudo microk8s kubectl get nodes
sudo microk8s enable helm
sudo microk8s enable dns
sudo microk8s helm init --stable-repo-url https://charts.helm.sh/stable --wait
sudo mkdir $(microk8s helm home)/plugins
curl -L https://github.com/databus23/helm-diff/releases/download/v3.1.3/helm-diff-linux.tgz | sudo tar -C $(microk8s helm home)/plugins -xzv
sudo microk8s helm repo add webtor https://charts.webtor.io
sudo microk8s helm repo add bitnami https://charts.bitnami.com/bitnami
sudo microk8s enable metrics-server
curl -L 'https://github.com/roboll/helmfile/releases/download/v0.90.5/helmfile_linux_amd64' > helmfile
chmod +x helmfile
sudo mv ./helmfile /usr/local/bin/
curl -L  'https://raw.githubusercontent.com/webtor-io/helm-charts/master/helmfile.yaml' > helmfile.yaml
sudo helmfile --helm-binary=microk8s.helm apply
sudo microk8s kubectl get svc torrent-http-proxy -o yaml -n webtor | grep http -A 1 | grep nodePort | awk '{print "Listening HTTP at port "  $2}'
sudo microk8s kubectl get svc torrent-http-proxy -o yaml -n webtor | grep grpc -A 1 | grep nodePort | awk '{print "Listening GRPC at port "  $2}'
