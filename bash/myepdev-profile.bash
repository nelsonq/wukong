#!/bin/sh
export MAVEN_INST_ROOT=${MAVEN_INST_ROOT:=~/apphome}
# platform for docker linux/x86_64 or linux/arm64/v8. should be overridden in .bash_profile
export ENV_DOCKER_PLATFORM=linux/x86_64

# M2_HOME configuration
# [check point] In case of maven got upgrade.
export M2_HOME_391=$MAVEN_INST_ROOT/apache-maven-3.9.1
export M2_HOME_390=$MAVEN_INST_ROOT/apache-maven-3.9.0
export M2_HOME_362=$MAVEN_INST_ROOT/apache-maven-3.6.2
export M2_HOME_354=$MAVEN_INST_ROOT/apache-maven-3.5.4
export M2_HOME_352=$MAVEN_INST_ROOT/apache-maven-3.5.2
export M2_HOME_339=$MAVEN_INST_ROOT/apache-maven-3.3.9
export M2_HOME_305=$MAVEN_INST_ROOT/apache-maven-3.0.5

# Latest maven home
export M2_HOME_3x=$M2_HOME_391

# MAVEN_OPTS configuration
# [check point] In case of maven option got upgrade.
export MAVEN_OPTS_305='-Xmx1024m -XX:MaxPermSize=512m -XX:ReservedCodeCacheSize=128m -Dsun.lang.ClassLoader.allowArraySyntax=true -ea'
export MAVEN_OPTS_339='-Xmx2048m -XX:ReservedCodeCacheSize=128m -Dsun.lang.ClassLoader.allowArraySyntax=true '
export MAVEN_OPTS_339_MULTITHREADED='-Xmx4000m -XX:ReservedCodeCacheSize=128m -Dsun.lang.ClassLoader.allowArraySyntax=true '
export MAVEN_OPTS_352=$MAVEN_OPTS_339_MULTITHREADED
export MAVEN_OPTS_354=$MAVEN_OPTS_352
export MAVEN_OPTS_362=$MAVEN_OPTS_354
export MAVEN_OPTS_390=$MAVEN_OPTS_362
export MAVEN_OPTS_391=$MAVEN_OPTS_362

# Latest maven options
export MAVEN_OPTS_3x=$MAVEN_OPTS_391

# JAVA_HOME configuration
# [check point] In case of jdk got upgrade.
os="$(uname -s)"
if [ "$os" = "Darwin" ];then
export JAVA_HOME_8U66=/Library/Java/JavaVirtualMachines/jdk1.8.0_66.jdk/Contents/Home
export JAVA_HOME_8U161=/Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home
export JAVA_HOME_8U144=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home
# NOTE: Zulu JDK now.
export JAVA_HOME_8U275=~/Work/apphome/jdk8u275
export JAVA_HOME_11=~/Work/apphome/jdk11

#zulu overwrites the jdk.
#export JAVA_HOME_8U212=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home
export JAVA_HOME_7U51=/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home
export JAVA_HOME_7U79=/Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home
export JAVA_HOME_7U80=/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home
else
export JAVA_HOME_8U66=~/Work/apphome/jdk1.8.0_66
export JAVA_HOME_8U161=~/Work/apphome/jdk1.8.0_161
export JAVA_HOME_8U144=~/Work/apphome/jdk1.8.0_144
export JAVA_HOME_7U51=~/Work/apphome/jdk1.7.0_51
export JAVA_HOME_7U79=~/Work/apphome/jdk1.7.0_79
export JAVA_HOME_7U80=~/Work/apphome/jdk1.7.0_80

fi

# UPDATE default JAVA_HOME per java major release.
export JAVA_HOME_7x=$JAVA_HOME_7U79
export JAVA_HOME_8x=$JAVA_HOME_8U275
export JAVA_HOME_11x=$JAVA_HOME_11

# JAVA_OPTS configuration
# ===============================
export JAVA_OPTS_11x='-Xmx1024m -Dsun.lang.ClassLoader.allowArraySyntax=true'
export JAVA_OPTS_8x='-Xmx1024m -Dsun.lang.ClassLoader.allowArraySyntax=true'
export JAVA_OPTS_7x='-Xmx1024m -XX:MaxPermSize=512m -Dsun.lang.ClassLoader.allowArraySyntax=true'
# ==============================

