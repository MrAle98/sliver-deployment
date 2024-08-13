Set-ExecutionPolicy  -ExecutionPolicy Bypass -Force
mkdir C:\temp
mkdir C:\temp\inceptor
cd C:\vcpkg
git clone https://github.com/microsoft/vcpkg.git
.\vcpkg\bootstrap-vcpkg.bat
cd vcpkg
add-content -Path .\triplets\x64-windows-static.cmake -Value 'set(VCPKG_BUILD_TYPE release)'
.\vcpkg.exe integrate install
cd ..
.\vcpkg\vcpkg.exe x-update-baseline --add-initial-baseline
.\vcpkg\vcpkg.exe install --triplet=x64-windows-static --host-triplet=x64-windows-static --allow-unsupported
cd C:\vcpkg\vcpkg
$cmake_path=gci -force -Recurse -Include "cmake.exe" | select -ExpandProperty DirectoryName
setx PATH "$cmake_path;$env:path" -m
