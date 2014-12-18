/*******************************************************************************
* Copyright (c) 2013 GigaSpaces Technologies Ltd. All rights reserved
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*       http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/
import org.cloudifysource.dsl.utils.ServiceUtils

println "updateWarOnTomcat.groovy: Starting..."

if( args == null || args.length < 2 ) {
    throw new IllegalArgumentException("updateWarOnTomcat command requires an url and a contextPath as arguments.")
}
def url = args[0]
def contextPath = args[1]
if(url ==null | contextPath == null) return "war url or contextPath is null. So we do nothing.";

println "updateWarOnTomcat.groovy: catalinaBase: ${catalinaBase}, installDir: ${installDir}, warUrl: ${url}, contextPath: ${contextPath}"

def applicationWar = "${installDir}/${new File(url).name}"

//get the WAR file
new AntBuilder().sequential {
	if ( url.toLowerCase().startsWith("http") || url.toLowerCase().startsWith("ftp")) {
		echo(message:"Getting ${url} to ${applicationWar} ...")
		ServiceUtils.getDownloadUtil().get("${url}", "${applicationWar}", false)
	}
	else {
		echo(message:"Copying ${url} to ${applicationWar} ...")
		copy(tofile: "${applicationWar}", file:"${url}", overwrite:true)
	}
}

//configure its tomcat context
File ctxConf = new File("${catalinaBase}/conf/Catalina/localhost/${contextPath}.xml")
if (ctxConf.exists()) {
	assert ctxConf.delete()
} else {
	new File(ctxConf.getParent()).mkdirs()
}
assert ctxConf.createNewFile()
ctxConf.append("<Context docBase=\"${applicationWar}\" />")

println "updateWarOnTomcat.groovy: End"
return true