# EP release mapping of each configuration
# [check point] In case of ep commerce got new release.
# suppose ep 614 should use 7u51, but mac os doesn't allow to install unless some hacking. use 7u79 instead.
export JAVA_HOME_EP614=$JAVA_HOME_7U79;export M2_HOME_EP614=$M2_HOME_305;export JAVA_OPTS_EP614=$JAVA_OPTS_7x;export MAVEN_OPTS_EP614=$MAVEN_OPTS_305
export JAVA_HOME_EP6152=$JAVA_HOME_8U66;export M2_HOME_EP6152=$M2_HOME_305;export JAVA_OPTS_EP6152=$JAVA_OPTS_8x;export MAVEN_OPTS_EP6152=$MAVEN_OPTS_305
export JAVA_HOME_EP616=$JAVA_HOME_8U66;export M2_HOME_EP616=$M2_HOME_339;export JAVA_OPTS_EP616=$JAVA_OPTS_8x;export MAVEN_OPTS_EP616=$MAVEN_OPTS_339
export JAVA_HOME_EP617=$JAVA_HOME_8U66;export M2_HOME_EP617=$M2_HOME_339;export JAVA_OPTS_EP617=$JAVA_OPTS_8x;export MAVEN_OPTS_EP617=$MAVEN_OPTS_339
export JAVA_HOME_EP701=$JAVA_HOME_8U66;export M2_HOME_EP701=$M2_HOME_339;export JAVA_OPTS_EP701=$JAVA_OPTS_8x;export MAVEN_OPTS_EP701=$MAVEN_OPTS_339
export JAVA_HOME_EP71=$JAVA_HOME_8U144;export M2_HOME_EP71=$M2_HOME_339;export JAVA_OPTS_EP71=$JAVA_OPTS_8x;export MAVEN_OPTS_EP71=$MAVEN_OPTS_339
export JAVA_HOME_EP72=$JAVA_HOME_8U144;export M2_HOME_EP72=$M2_HOME_339;export JAVA_OPTS_EP72=$JAVA_OPTS_8x;export MAVEN_OPTS_EP72=$MAVEN_OPTS_339
export JAVA_HOME_EP73=$JAVA_HOME_8U144;export M2_HOME_EP73=$M2_HOME_352;export JAVA_OPTS_EP73=$JAVA_OPTS_8x;export MAVEN_OPTS_EP73=$MAVEN_OPTS_352
export JAVA_HOME_EP74=$JAVA_HOME_8U144;export M2_HOME_EP74=$M2_HOME_352;export JAVA_OPTS_EP74=$JAVA_OPTS_8x;export MAVEN_OPTS_EP74=$MAVEN_OPTS_352
export JAVA_HOME_EP75=$JAVA_HOME_8U212;export M2_HOME_EP75=$M2_HOME_352;export JAVA_OPTS_EP75=$JAVA_OPTS_8x;export MAVEN_OPTS_EP75=$MAVEN_OPTS_352
export JAVA_HOME_EP76=$JAVA_HOME_8U212;export M2_HOME_EP76=$M2_HOME_362;export JAVA_OPTS_EP76=$JAVA_OPTS_8x;export MAVEN_OPTS_EP76=$MAVEN_OPTS_362
export JAVA_HOME_EP8=$JAVA_HOME_8U212;export M2_HOME_EP8=$M2_HOME_362;export JAVA_OPTS_EP8=$JAVA_OPTS_8x;export MAVEN_OPTS_EP8=$MAVEN_OPTS_362
export JAVA_HOME_EP82=$JAVA_HOME_8U275;export M2_HOME_EP82=$M2_HOME_362;export JAVA_OPTS_EP82=$JAVA_OPTS_8x;export MAVEN_OPTS_EP82=$MAVEN_OPTS_362
export JAVA_HOME_EP85=$JAVA_HOME_11;export M2_HOME_EP85=$M2_HOME_391;export JAVA_OPTS_EP85=$JAVA_OPTS_11x;export MAVEN_OPTS_EP85=$MAVEN_OPTS_391

# [check point] In case of ep commerce got new release.
export JAVA_HOME_EP7x=$JAVA_HOME_7x;export M2_HOME_EP7x=$M2_HOME_3x;export JAVA_OPTS_EP7x=$JAVA_OPTS_7x;export MAVEN_OPTS_EP7x=$MAVEN_OPTS_3x
export JAVA_HOME_EP8x=$JAVA_HOME_8x;export M2_HOME_EP8x=$M2_HOME_3x;export JAVA_OPTS_EP8x=$JAVA_OPTS_8x;export MAVEN_OPTS_EP8x=$MAVEN_OPTS_3x

# export default configuration
# export JAVA_HOME=$JAVA_HOME_EP8x removing to allow jenv work
export M2_HOME=$M2_HOME_EP8x
export JAVA_OPTS=$JAVA_OPTS_EP8x
export MAVEN_OPTS=$MAVEN_OPTS_EP8x

# don't think this one is necessary. somehow it is here.
#export JAVA_TOOL_OPTIONS="-Xmx4096m -Xms512m -Dfile.encoding=UTF-8"

export PATH=~/bin:$M2_HOME/bin:$PATH:
