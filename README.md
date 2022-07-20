WuKong - An Alternative Way to Accelerate EP Development Environment Setup and Switching
======
Adopting Convention ~over~ is Configuration
------
# Background
for maven based project delivery and product developemnt, developers may often switch among different projects/branches. Each project may need different maven and jdk version, which cost time and may involve mistakes. Each project/branch may need to point to an individual data source as well.
> sharing local maven repository across different projects is risky <br/>
> sharing data source is also risky and painful. <br/>

To resolve that, typically, maven offers option to determine the settings.xml and local maven repository location. But that is inconvinent on typing each command with that option.
> manual configuration to run maven is painful.

Docker technology also offers the availability to start container against different ports for differnt applications. But it is also inconvinent to specify them again and again.
> manual configuration to run docker is painful, too.

The ideal way is to make all options could be automated discovered. So developers can transparently use the maven and docker accross different configuration, as well as to make life easy in switching to new ad hoc task or back to previous WIP project. and also able to retain all the data states.

# What Is It
Inspired by maven concept "Convention over Configuration". The Wukong contains set of predefined docker and mvn aliases and project folder naming convention to achieve that. The detailed of command aliases please find in reference.

the naming convention is **PROJECT-NAME**\_ep**EP-VERSION**\_docker**DOCKER-PORT**\_**DOCKER-IMAGE-REPO**\_**DOCKER-IMAGE-TAG**
* **PROJECT-NAME**, task name or id to indicate the purpose of the folder.  e.g. PB1234
* **EP-VERSION**, digits or with `x` suffix to indicate related maven and jdk version. follows `ep` prefix keyword. e.g. ep73
* **DOCKER-PORT**, the port of the docker container
* **DOCKER-IMAGE-REPO**, the repository of docker image
* **DOCKER-IMAGE-TAG**, the tag of the docker image

for example `PB1234_ep73_docker33730_pdmysql_7.3.x` <br/>
reading of this: here is a folder for task `PB1234`, ep code base is version `7.3`, the docker images is `$MY_DOCKER_ACCOUNT/pdmysql:7.3.x`, and run at port `33730`.

# How Does It Work
since the project folder name is composed with the necessary options for build and runtime. that means we already know all of the context.

once enter the folder, the predefined aliases provided by this accelerator project will evaluate the current working folder and extract all the inline options and refresh the corresponding environment variables, then delegate them to the corresponding docker or mvn command. then the code could be built and executed as usual without any difference, and developers don't have to specify any options to determine the maven version/jdk version/local maven repository/database, etc.

when developers swtich to different project folder, the shell will always inspect and discover the current working directory and run proper configuration against current folder name.

# Who Should Use It
for those who are anony for switching development context, especially ep developers work for project delivery and product contribution, need to across different maven version/jdk version/branches.

the typical development lifesycle will be
1. get a jira task
2. create a project folder against the jira task
3. import project into intellj or other ide, specify the project `.m2` folder when import module.
4. develop and deliver it, build, populate db
5. retain this folder and switch to another ad-hoc task ( repeat same steps from beginning )
6. go back to this task, start up mysql container, continue and done the job
7. remove the entile folder
now everything is clean.

# How to Use It
## Setup
### preparation
* clone this repo to user home directory <br/>
run `git clone git@github.com:nelsonq/wukong.git` will establish folder `~/wukong`
* establish home directory for all projects <br/>
`mkdir -p ~/Work/githome`
* install all maven version used by ep projects under same folder. e.g. `~/apphome`<br/>
> NOTE: or run `mkdir ~/apphome; ~/wukong/bin/install-all-ep-maven.sh ~/apphome` which will download and install all necessary maven releases on target folder, e.g `~/apphome`

### configure
* introduce the accelerator bashes.
edit `~/.bash_profile`, add below line after current path setting.
```
export MAVEN_INST_ROOT=~/Work/apphome
export MY_DOCKER_ACCOUNT=
source ~/wukong/bash/myepdev-aliases.bash
source ~/wukong/bash/myepdev-profile.bash
```
> fill out the MY_DOCKER_ACCOUNT with your account name, if blank, will be using nelsonqiao instead. <br/>
> note: if existing PATH already contains M2_HOME or JAVA_HOME, they could be removed. because of this bash will populate them. <br/>
> for linux. TBD. may need change the folder of jdk installation which are hard coded in current version.

* create new project with naming convention.<br/>
for example, to develop a product contribution story PB1234 agaisnt ep 7.3,
> PB1234 is to identify the purpose of the project <br/>
> ep73 is to indicate the version of ep, ep here is a keyword <br/>
> docker33730_pdmysql_ep7.3 is to indicate the project will use a mysql docker image of pdmysql:ep7.3 at port 33730 <br/>

