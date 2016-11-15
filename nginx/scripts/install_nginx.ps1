trap {
  write-error $_
  [Environment]::Exit(1)
}

Invoke-WebRequest http://nginx.org/download/nginx-1.10.0.zip -UseBasicParsing -OutFile nginx.zip

[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory("nginx.zip", "c:\nginx")
