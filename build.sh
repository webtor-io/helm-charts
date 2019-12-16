OWNER=webtor-io
REPO=helm-charts
rm -rf .deploy/*
mkdir -p .deploy/index
for D in `ls charts`; do
    V=`grep version charts/$D/Chart.yaml | cut -d' ' -f2 | tr -d '\n'`
    mkdir -p .deploy/$D
    helm package charts/$D --destination .deploy/$D
    R=`curl -s https://api.github.com/repos/$OWNER/$REPO/releases/tags/$D-$V | grep id | head -1 | cut -d':' -f2 | tr -d ',\n' | tr -d ' '`
    if [ ! -z "$R" -a "$R" != " " ]; then
        curl -s -X "DELETE" -H "Authorization: token $CH_TOKEN" https://api.github.com/repos/$OWNER/$REPO/releases/$R
    fi
    cr upload -o $OWNER -r $REPO -p .deploy/$D --token $CH_TOKEN
    mv .deploy/$D/* .deploy/index
done
cr index -i ./index.yaml -o $OWNER -r $REPO -p .deploy/index --token $CH_TOKEN