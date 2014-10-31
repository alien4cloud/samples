import org.cloudifysource.utilitydomain.context.ServiceContextFactory

context = ServiceContextFactory.getServiceContext()
evaluate(new File("${context.serviceDirectory}/scripts/chmod-init.groovy"))
builder = new AntBuilder()

def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())

builder.sequential {
  echo(message:"apache_install.groovy: Running Apache install script from FastConnect...")
  exec(executable:"${context.serviceDirectory}/scripts/installApache.sh") {
    arg(value:"${config.apache.port}")
    arg(value:"${config.apache.need_php}")
  }
}
