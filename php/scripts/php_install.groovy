import org.cloudifysource.utilitydomain.context.ServiceContextFactory

context = ServiceContextFactory.getServiceContext()
evaluate(new File("${context.serviceDirectory}/scripts/chmod-init.groovy"))
def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())

def builder = new AntBuilder()
builder.sequential {
  echo(message:"php_install.groovy: Running PHP install script from FastConnect...")
  exec(executable:"${context.serviceDirectory}/scripts/install_php.sh", osfamily:"unix",failonerror: "true") {
    env(key:"APACHE2_MODULE", value:config.php.add_apache2_module)
    env(key:"MYSQL_MODULE", value:config.php.add_mysql_module)
  }
}
