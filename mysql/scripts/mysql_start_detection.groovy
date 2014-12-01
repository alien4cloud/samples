import org.cloudifysource.dsl.utils.ServiceUtils

def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())
println "mysql_start_detection.groovy: port http=${config.mysql.port} ..."
def isPortOccupied = ServiceUtils.isPortOccupied(Integer.parseInt(config.mysql.port))
println "mysql_start_detection.groovy: isPortOccupied http=${config.mysql.port} ... ${isPortOccupied}"
return isPortOccupied
