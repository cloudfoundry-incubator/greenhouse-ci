$ErrorActionPreference = "Stop";
trap { Exit 1 }

$ROOT_DIR= (Get-Item "$PSScriptRoot/../../..").FullName
$OUTPUT_DIR=Join-Path $ROOT_DIR output
$VERSION=Get-Content (Join-Path (Join-Path $ROOT_DIR stembuild-version) version)

$GO_DIR=Join-Path $ROOT_DIR go-work
$STEMBUILD_DIR="$GO_DIR/src/github.com/cloudfoundry-incubator/stembuild"

$env:GOPATH = $GO_DIR
Write-Host "GOPATH: $env:GOPATH"

New-Item $GO_DIR -ItemType Directory

Write-Host ***Cloning stembuild***
Copy-Item stembuild $STEMBUILD_DIR -Recurse -Force

$env:PATH="${GO_DIR}/bin;$env:PATH"

Write-Host ***Building Stembuild***
Set-Location $STEMBUILD_DIR

$STEMCELL_AUTOMATION_ZIP=Join-Path $ROOT_DIR $env:STEMCELL_AUTOMATION_ZIP
$NEW_STEMCELL_AUTOMATION_ZIP=Join-Path $ROOT_DIR "StemcellAutomation.zip"

Move-Item -Path $STEMCELL_AUTOMATION_ZIP -Destination $NEW_STEMCELL_AUTOMATION_ZIP

Write-Host ***Writing version to version file***
echo $VERSION > version/version

Write-Host "Using stemcell automation script: $NEW_STEMCELL_AUTOMATION_ZIP"
make COMMAND=out/stembuild.exe AUTOMATION_PATH=${NEW_STEMCELL_AUTOMATION_ZIP} build

Write-Host ***Copying stembuild to output directory***
Copy-Item out/stembuild.exe $OUTPUT_DIR/stembuild-windows-x86_64-$VERSION.exe
