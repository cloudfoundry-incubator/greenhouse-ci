$ErrorActionPreference = "Stop";
trap { Exit 1 }

Import-Module .ci/common-scripts/setup-windows-container.psm1
Set-TmpDir

$ROOT_DIR= (Get-Item "$PSScriptRoot/../../../../..").FullName

$GO_DIR=Join-Path $ROOT_DIR go-work
$STEMBUILD_DIR="$GO_DIR/src/github.com/cloudfoundry-incubator/stembuild"

$env:GOPATH = $GO_DIR
Write-Host "GOPATH: $env:GOPATH"

New-Item $GO_DIR -ItemType Directory

Write-Host ***Cloning stembuild***
Copy-Item stembuild $STEMBUILD_DIR -Recurse -Force

Write-Host ***Building ginkgo***
go get github.com/onsi/ginkgo/ginkgo
go install github.com/onsi/ginkgo/ginkgo

$env:PATH="${GO_DIR}/bin;$env:PATH"

Write-Host ***Test Stembuild Code***
Set-Location $STEMBUILD_DIR
make contract
if ($lastexitcode -ne 0)
{
  throw "contract tests failed"
}
