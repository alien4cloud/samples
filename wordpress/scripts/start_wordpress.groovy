import org.cloudifysource.utilitydomain.context.ServiceContextFactory

context = ServiceContextFactory.getServiceContext()
builder = new AntBuilder()
builder.sequential {
  echo(message:"apache_install.groovy: Started Apache 2 install script from FastConnect...")
  exec(executable:"${context.serviceDirectory}/scripts/start_wordpress.sh", osfamily:"unix", failonerror:"true")
}
