echo "push service $1 as image $2:$TRAVIS_TAG"

sudo add-apt-repository -y ppa:cpick/hub
sudo apt-get update
sudo apt-get install -y hub

hub config --global user.email "honza.pofider@seznam.cz"
hub config --global user.name "pofider"

hub checkout -b update-deployment-${TRAVIS_TAG}
hub config remote.origin.url https://pofider:${GITHUB_TOKEN}@github.com/pofider/kubernetes.git

DOCKER_IMAGE="$(echo "$2" | sed 's/[^-A-Za-z0-9_]/\\&/g')"

sed -i 's/'"$DOCKER_IMAGE"'\:\(.*\)/'"$DOCKER_IMAGE"'\:'"$TRAVIS_TAG"'/' ./config/staging/${1}.yaml
sed -i 's/'"$DOCKER_IMAGE"'\:\(.*\)/'"$DOCKER_IMAGE"'\:'"$TRAVIS_TAG"'/' ./config/prod/${1}.yaml
hub add config/staging/${1}.yaml
hub add config/prod/${1}.yaml

hub commit -m "Update the $1 application"

echo "push new branch"
hub push -u origin ${1}-${TRAVIS_TAG}

# unfortunatelly this crashes on some perm issues
#hub pull-request -m "Update the janblaha application to ${TRAVIS_TAG}"
