VERSION=$1

echo ""  >> .env
echo "VERSION=${VERSION}" >> .env
docker build -t mybuild2 -f Dockerfile-tools .
docker run -v $PWD:/swift-project -w /swift-project mybuild2 /swift-utils/tools-utils.sh build release
docker build -t sanghunkang/ac-content-upload-server:${VERSION} -t sanghunkang/ac-content-upload-server:latest .