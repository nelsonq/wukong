#!/bin/sh
MY_DOCKER_ACCOUNT=${MY_DOCKER_ACCOUNT:=nelsonqiao}
_mydocker_run_mysql_func (){
   DOCKER_HOST_PORT=$2
   DOCKER_IMAGE=$1
   DOCKER_CONTAINER_NAME=$3
   echo "container running : from $DOCKER_IMAGE"
   docker run --name $DOCKER_CONTAINER_NAME -e MYSQL_ROOT_PASSWORD=root -p $DOCKER_HOST_PORT:3306 -d $DOCKER_IMAGE
}

_mydocker_stop_mysql_func (){
   echo "container stopping : $DOCKER_CONTAINER_EP_MYSQL_NAME"
   docker stop $1 && docker rm $1
}
alias mydockerenv='export MY_DOCKER_PORT=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/[^/^_].*_docker\([0-9]\{5\}\).*|\1|p'"'"')&&export MY_PROJ_NAME=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/\([^/]*\).*|\1|p'"'"')&&export MY_DOCKER_IMAGE_REPO=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/[^/^_].*_docker[0-9]\{5\}_\([0-9a-z]\{1,20\}\).*|\1|p'"'"')&&export MY_DOCKER_IMAGE_TAG=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/[^/^_].*_docker[0-9]\{5\}_[0-9a-z]\{1,20\}_\([0-9a-z\.]\{1,20\}\).*|\1|p'"'"')'
alias mydocker-start-mysql5.7='mydockerenv && _mydocker_run_mysql_func $MY_DOCKER_ACCOUNT/mysql:5.7 $MY_DOCKER_PORT $MY_PROJ_NAME'
alias mydocker-start-mysql5.6='mydockerenv && _mydocker_run_mysql_func $MY_DOCKER_ACCOUNT/mysql:5.6 $MY_DOCKER_PORT $MY_PROJ_NAME'
alias mydocker-stop-mysql='mydockerenv && docker ps -a | grep 0.0.0.0:$MY_DOCKER_PORT | awk '"'"'/ / { print $1 }'"'"'| xargs -I {} docker stop {}' 
alias mydocker-start-mysql='mydockerenv && _mydocker_run_mysql_func $MY_DOCKER_ACCOUNT/$MY_DOCKER_IMAGE_REPO:$MY_DOCKER_IMAGE_TAG $MY_DOCKER_PORT $MY_PROJ_NAME'
alias mydocker-remove-mysql='mydockerenv && docker ps -a | grep docker$MY_DOCKER_PORT | awk '"'"'/ / { print $1 }'"'"'| xargs -I {} docker rm {}'
alias mydocker-cleanup-container='docker rm $(docker ps -qa --no-trunc --filter "status=exited")'

# start tomcat server
alias mymvn-run-tomcat7='mymvn clean tomcat7:run-war'
alias mymvn-run-tomcat7-debug='mymvn-debug clean tomcat7:run-war'
alias mymvn-run-tomcat8='mymvn clean tomcat8:run-war'
alias mymvn-run-tomcat8-debug='mymvn-debug clean tomcat8:run-war'
alias myepmvn-run-cortex='mymvn-run-tomcat7 -f extensions/cortex/ext-cortex-webapp/pom.xml'
alias myepmvn-run-search='mymvn-run-tomcat7 -f extensions/search/ext-search-webapp/pom.xml'
alias myepmvn-run-amq='mymvn-run-tomcat7 -f extensions/activemq-broker/pom.xml'
alias myepmvn-run-cm='mymvn-run-tomcat7 -f extensions/cm/ext-cm-modules/ext-cm-webapp-runner/pom.xml -Dorg.eclipse.rap.rwt.enableUITests=true'
alias myepmvn-run-int='mymvn-run-tomcat7 -f extensions/integration/ext-integration-webapp/pom.xml'

alias myepmvn-run-cortex-debug='mymvn-run-tomcat7-debug -f extensions/cortex/ext-cortex-webapp/pom.xml'
alias myepmvn-run-search-debug='mymvn-run-tomcat7-debug -f extensions/search/ext-search-webapp/pom.xml'
alias myepmvn-run-cm-debug='mymvn-run-tomcat7-debug -f extensions/cm/ext-cm-modules/ext-cm-webapp-runner/pom.xml -Dorg.eclipse.rap.rwt.enableUITests=true'
alias myepmvn-run-int-debug='mymvn-run-tomcat7-debug -f extensions/integration/ext-integration-webapp/pom.xml'

