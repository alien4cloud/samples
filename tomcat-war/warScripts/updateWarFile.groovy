import org.cloudifysource.dsl.utils.ServiceUtils
import java.util.concurrent.TimeUnit

if(args == null || args.length < 2){
  throw new IllegalArgumentException("UpdateWarFile command requires a contextPath and an url as arguments.")
}
def warUrl=args[0]
def contextPath=args[1]

println "updateWarFile.groovy: warUrl is ${warUrl} and contextPath is ${contextPath}..."
println "updateWarFile.groovy: invoking updateWarOnTomcat custom command ..."
def service = context.waitForService(context.serviceName, 60, TimeUnit.SECONDS)
def currentInstance = service.getInstances().find{ it.instanceId == context.instanceId }
currentInstance.invoke("updateWarOnTomcat", warUrl as String, contextPath as String)

println "updateWarFile.groovy: End"
return true