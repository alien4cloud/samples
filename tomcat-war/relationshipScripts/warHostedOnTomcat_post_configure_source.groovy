import org.cloudifysource.utilitydomain.context.ServiceContextFactory
import java.util.concurrent.TimeUnit

def context = ServiceContextFactory.getServiceContext()

println "warHostedOnTomcat_post_configure_source<${SOURCE}> start."

if (! war_file) return "warUrl is null. So we do nothing."
println "warHostedOnTomcat_post_configure_source<${SOURCE}>: Target: ${TARGET_NAME}/${TARGET}:${tomcatIp}, Source: ${SOURCE_NAME}/${SOURCE}, warUrl is ${war_file} and contextPath is ${contextPath}..."

def command = "${TARGET_NAME}_updateWarOnTomcat"
println "warHostedOnTomcat_post_configure_source<${SOURCE}> invoking ${command} custom command on target tomcat..."
def service = context.waitForService(TARGET_SERVICE_NAME, 60, TimeUnit.SECONDS)
def currentInstance = service.getInstances().find{ it.instanceId == context.instanceId }
currentInstance.invoke(command, "url=${war_file}" as String, "contextPath=${contextPath}" as String)
println "warHostedOnTomcat_post_configure_source<${SOURCE}> end"

return true