# Workflow resume tests scripts

To test worfklow resume functionalities proceed as follows:

- customize variables in `setvars.sh` (to define A4C base url, A4C login and password, application id and optionally workflow step to be reset) and set the environment name in the `env.json` file
- run `source ./init.sh` : this script connects to A4C and gets environment id, deployment id, last execution id
- run `./showexec.sh` to see last execution details
- run `./showallexecs.sh` to see all execution ids ans statuses
- run `./resetstep.sh` to reset step given its name for an execution given its id (STEPNAME and EXEC_ID variables)
- run `./resume.sh` to resume execution given by its id (EXEC_ID variable)
- run `./resume-latest.sh` to resume latest execution

*prerequisites* : the scripts make use of `curl` and `jq`.

You may use for exemple the topology `org.alien4cloud.mock.topologies.wfresume` which contains custom workflows wich calls custom operations which randomly fails: deploy this topology, run a custom workflow until it is failed, and then you may use the scripts as explained above.