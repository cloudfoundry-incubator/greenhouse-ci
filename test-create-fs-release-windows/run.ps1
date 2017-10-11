﻿$ErrorActionPreference = "Stop";
trap { $host.SetShouldExit(1) }

# get tar on the path
$env:PATH="$env:PATH;C:\var\vcap\bosh\bin"

push-location windows2016fs-release
  git config core.filemode false
  git submodule foreach --recursive git config core.filemode false

  ./scripts/create-release.ps1

  $expected_version=(cat VERSION)
  $created_version=(bosh int "dev_releases/windows2016fs/windows2016fs-$expected_version.yml" --path=/version)
  $uncommitted_changes=(bosh int "dev_releases/windows2016fs/windows2016fs-$expected_version.yml" --path=/uncommitted_changes)
pop-location

if ($expected_version -ne $created_version) {
  echo "**ERROR** expected version: $expected_version, got: $created_version"
  exit 1
}

if ($uncommitted_changes -ne "false") {
  echo "**ERROR** found uncommited changes"
  exit 1
}

$pre_version=(cat version/version)
cp windows2016fs-release/bin/create.exe "create-binary-windows/create-$pre_version-windows-amd64.exe"
