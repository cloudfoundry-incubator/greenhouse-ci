function Set-TmpDir
{
    $working_directory = Get-Location
    $guid = $( New-Guid ).Guid
    $temp_directory=Join-Path -Path $working_directory.path -ChildPath "temp-$guid"
    New-Item -Path $temp_directory -ItemType Directory
    $env:TMP=$temp_directory
}