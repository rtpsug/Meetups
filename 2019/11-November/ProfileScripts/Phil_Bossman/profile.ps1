
# this will get all PS1 files from path and run them (dot sourcing)
# all files should be constucted as Functions
If ( Test-Path -Path "\\MYDOMAIN.com\MMM\PoSH" ) {
    Get-ChildItem -Path "\\MYDOMAIN.com\MMM\PoSH" -Filter *.ps1 | ForEach-Object { . $_.FullName }
}