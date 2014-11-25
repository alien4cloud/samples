import org.cloudifysource.dsl.utils.ServiceUtils

def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())
println "apache_start_detection.groovy: port http=${config.apache.port} ..."
def isPortOccupied = ServiceUtils.isPortOccupied(Integer.parseInt(config.apache.port))
println "apache_start_detection.groovy: isPortOccupied http=${config.apache.port} ... ${isPortOccupied}"
return isPortOccupied
