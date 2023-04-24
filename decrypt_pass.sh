#!/bin/bash
echo -n $1 | base64 -d > pass.bin && openssl rsautl -decrypt -inkey ~/AWS/keys/windows-server-2022-AWS.pem -in pass.bin
