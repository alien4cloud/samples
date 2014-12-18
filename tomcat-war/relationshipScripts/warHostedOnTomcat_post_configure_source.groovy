import org.cloudifysource.utilitydomain.context.ServiceContextFactory
import java.util.concurrent.TimeUnit

def context = ServiceContextFactory.getServiceContext()

println "warHostedOnTomcat_post_configure_source<${SOURCE}> start."

def warUrl

if (! war_file) return "warUrl is null. So we do nothing."
warUrl = "${context.serviceDirectory}/../${war_file}"
println "warHostedOnTomcat_post_configure_source<${SOURCE}>: Target: ${TARGET}:${tomcatIp}, Source: ${SOURCE}, warUrl is ${warUrl} and contextPath is ${contextPath}..."

println "warHostedOnTomcat_post_configure_source<${SOURCE}> invoking updateWarOnTomcat custom command on target tomcat..."
def service = context.waitForService(context.serviceName, 60, TimeUnit.SECONDS)
def currentInstance = service.getInstances().find{ it.instanceId == context.instanceId }
currentInstance.invoke("updateWarOnTomcat", warUrl as String, contextPath as String)
println "warHostedOnTomcat_post_configure_source<${SOURCE}> end"

return true