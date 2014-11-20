import org.cloudifysource.utilitydomain.context.ServiceContextFactory

context = ServiceContextFactory.getServiceContext()
evaluate(new File("${context.serviceDirectory}/scripts/chmod-init.groovy"))
builder = new AntBuilder()

def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())

builder.sequential {
  echo(message:"apache_install.groovy: Config Wordpress script from FastConnect...")
  exec(executable:"${context.serviceDirectory}/scripts/config_wordpress.sh", osfamily:"unix", failonerror:"true") {
    env(key:"WEBFILE_URL", value:config.wordpress.zip_url)
    env(key:"DOC_ROOT", value:config.wordpress.folder_to_install)
  }
}
