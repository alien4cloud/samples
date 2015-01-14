import org.cloudifysource.dsl.utils.ServiceUtils

println "mysql_start_detection.groovy: port http=${PORT} ..."
def isPortOccupied = ServiceUtils.isPortOccupied(Integer.parseInt(PORT))
println "mysql_start_detection.groovy: isPortOccupied http=${PORT} ... ${isPortOccupied}"
return isPortOccupied
