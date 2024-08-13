# sliver-deployment

This repo contains automation scripts in order to deploy my own branch (**branch refactor/teamserver-interaction**) of sliver having P2P communications over beacons, along with a builder (**branch cppimplant** able to build C++ sliver implants for windows platform. Source code available of C++ implants is available here: https://github.com/MrAle98/Sliver-CPPImplant2. Probably can teach how to **NOT** write software in C++. The implant code is compatible only with the branch **refactor/teamserver-interaction** as It changes the way the implant interacts with the server in order to support P2P communications over beacons.

This repository deploys both a **sliver teamserver** and a **builder of C++ implants for the windows machine**. The **teamserver** is deployed on **linux machine**, the **builder** is deployed on a **windows machine**.

## Requirements

Requires to install:
* **ansible**
* [**pywinrm**]([https://link-url-here.org](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html)) so that ansible con communicate with the windows VM over WinRM
* **go1.19.1**

Be sure that when you run go on your machine the symbolic link is pointing to go1.19.1.
```
┌──(kali㉿kali)-[/usr/bin]
└─$ ls -la go
lrwxrwxrwx 1 root root 26 13 ago 16.19 go -> /home/kali/go/bin/go1.19.1

┌──(kali㉿kali)-[/usr/bin]
└─$
```



## Deploy all locally

Here instructions about how to deploy the **teamserver** on a **local kali VM** and the **builder** on a **local windows VM**.

1. Clone repo with all submodules on kali VM.
```
$ git clone --recursive https://github.com/MrAle98/sliver-awsdeployment.git
```
2. disable AV on windows VM.
3. copy setup_local.ps1 on windows VM. Change username and password variable inside the script to be whatever you like. Default are `ansibleUser:ansiblePass`. Run the script (as administrator).

```
PS > powershell -ep bypass
PS > .\setup_local.ps1
[...]
You need to restart this machine prior to using choco.
Ensuring Chocolatey commands are on the path
Ensuring chocolatey.nupkg is in the lib folder
PS >
```

4. Restart the VM.

5. Run build-servers.sh.

```
$ ./build-servers.sh
[...]
GOOS=windows CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ go build -mod=vendor -trimpath -tags osusergo,netgo,cgosqlite,sqlite_omit_load_extension,client -ldflags "-s -w -X github.com/bishopfox/sliver/client/version.Version=v1.5.22 -X \"github.com/bishopfox/sliver/client/version.GoVersion=go version go1.19.1 linux/amd64\" -X github.com/bishopfox/sliver/client/version.CompiledAt=1723566051 -X github.com/bishopfox/sliver/client/version.GithubReleasesURL=https://api.github.com/repos/BishopFox/sliver/releases -X github.com/bishopfox/sliver/client/version.GitCommit=2772f8897de1a6cb7e37eb7ad9b529ac81dc8de5 -X github.com/bishopfox/sliver/client/version.GitDirty= -X github.com/bishopfox/sliver/client/assets.DefaultArmoryPublicKey=RWSBpxpRWDrD7Fe+VvRE3c2VEDC2NK80rlNCj+BX0gz44Xw07r6KQD9L -X github.com/bishopfox/sliver/client/assets.DefaultArmoryRepoURL=https://api.github.com/repos/sliverarmory/armory/releases" -o sliver-client.exe ./client
$ 
```
