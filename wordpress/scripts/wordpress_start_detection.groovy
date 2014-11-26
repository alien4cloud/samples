import java.io.File

def isLaunch = false
File file = new File("/tmp/wordpress-started")

if(file.exists() && !file.isDirectory()) {
  isLaunch  = true
}

return isLaunch
