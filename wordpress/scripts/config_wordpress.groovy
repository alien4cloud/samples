import org.cloudifysource.utilitydomain.context.ServiceContextFactory

context = ServiceContextFactory.getServiceContext()
evaluate(new File("${context.serviceDirectory}/scripts/chmod-init.groovy"))
builder = new AntBuilder()

def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())

def contextPath = config.wordpress.context_path
if ( config.wordpress.context_path == "/") {
  println "No context path"
  contextPath = ""
}

println "config.groovy: args[0]=${args[0]}"
println "config: args[1]=${args[1]}"
println "configrce.groovy: args[2]=${args[2]}"
println "tconfigovy: args[3]=${args[3]}"


builder.sequential {
  echo(message:"apache_install.groovy: Config Wordpress script from FastConnect...")
  exec(executable:"${context.serviceDirectory}/scripts/config_wordpress.sh", osfamily:"unix", failonerror:"true") {
    env(key:"WEBFILE_URL", value:config.wordpress.zip_url)
    env(key:"CONTEXT_PATH", value:contextPath)
    env(key:"DOC_ROOT", value:config.apache.document_root)
  }
}
