mkdir C:\temp
mkdir C:\vcpkg
cd C:\vcpkg
git clone https://github.com/microsoft/vcpkg.git
.\vcpkg\bootstrap-vcpkg.bat
cd vcpkg
add-content -Path .\triplets\x64-windows-static.cmake -Value 'set(VCPKG_BUILD_TYPE release)'
.\vcpkg.exe integrate install
.\vcpkg.exe install protobuf:x64-windows-static cpr:x64-windows-static gzip-hpp:x64-windows-static libsodium:x64-windows-static stduuid:x64-windows-static botan:x64-windows-static
$cmake_path=gci -force -Recurse -Include "cmake.exe" | select -ExpandProperty DirectoryName
setx PATH "$cmake_path;$env:path" -m
