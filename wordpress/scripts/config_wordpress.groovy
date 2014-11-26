import org.cloudifysource.utilitydomain.context.ServiceContextFactory

context = ServiceContextFactory.getServiceContext()
evaluate(new File("${context.serviceDirectory}/scripts/chmod-init.groovy"))
builder = new AntBuilder()

def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())

def nameWordpress = args[0]
def nameApache = args[2]
def contextPath = config[nameWordpress].context_path
if ( config[nameWordpress].context_path == "/") {
  println "No context path"
  contextPath = ""
}

builder.sequential {
  echo(message:"config_wordpress.groovy: Config Wordpress script from FastConnect...")
  exec(executable:"${context.serviceDirectory}/scripts/config_wordpress.sh", osfamily:"unix", failonerror:"true") {
    env(key:"WEBFILE_URL", value:config[nameWordpress].zip_url)
    env(key:"CONTEXT_PATH", value:contextPath)
    env(key:"DOC_ROOT", value:config[nameApache].document_root)
  }
}