```
mkdir ~/Work/githome/PB1234_ep73_docker33730_pdmysql_ep7.3
mkdir ~/Work/githome/PB1234_ep73_docker33730_pdmysql_ep7.3/.m2/repository
ln -s ~/.m2/settings.xml ~/Work/githome/PB1234_ep73_docker33730_pdmysql_ep7.3/.m2/settings.xml
# the easy way to resuse existing settings.xml, or can be copied from somewhere else

```
> note: or run a handy shell to establish it `~/wukong/bin/init-product-contribution-project.sh PB1234_ep73_docker33730_pdmysql_ep7.3`

## then done
go into the project directory <br/>
`cd ~/Work/githome/PB1234_ep73_docker33730_pdmysql_ep7.3/ep-commerce`

### show version
run `mymvn -version` <br/>
should be able show the maven and jdk version. check if they are correct.

### build source
run `mymvn clean install -DskipAllTests` or `mymvn-ciskip` <br/>
> note: <br/>
> all dependent artifects will be downloaded under `~/Work/githome/PB1234_ep73_docker33730_pdmysql_ep7.3/.m2/repository`

### start mysql
run `mydocker-start-mysql` <br/>
a docker container named `PB1234_ep73_docker33730_pdmysql_ep7.3` will be launched at 33730, which loades images `nelsonqiao/pdmysql:7.3`

### populate the db
run `mymvn clean package -Preset-db -f extensions/database/pom.xml` or `myepmvn-reset-db`

### note
* run maven command as usual only difference is to use `mymvn` instead of `mvn`
* type `mymvn`, `myepmvn`, `mydocker` and then press tab key, should promote the list of pre defined commands.

# Reference
## mymvn commands
* `mymvn`                      equivalent to `mvn`
* `mymvn-ciskip`               equivalent to `mvn clean install -DskipAllTests`      
* `mymvn-debug`                equivalent to `mvnDebug`             
* `mymvn-run-tomcat8`          equivalent to `mvn clean tomcat8:run-war`       
* `mymvn-run-tomcat8-debug`    equivalent to `mvnDebug clean tomcat8:run-war`

## myepmvn commands
* `myepmvn-reset-db`         reset db
* `myepmvn-update-db`        update db
* `myepmvn-run-cm`           start up cm server
* `myepmvn-run-cortex`       start up cortex server
* `myepmvn-run-int`          start up integration server
* `myepmvn-run-search`       start up search server
* `myepmvn-run-amq`          start up active mq instance
* `myepmvn-run-cm-debug`     start up cm server in debug mode
* `myepmvn-run-cortex-debug` start up cortex in debug mode
* `myepmvn-run-int-debug`    start up integration server in debug mode
* `myepmvn-run-search-debug` start up search server in debug mode
* `myepmvn-run-cm8`           start up cm server with tomcat 8
* `myepmvn-run-cortex8`       start up cortex server with tomcat 8
* `myepmvn-run-int8`          start up integration server with tomcat 8
* `myepmvn-run-batch8`        start up batch server with tomcat 8
* `myepmvn-run-search8`       start up search server with tomcat 8
* `myepmvn-run-amq8`          start up active mq instance with tomcat 8
* `myepmvn-run-cm8-debug`     start up cm server in debug mode with tomcat 8
* `myepmvn-run-cortex8-debug` start up cortex in debug mode with tomcat 8
* `myepmvn-run-int8-debug`    start up integration server in debug mode with tomcat 8
* `myepmvn-run-batch8-debug`    start up batch server in debug mode with tomcat 8
* `myepmvn-run-search8-debug` start up search server in debug mode with tomcat 8
* `myepmvn-build-cortex`     build cortex module
* `myepmvn-build-ext-core`   build extension core module
* `myepmvn-selenium`           verify remote selenium tests
* `myepmvn-selenium-cm-ext-cm-modules` verify remote selenium tests on cm/ext-cm-modules

## mydocker commands
* `mydocker-start`             start predefined container.
* `mydocker-start-oracle`      start predefined oracle container.
* `mydocker-start-mysql5.6`    start mysql 5.6 container
* `mydocker-start-mysql5.7`    start mysql 5.7 container
* `mydocker-stop`              stop predefined db container run at the docker port
* `mydocker-remove`            remove inactive predefined db container
* `mydocker-terminate`         stop and remove predefined db container
* `mydocker-cleanup-container` remove all inactive mysql container
* `mydocker-create-snapshot`   create snapshot image with tag name
* `mydocker-create-snapshot-with-stop`   stop container and create snapshot image with tag name
* `mydocker-remove-snapshot`   remove snapshot image with tag name
* `mydocker-reload`            reload predefined image
* `mydocker-reload-oracle`     reload predefined oracle image
* `mydocker-logs`              show logs of current container
* `mydocker-logs-follow`       show logs of current container with follow option
* `mydocker-run-selenium-standalone-3.141.59-20200525` run selenium standalone docker container with version 3.141.59-20200525
