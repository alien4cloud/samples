import org.cloudifysource.dsl.utils.ServiceUtils
import java.util.concurrent.TimeUnit

assert warUrl && !warUrl.trim().isEmpty(), "requires warUrl parameter"
def command = "${PARENT}_updateWarOnTomcat"
println "updateWarFile.groovy: warUrl is ${warUrl} and contextPath is ${contextPath}..."
println "updateWarFile.groovy: invoking ${command} custom command ..."
def service = context.waitForService(HOST, 60, TimeUnit.SECONDS)
def currentInstance = service.getInstances().find{ it.instanceId == context.instanceId }
currentInstance.invoke(command, "url=${warUrl}" as String, "contextPath=${contextPath}" as String)

println "updateWarFile.groovy: End"
return true