import java.io.File

println "Start of wordpress..."
boolean success = new File("/tmp/wordpress-started").createNewFile()
println "Wordpress is started : ${success}"
