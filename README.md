# sliver-deployment

This repo contains automation scripts in order to deploy my own branch (**branch refactor/teamserver-interaction**) of sliver having P2P communications over beacons, along with a builder (**branch cppimplant** able to build C++ sliver implants for windows platform. Source code available of C++ implants is available here: https://github.com/MrAle98/Sliver-CPPImplant2. Probably can teach how to **NOT** write software in C++. The implant code is compatible only with the branch **refactor/teamserver-interaction** as It changes the way the implant interacts with the server in order to support P2P communications over beacons.

This repository deploys both a **sliver teamserver** and a **builder of C++ implants for the windows machine**. The **teamserver** is deployed on **linux machine**, the **builder** is deployed on a **windows machine**.

*Requires to install **ansible** and **pywinrm** https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html so that ansible con communicate with the windows VM over WinRM.
Requires to install **go1.19.1** and link **/usr/bin/go** to **go1.19.1**.* 


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
