rm -rf sliver
git clone https://github.com/MrAle98/sliver.git
cd sliver
git checkout refactor/teamserver-interaction
./go-assets.sh
make linux
cp sliver-server ../ansible_configs/sliver
cp sliver-client ../ansible_configs/sliver
git checkout cppimplant
./go-assets.sh
make windows
cp sliver-server.exe ../ansible_configs/sliver
cp sliver-client.exe ../ansible_configs/sliver
