import java.io.File

println "Start detection of wordpress..."

def isLaunch = false
File file = new File("/tmp/wordpress-started")

if(file.exists() && !file.isDirectory()) {
  isLaunch  = true
}

return isLaunch
