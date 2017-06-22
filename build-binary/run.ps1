﻿$ErrorActionPreference = "Stop";
trap { $host.SetShouldExit(1) }

$env:PATH = $env:GOPATH + "/bin;C:/go/bin;" + $env:PATH

go.exe version

if ($env:PACKAGE -eq "") {
  Write-Error "Define PACKAGE env variable"
}

if ($env:IMPORT_PATH -ne "") {
  if (!$env:IMPORT_PATH.StartsWith("src")) {
    $env:IMPORT_PATH = (Join-Path "src" $env:IMPORT_PATH)
  }
  New-Item -Type Directory -Force -Path $env:IMPORT_PATH
  Copy-Item -Recurse -Force repo/* "$env:IMPORT_PATH"
  $env:GOPATH=$PWD
  $env:PACKAGE = (Resolve-Path (Join-Path $env:IMPORT_PATH $env:PACKAGE) -Relative)
} else {
  $env:GOPATH=(Resolve-Path "repo").Path
  $env:PACKAGE = (Resolve-Path (Join-Path $env:GOPATH $env:PACKAGE) -Relative)
}

$BINARY=(Get-Item $env:PACKAGE).BaseName
go.exe build -o "binary-output/$BINARY.exe" $env:PACKAGE
Exit $LastExitCode