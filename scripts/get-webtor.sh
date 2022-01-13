sudo apt update
sudo apt-get -y install snapd git curl
sudo snap install microk8s --classic --channel=1.19/stable
sudo microk8s status --wait-ready
sudo microk8s kubectl get nodes
sudo microk8s enable dns
sudo microk8s enable metrics-server
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm plugin install https://github.com/databus23/helm-diff
helm repo add webtor https://charts.webtor.io
helm repo add bitnami https://charts.bitnami.com/bitnami
mkdir ~/.kube
sudo microk8s kubectl config view --raw > ~/.kube/config
chmod 0600 ~/.kube/config
curl -L 'https://github.com/roboll/helmfile/releases/download/v0.143.0/helmfile_linux_amd64' > helmfile
chmod +x helmfile
sudo mv ./helmfile /usr/local/bin/
curl -L  'https://raw.githubusercontent.com/webtor-io/helm-charts/master/helmfile.yaml' > helmfile.yaml
helmfile apply
sudo microk8s kubectl get svc torrent-http-proxy -o yaml -n webtor | grep http -A 1 | grep nodePort | head -1| awk '{print "Listening HTTP at port "  $2}'
sudo microk8s kubectl get svc torrent-http-proxy -o yaml -n webtor | grep grpc -A 1 | grep nodePort | awk '{print "Listening GRPC at port "  $2}'