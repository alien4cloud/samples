import org.cloudifysource.utilitydomain.context.ServiceContextFactory
import java.util.concurrent.TimeUnit

context = ServiceContextFactory.getServiceContext()
evaluate(new File("${context.serviceDirectory}/scripts/chmod-init.groovy"))
builder = new AntBuilder()

def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())

def serviceName = args[3]
println "invokeAddNode.groovy: target $serviceName Post-start ..."
def mysqlService = context.waitForService(serviceName, 5, TimeUnit.MINUTES)
def instances = mysqlService.getInstances()
def ip_adress = instances[0].getHostAddress()
println "ip of $instances database: $ip_adress"

println "tomcat_configureDatasource.groovy: args[0]=${args[0]}"
println "tomcat_configureDatasource.groovy: args[1]=${args[1]}"
println "tomcat_configureDatasource.groovy: args[2]=${args[2]}"
println "tomcat_configureDatasource.groovy: args[3]=${args[3]}"



def contextPath = config.wordpress.context_path
if ( config.wordpress.context_path == "/") {
  println "No context path"
  contextPath = ""
}

builder.sequential {
  echo(message:"apache_install.groovy: Config Wordpress script from FastConnect...")
  exec(executable:"${context.serviceDirectory}/scripts/config_wordpress_for_mysql.sh", osfamily:"unix", failonerror:"true") {
    env(key:"DB_NAME", value:config.mysql.db_name)
    env(key:"DB_USER", value:config.mysql.db_user)
    env(key:"DB_PASSWORD", value:config.mysql.db_password)
    env(key:"DB_IP", value:ip_adress)
    env(key:"CONTEXT_PATH", value:contextPath)
    env(key:"DOC_ROOT", value:config.apache.document_root)
  }
}
