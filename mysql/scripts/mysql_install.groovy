import org.cloudifysource.utilitydomain.context.ServiceContextFactory

context = ServiceContextFactory.getServiceContext()
evaluate(new File("${context.serviceDirectory}/scripts/chmod-init.groovy"))

def builder = new AntBuilder()
// Installing MySQL
builder.sequential {
  echo(message:"mysql_install.groovy: Running Mysql install script from FastConnect...")
  exec(executable:"${context.serviceDirectory}/scripts/installMysql.sh", osfamily:"unix",failonerror: "true")
}