alias myepmvn-run-cortex8='mymvn-run-tomcat8 -f extensions/cortex/ext-cortex-webapp/pom.xml'
alias myepmvn-run-search8='mymvn-run-tomcat8 -f extensions/search/ext-search-webapp/pom.xml'
alias myepmvn-run-amq8='mymvn-run-tomcat8 -f extensions/activemq-broker/pom.xml'
alias myepmvn-run-cm8='mymvn-run-tomcat8 -f extensions/cm/ext-cm-modules/ext-cm-webapp-runner/pom.xml -Dorg.eclipse.rap.rwt.enableUITests=true'
alias myepmvn-run-int8='mymvn-run-tomcat8 -f extensions/integration/ext-integration-webapp/pom.xml'

alias myepmvn-run-cortex8-debug='mymvn-run-tomcat8-debug -f extensions/cortex/ext-cortex-webapp/pom.xml'
alias myepmvn-run-search8-debug='mymvn-run-tomcat8-debug -f extensions/search/ext-search-webapp/pom.xml'
alias myepmvn-run-cm8-debug='mymvn-run-tomcat8-debug -f extensions/cm/ext-cm-modules/ext-cm-webapp-runner/pom.xml -Dorg.eclipse.rap.rwt.enableUITests=true'
alias myepmvn-run-int8-debug='mymvn-run-tomcat8-debug -f extensions/integration/ext-integration-webapp/pom.xml'

# maven clean and build
alias mymvn-ciskip='mymvn clean install -DskipAllTests'

# maven clean all snapshot build folder to shrink and save disk space.
alias mymvn-clean-repository='find ~/.m2 -name \*SNAPSHOT -type d -print0 | xargs -0 rm -rf' 

# git aliases
alias mygit-log-oneline='git log --pretty=format:"%h%x09%an%x09%ad%x09%s"'
alias mygit-remote-add-upstream='git remote add upstream'

# using this pattern base_dir + working_dir to make sure the project not under the githome still can get regular access to .m2 
alias basemymvn='mydockerenv&&MY_MVN_PROJ_PATH=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'\(/Work/githome/[^/]*\).*|\1|p'"'"')&&$M2_HOME/bin/mvn -Dmaven.repo.local=$HOME/$MY_MVN_PROJ_PATH/.m2/repository -s $HOME/$MY_MVN_PROJ_PATH/.m2/settings.xml -Depdb.port=$MY_DOCKER_PORT'
alias mymvn-debug='mydockerenv&&MY_MVN_PROJ_PATH=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'\(/Work/githome/[^/]*\).*|\1|p'"'"')&&MY_MVN_PROJ_NAME=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/maven[0-9]\{3\}/\([^/]*\).*|\1|p'"'"')&&$M2_HOME/bin/mvnDebug -Dmaven.repo.local=$HOME/$MY_MVN_PROJ_PATH/$MY_MVN_PROJ_NAME/.m2/repository -s $HOME/$MY_MVN_PROJ_PATH/$MY_MVN_PROJ_NAME/.m2/settings.xml  -DforkMode=never -Depdb.port=$MY_DOCKER_PORT'

# extract ep version
# echo $PWD | sed -n 's|'"$HOME"'/Work/githome/\([^/]*\).*|\1|p'
alias mymvn='export MY_EP_VERSION=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/[^/^_].*_ep\([0-9]\{1,10\}[x]\{0,1\}\)_.*|\1|p'"'"')&&export M2_HOME=$(printenv M2_HOME_EP$(echo $MY_EP_VERSION))&&export JAVA_HOME=$(printenv JAVA_HOME_EP$(echo $MY_EP_VERSION))&&export MAVEN_OPTS=$(printenv MAVEN_OPTS_EP$(echo $MY_EP_VERSION))&&export JAVA_OPTS=$(printenv JAVA_OPTS_EP$(echo $MY_EP_VERSION))&&basemymvn'

alias mydocker-run-jenkins="docker run -u root --name myjenkinsci --rm -d -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock nelsonqiao/myjenkinsci"

# other ep related mvn command.
alias myepmvn-update-db='mymvn clean package -Pupdate-db -f extensions/database/pom.xml'
alias myepmvn-reset-db='mymvn clean package -Preset-db -f extensions/database/pom.xml'
alias myepmvn-build-cortex='mymvn-ciskip -f extensions/cortex/pom.xml'
alias myepmvn-build-ext-core='mymvn-ciskip -f extensions/core/ext-core/pom.xml'
