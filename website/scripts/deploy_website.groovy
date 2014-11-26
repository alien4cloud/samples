import org.cloudifysource.utilitydomain.context.ServiceContextFactory

println 'Deploy the website...'

context = ServiceContextFactory.getServiceContext()
evaluate(new File("${context.serviceDirectory}/scripts/chmod-init.groovy"))
builder = new AntBuilder()
def config = new ConfigSlurper().parse(new File("${context.serviceDirectory}/service.properties").toURL())

//here we define a function which will parse an array of String args
//and return if found the value of the artifact whose name is passed
def getArtifactFrom(artifactName, String... artifacts) {
  for( it in artifacts){
    def split = it.split("=")
    if(split.length > 1 && split[0].equals(artifactName)){
       return split[1]
    }
  }
}

def websiteRelativePath = getArtifactFrom("website_zip", args)
def websiteAbsolutePath = "${context.serviceDirectory}/../${websiteRelativePath}"
def zipUrl =  (config.website.zip_url) ? config.website.zip_url : "";

builder.sequential {
  exec(executable:"${context.serviceDirectory}/scripts/deploy_website.sh", osfamily:"unix",failonerror: "true") {
    env(key:"WEBFILE_ZIP", value:websiteAbsolutePath)
    env(key:"WEBFILE_URL", value:zipUrl)
    env(key:"CONTEXT_PATH", value:config.website.context_path)
    env(key:"DOC_ROOT", value:config.apache.document_root)
  }
}
