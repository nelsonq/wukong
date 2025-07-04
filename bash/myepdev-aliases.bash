#!/bin/sh
MY_DOCKER_ACCOUNT=${MY_DOCKER_ACCOUNT:=nelsonqiao}
_mydocker_run_func (){
   DOCKER_INTERNAL_PORT_FOR_MYSQL=3306
   DOCKER_INTERNAL_PORT_FOR_ORACCLE=1521
   DOCKER_PASSWORD_ENV_FOR_MYSQL='-e MYSQL_ROOT_PASSWORD=root'
   DOCKER_PASSWORD_ENV_FOR_ORACLE='-e ORACLE_PWD=oracle'

   DOCKER_INTERNAL_PORT=$DOCKER_INTERNAL_PORT_FOR_MYSQL
   DOCKER_PASSWORD_ENV=$DOCKER_PASSWORD_ENV_FOR_MYSQL

   DOCKER_IMAGE=$1
   DOCKER_HOST_PORT=$2
   DOCKER_CONTAINER_NAME=$3
   OTHER_DOCKER_OPTIONS=${@:4}

   echo "running container from $DOCKER_IMAGE"
   if [[ $DOCKER_IMAGE == *"oracle"* ]]; then
      echo "This is an Oracle DB."
      DOCKER_INTERNAL_PORT=$DOCKER_INTERNAL_PORT_FOR_ORACCLE
      DOCKER_PASSWORD_ENV=$DOCKER_PASSWORD_ENV_FOR_ORACLE
   fi
   echo $DOCKER_DEFAULT_PLATFORM
   echo $DOCKER_IMAGE
   echo $DOCKER_HOST_PORT
   echo $DOCKER_CONTAINER_NAME
   echo $OTHER_DOCKER_OPTIONS
   echo $DOCKER_INTERNAL_PORT
   echo $DOCKER_PASSWORD_ENV
   set -x
   docker run --platform $DOCKER_DEFAULT_PLATFORM --name $DOCKER_CONTAINER_NAME -p $DOCKER_HOST_PORT:$DOCKER_INTERNAL_PORT $(echo $DOCKER_PASSWORD_ENV) -d $(echo $DOCKER_IMAGE $OTHER_DOCKER_OPTIONS)
}
# with read committed and default time zone setting
_mydocker_run_func_mysql_rc(){
  _mydocker_run_func $1 $2 $3 --transaction_isolation=READ-COMMITTED --default-time-zone=+00:00
}
_mydocker_run_func_mysql5.7rc(){
  _mydocker_run_func_mysql_rc mysql:5.7 $1 $2
}
_mydocker_run_func_mysql8.0rc(){
  _mydocker_run_func_mysql_rc mysql:8.0 $1 $2
}

_mydocker_create_snapshot(){
   TAG_NAME=${3:-default}
   SNAPSHOT_NAME=$2:snapshot_$TAG_NAME
   echo "creating a snapshot image [$SNAPSHOT_NAME] from docker container: [$1]"
   if [[ "$(docker images -q $SNAPSHOT_NAME 2> /dev/null)" == "" ]];
   then
     docker commit $1 $SNAPSHOT_NAME
   else
     echo "Image [$SNAPSHOT_NAME] exists. Please delete the image before creating a new snapshot."
   fi

}

_mydocker_remove_snapshot(){
   TAG_NAME=${2:-default}
   SNAPSHOT_NAME=$1:snapshot_$TAG_NAME
   echo "delating a snapshot image $SNAPSHOT_NAME"
   docker rmi $SNAPSHOT_NAME
}

# extract inline environment variables
alias mydockerenv='export MY_DOCKER_PORT=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/[^/^_].*_docker\([0-9]\{4,5\}\).*|\1|p'"'"')&&export MY_PROJ_NAME=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/\([^/]*\).*|\1|p'"'"')&&export MY_DOCKER_IMAGE_REPO=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/[^/^_].*_docker[0-9]\{4,5\}_\([0-9a-z]\{1,20\}\).*|\1|p'"'"')&&export MY_DOCKER_IMAGE_TAG=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/[^/^_].*_docker[0-9]\{4,5\}_[0-9a-z]\{1,20\}_\([-0-9a-zA-Z_\.]\{1,50\}\).*|\1|p'"'"')'

# start container from image
alias mydocker-start-mysql5.7='mydockerenv && _mydocker_run_func mysql:5.7 $MY_DOCKER_PORT $MY_PROJ_NAME --default-time-zone=+00:00'
alias mydocker-start-mysql5.6='mydockerenv && _mydocker_run_func $MY_DOCKER_ACCOUNT/mysql:5.6 $MY_DOCKER_PORT $MY_PROJ_NAME'

