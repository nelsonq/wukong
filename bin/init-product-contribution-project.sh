mkdir -p ~/Work/githome/$1
mkdir -p ~/Work/githome/$1/.m2
mkdir -p ~/Work/githome/$1/.m2/repository
ln -s ~/.m2/settings.xml ~/Work/githome/$1/.m2/settings.xml
git clone git@github.elasticpath.net:commerce/ep-commerce.git ~/Work/githome/$1/ep-commerce
git clone git@github.elasticpath.net:cortex/api-platform.git ~/Work/githome/$1/api-platform
