import org.cloudifysource.dsl.utils.ServiceUtils

def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())
def nameApache = args[0]

println "apache_start_detection.groovy: port http=${config[nameApache].port} ..."
def isPortOccupied = ServiceUtils.isPortOccupied(Integer.parseInt(config[nameApache].port))
println "apache_start_detection.groovy: isPortOccupied http=${config[nameApache].port} ... ${isPortOccupied}"
return isPortOccupied