alias mydocker-start-oracle='mydockerenv && _mydocker_run_func $MY_DOCKER_ACCOUNT/$MY_DOCKER_IMAGE_REPO:$MY_DOCKER_IMAGE_TAG $MY_DOCKER_PORT $MY_PROJ_NAME 1521'

alias mydocker-start='mydockerenv && _mydocker_run_func_$MY_DOCKER_IMAGE_REPO$MY_DOCKER_IMAGE_TAG $MY_DOCKER_PORT $MY_PROJ_NAME'

# create snapshot from current container
# mydocker-create-snapshot [tag-name]
alias mydocker-create-snapshot='mydockerenv && _mydocker_create_snapshot $MY_PROJ_NAME $MY_DOCKER_ACCOUNT/$MY_DOCKER_IMAGE_REPO'
alias mydocker-create-snapshot-with-stop='mydockerenv && mydocker-stop && _mydocker_create_snapshot $MY_PROJ_NAME $MY_DOCKER_ACCOUNT/$MY_DOCKER_IMAGE_REPO'
# remove snapshot from image list
# mydocker-remove-snapshot [tag-name]
alias mydocker-remove-snapshot='mydockerenv && _mydocker_remove_snapshot $MY_DOCKER_ACCOUNT/$MY_DOCKER_IMAGE_REPO'

# stop current docker container
alias mydocker-stop='mydockerenv && docker ps -a | grep 0.0.0.0:$MY_DOCKER_PORT | awk '"'"'/ / { print $1 }'"'"'| xargs -I {} docker stop {}'

# remove current docker container
alias mydocker-remove='mydockerenv && docker ps -a | grep docker$MY_DOCKER_PORT | awk '"'"'/ / { print $1 }'"'"'| xargs -I {} docker rm {}'

# stop and remove current docker container
alias mydocker-terminate='mydocker-stop && mydocker-remove'

# reload docker image, any data in current container will be dropped off.
alias mydocker-reload-oracle='mydocker-terminate && mydocker-start-oracle'
alias mydocker-reload='mydocker-terminate && mydocker-start'

# show log of current container
alias mydocker-logs='mydockerenv && docker logs $MY_PROJ_NAME'
alias mydocker-logs-follow='mydockerenv && docker logs -f $MY_PROJ_NAME'
# clean up any existed status container
alias mydocker-cleanup-container='docker rm $(docker ps -qa --no-trunc --filter "status=exited")'

# remove all of the dangling images, which contains <none>.
alias mydocker-cleanup-dangling-images='docker rmi $(docker images -f "dangling=true" -q)'

# run selenium standalone docker container
alias mydocker-run-selenium-standalone-3.141.59-20200525="docker run -d \
-p 4444:4444 \
-p 5900:5900 \
-e SCREEN_WIDTH=1920 \
-e SCREEN_HEIGHT=1080 \
-e SCREEN_DEPTH=24 \
--shm-size=2g \
selenium/standalone-chrome-debug:3.141.59-20200525"

# start tomcat server
alias mymvn-run-tomcat8='mymvn clean tomcat8:run-war -nsu '
alias mymvn-run-tomcat8-debug='mymvn-debug clean tomcat8:run-war -nsu '

alias myepmvn-run-cortex='mymvn-run-tomcat8 -f extensions/cortex/ext-cortex-webapp/pom.xml'
alias myepmvn-run-search='mymvn-run-tomcat8 -f extensions/search/ext-search-webapp/pom.xml'
alias myepmvn-run-amq='mymvn-run-tomcat8 -f extensions/activemq-broker/pom.xml'
alias myepmvn-run-cm='mymvn-run-tomcat8 -f extensions/cm/ext-cm-modules/ext-cm-webapp-runner/pom.xml -Dorg.eclipse.rap.rwt.enableUITests=true'
alias myepmvn-run-int='mymvn-run-tomcat8 -f extensions/integration/ext-integration-webapp/pom.xml'
alias myepmvn-run-batch='mymvn-run-tomcat8 -f extensions/batch/ext-batch-webapp/pom.xml'

alias myepmvn-run-cortex-debug='mymvn-run-tomcat8-debug -f extensions/cortex/ext-cortex-webapp/pom.xml'
alias myepmvn-run-search-debug='mymvn-run-tomcat8-debug -f extensions/search/ext-search-webapp/pom.xml'
alias myepmvn-run-cm-debug='mymvn-run-tomcat8-debug -f extensions/cm/ext-cm-modules/ext-cm-webapp-runner/pom.xml -Dorg.eclipse.rap.rwt.enableUITests=true'
alias myepmvn-run-int-debug='mymvn-run-tomcat8-debug -f extensions/integration/ext-integration-webapp/pom.xml'
alias myepmvn-run-batch-debug='mymvn-run-tomcat8-debug -f extensions/batch/ext-batch-webapp/pom.xml'

