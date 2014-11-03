import org.cloudifysource.utilitydomain.context.ServiceContextFactory

context = ServiceContextFactory.getServiceContext()
evaluate(new File("${context.serviceDirectory}/scripts/chmod-init.groovy"))

def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())

def builder = new AntBuilder()
// Installing Git
builder.sequential {
  echo(message:"git_install.groovy: Running Git install script from FastConnect...")
  exec(executable:"${context.serviceDirectory}/scripts/installGit.sh", osfamily:"unix",failonerror: "true") {
    env(key:"GIT_USER", value:config.git.git_user)
    env(key:"GIT_EMAIL", value: config.git.git_email)
  }
}
