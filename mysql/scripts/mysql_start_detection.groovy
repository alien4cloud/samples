import org.cloudifysource.dsl.utils.ServiceUtils

def nameMysql = args[0]
def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())
println "mysql_start_detection.groovy: port http=${config[nameMysql].port} ..."
def isPortOccupied = ServiceUtils.isPortOccupied(Integer.parseInt(config[nameMysql].port))
println "mysql_start_detection.groovy: isPortOccupied http=${config[nameMysql].port} ... ${isPortOccupied}"
return isPortOccupied