alias myepmvn-run-cortex8='mymvn-run-tomcat8 -f extensions/cortex/ext-cortex-webapp/pom.xml'
alias myepmvn-run-search8='mymvn-run-tomcat8 -f extensions/search/ext-search-webapp/pom.xml'
alias myepmvn-run-amq8='mymvn-run-tomcat8 -f extensions/activemq-broker/pom.xml'
alias myepmvn-run-cm8='mymvn-run-tomcat8 -f extensions/cm/ext-cm-modules/ext-cm-webapp-runner/pom.xml -Dorg.eclipse.rap.rwt.enableUITests=true'
alias myepmvn-run-int8='mymvn-run-tomcat8 -f extensions/integration/ext-integration-webapp/pom.xml'
alias myepmvn-run-batch8='mymvn-run-tomcat8 -f extensions/batch/ext-batch-webapp/pom.xml'

alias myepmvn-run-cortex8-debug='mymvn-run-tomcat8-debug -f extensions/cortex/ext-cortex-webapp/pom.xml'
alias myepmvn-run-search8-debug='mymvn-run-tomcat8-debug -f extensions/search/ext-search-webapp/pom.xml'
alias myepmvn-run-cm8-debug='mymvn-run-tomcat8-debug -f extensions/cm/ext-cm-modules/ext-cm-webapp-runner/pom.xml -Dorg.eclipse.rap.rwt.enableUITests=true'
alias myepmvn-run-int8-debug='mymvn-run-tomcat8-debug -f extensions/integration/ext-integration-webapp/pom.xml'
alias myepmvn-run-batch8-debug='mymvn-run-tomcat8-debug -f extensions/batch/ext-batch-webapp/pom.xml'

alias mymvn-cargorun='mymvn cargo:run -nsu '
alias mymvn-cargorun-debug='mymvn-cargorun -Ddebug'
alias myepmvn-cargorun-cortex='mymvn-cargorun -f extensions/cortex/ext-cortex-webapp/pom.xml'
alias myepmvn-cargorun-amq='mymvn-cargorun -f extensions/activemq-broker/pom.xml'
alias myepmvn-cargorun-batch='mymvn-cargorun -f extensions/batch/ext-batch-webapp/pom.xml'
alias myepmvn-cargorun-cmrunner='mymvn-cargorun -f extensions/cm/ext-cm-modules/ext-cm-webapp-runner/pom.xml'
alias myepmvn-cargorun-cmweb='mymvn-cargorun -f extensions/cm/ext-cm-modules/ext-cm-webapp/pom.xml'
alias myepmvn-cargorun-int='mymvn-cargorun -f extensions/integration/ext-integration-webapp/pom.xml'
alias myepmvn-cargorun-search='mymvn-cargorun -f extensions/search/ext-search-webapp/pom.xml'
alias myepmvn-cargorun-sync='mymvn-cargorun -f extensions/sync/ext-sync-webapp/pom.xml'

alias mymvn-cp-cargorun='mymvn clean package cargo:run -nsu '
# alias mymvn-cp-cargorun-debug='mymvn-cp-cargorun -Ddebug' I dont think build is necessary for debug
alias myepmvn-cp-cargorun-cortex='mymvn-cp-cargorun -f extensions/cortex/ext-cortex-webapp/pom.xml'
alias myepmvn-cp-cargorun-amq='mymvn-cp-cargorun -f extensions/activemq-broker/pom.xml'
alias myepmvn-cp-cargorun-batch='mymvn-cp-cargorun -f extensions/batch/ext-batch-webapp/pom.xml'
alias myepmvn-cp-cargorun-cmrunner='mymvn-cp-cargorun -f extensions/cm/ext-cm-modules/ext-cm-webapp-runner/pom.xml'
alias myepmvn-cp-cargorun-cmweb='mymvn-cp-cargorun -f extensions/cm/ext-cm-modules/ext-cm-webapp/pom.xml'
alias myepmvn-cp-cargorun-int='mymvn-cp-cargorun -f extensions/integration/ext-integration-webapp/pom.xml'
alias myepmvn-cp-cargorun-search='mymvn-cp-cargorun -f extensions/search/ext-search-webapp/pom.xml'
alias myepmvn-cp-cargorun-sync='mymvn-cp-cargorun -f extensions/sync/ext-sync-webapp/pom.xml'

alias myepmvn-cargorun-cortex-debug='mymvn-cargorun-debug -f extensions/cortex/ext-cortex-webapp/pom.xml'

