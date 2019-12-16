rm -rf .deploy/*
mkdir -p .deploy/index
for D in `ls charts`; do
    mkdir -p .deploy/$D
    helm package charts/$D --destination .deploy/$D
    cr upload -o webtor-io -r helm-charts -p .deploy/$D --config ~/.cr.yaml
    mv .deploy/$D/* .deploy/index
done
cr index -i ./index.yaml -o webtor-io -r helm-charts -p .deploy/index --config ~/.cr.yaml