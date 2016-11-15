trap {
  write-error $_
  [Environment]::Exit(1)
}

cd C:\nginx\nginx-1.10.0
start .\nginx.exe