alias myepmvn-ciskip-cm-excluded-mt='mymvn clean install -T 0.75C -DskipAllTests -pl -:cm-parent,-:ext-cm-parent,-:ext-cm-repository,-:webapp-smoketests'
alias myepmvn-ciskip-cm-only-st='mymvn clean install -T 1 -DskipAllTests -pl :cm-parent,:ext-cm-parent,:ext-cm-repository,:webapp-smoketests'
alias myepmvn-ciskip-mt='myepmvn-ciskip-cm-excluded-mt && myepmvn-ciskip-cm-only-st'

alias myepmvn-gooffline='mymvn dependency:go-offline -DincludeScope=compile -fn || true'

# maven clean and build
alias mymvn-ciskip='mymvn clean install -DskipAllTests'
alias mymvn-ciskip-mt='mymvn-ciskip -T 0.5C'
alias mymvn-ciskip-mt6='mymvn-ciskip -T 6'
alias mymvn-ciskip-mt4='mymvn-ciskip -T 4'
alias mymvn-ciskip-mt2='mymvn-ciskip -T 2'

# maven clean all snapshot build folder to shrink and save disk space.
alias mymvn-clean-repository='find ~/.m2 -name \*SNAPSHOT -type d -print0 | xargs -0 rm -rf'

# git aliases
alias mygit-log-oneline='git log --pretty=format:"%h%x09%an%x09%ad%x09%s"'
alias mygit-remote-add-upstream='git remote add upstream'

# using this pattern base_dir + working_dir to make sure the project not under the githome still can get regular access to .m2
alias basemymvn='mydockerenv&&MY_MVN_PROJ_PATH=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'\(/Work/githome/[^/]*\).*|\1|p'"'"')&&$M2_HOME/bin/mvn -nsu -Dmaven.repo.local=$HOME/$MY_MVN_PROJ_PATH/.m2/repository -s $HOME/$MY_MVN_PROJ_PATH/.m2/settings.xml -Depdb.port=$MY_DOCKER_PORT -Depdb.synctarget.port=$MY_DOCKER_PORT -P$MY_DOCKER_IMAGE_REPO-dev-db'
alias mymvn-debug='mydockerenv&&MY_MVN_PROJ_PATH=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'\(/Work/githome/[^/]*\).*|\1|p'"'"')&&MY_MVN_PROJ_NAME=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/maven[0-9]\{3\}/\([^/]*\).*|\1|p'"'"')&&$M2_HOME/bin/mvnDebug -nsu -Dmaven.repo.local=$HOME/$MY_MVN_PROJ_PATH/$MY_MVN_PROJ_NAME/.m2/repository -s $HOME/$MY_MVN_PROJ_PATH/$MY_MVN_PROJ_NAME/.m2/settings.xml  -DforkMode=never -Depdb.port=$MY_DOCKER_PORT -P$MY_DOCKER_IMAGE_REPO-dev-db'

# extract ep version
# echo $PWD | sed -n 's|'"$HOME"'/Work/githome/\([^/]*\).*|\1|p'
alias mymvn='export MY_EP_VERSION=$(echo $PWD | sed -n '"'"'s|'"'"'"$HOME"'"'"'/Work/githome/[^/^_].*_ep\([0-9]\{1,10\}[x]\{0,1\}\)_.*|\1|p'"'"') \
             && export M2_HOME=$(printenv M2_HOME_EP$(echo $MY_EP_VERSION)) \
             && export MAVEN_OPTS=$(printenv MAVEN_OPTS_EP$(echo $MY_EP_VERSION)) \
             && export JAVA_OPTS=$(printenv JAVA_OPTS_EP$(echo $MY_EP_VERSION)) \
             && basemymvn'

alias mydocker-run-jenkins="docker run -u root --name myjenkinsci --rm -d -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock nelsonqiao/myjenkinsci"

# testing ep related mvn command
# host.docker.internal is only work with mac. Linux uses another way.
alias myepmvn-selenium='mymvn clean verify -Dselenium.session.browser=remote_chrome -Dremote.web.driver.url=http://localhost:4444/wd/hub -Dselenium.session.baseurl=http://host.docker.internal:8081/cm '
alias myepmvn-selenium-cm-ext-cm-modules='myepmvn-selenium -f extensions/cm/ext-cm-modules/system-tests/selenium/pom.xml '

# other ep related mvn command.
alias myepmvn-update-db='mymvn clean package -Pupdate-db -f extensions/database/pom.xml'
alias myepmvn-reset-db='mymvn clean package -Preset-db -f extensions/database/pom.xml'
alias myepmvn-build-cortex='mymvn-ciskip -f extensions/cortex/pom.xml'
alias myepmvn-build-ext-core='mymvn-ciskip -f extensions/core/ext-core/pom.xml'
