curl -L  'https://raw.githubusercontent.com/webtor-io/helm-charts/master/helmfile.yaml' > helmfile.yaml
sudo microk8s.helm repo up
sudo helmfile --helm-binary=microk8s.helm apply
