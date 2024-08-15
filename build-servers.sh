rm -rf sliver
git clone https://github.com/MrAle98/sliver.git
cd sliver
git checkout refactor/teamserver-interaction
./go-assets.sh
make linux
rm -rf ~/sliver-builds
rm -rf ../ansible_configs/sliver
mkdir ~/sliver-builds
mkdir ../ansible_configs/sliver
cp sliver-server ../ansible_configs/sliver
cp sliver-client ../ansible_configs/sliver
cp sliver-server ~/sliver-builds/
cp sliver-client ~/sliver-builds/
git checkout cppimplant
./go-assets.sh
make windows
cp sliver-server.exe ../ansible_configs/sliver
cp sliver-client.exe ../ansible_configs/sliver
cp sliver-server.exe ~/sliver-builds/
cp sliver-client.exe ~/sliver-builds/
