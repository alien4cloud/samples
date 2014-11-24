import org.cloudifysource.utilitydomain.context.ServiceContextFactory

context = ServiceContextFactory.getServiceContext()
evaluate(new File("${context.serviceDirectory}/scripts/chmod-init.groovy"))
def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())

def builder = new AntBuilder()
builder.sequential {
  echo(message:"php_install.groovy: install PHP module for Apache2...")
  exec(executable:"${context.serviceDirectory}/scripts/install_apache2_module.sh", osfamily:"unix",failonerror: "true")
}
