#
# This script was written and tested on TI_7.0.1.0 in 12/16
#

TI_DIR=$PWD
cd ..
STREAM_NAME="${PWD##*/}"
cd TI

# Override any files that cause builds to fail on this stream
# This step is temporary for a peculiar issue on TI_7.0.1.0 @12/16
cp -r /Volumes/ProductDevelopment/TechInf/7_0_1_0/Hijacks_required_for_first_build/ ../

# create setenv.sh
echo "export DEVENV_HOME=~/RTC-Dev/DevEnv/${STREAM_NAME}">> setenv.sh
echo "export J2EE_JAR=${PWD}/lib/nonrelease/was_j2ee6.jar">> setenv.sh

# create Bootstrap.properties
cd coreinf/properties/
echo "curam.environment.bindings.location=${PWD}">> Bootstrap.properties
echo "curam.environment.tnameserv.port=1221">> Bootstrap.properties
echo "# H2">> Bootstrap.properties
echo "curam.db.type=H2">> Bootstrap.properties
echo "curam.db.name=${STREAM_NAME}">> Bootstrap.properties
echo "curam.db.username=h2admin">> Bootstrap.properties
echo "# The encrypted password is "password"">> Bootstrap.properties
echo "curam.db.password=HlIxprF/66CsSSm6PON5+A==">> Bootstrap.properties
echo "curam.db.h2.directory=~/RTC-Dev/H2">> Bootstrap.properties
echo "curam.db.h2.mode=embedded">> Bootstrap.properties
echo "curam.db.serverport=9092">> Bootstrap.properties
echo "curam.db.servername=localhost">> Bootstrap.properties
echo "# Needed for Eclipse/RWD only">> Bootstrap.properties
echo "curam.testing.datasets=~/RTC-Dev/${STREAM_NAME}/TI/TestDatasets">> Bootstrap.properties
echo "dbtojms.credentials.encr.text=b8nbWgbJtUFIZ25vODA4Vw==">> Bootstrap.properties
echo " ">> Bootstrap.properties

# create AppServer.properties
echo "# Acceptable values are IBM or BEA.">> AppServer.properties
echo "as.vendor=IBM">> AppServer.properties
echo "# The username and password for admin server.">> AppServer.properties
echo "security.username=websphere">> AppServer.properties
echo "# encrypted password 'websphere'">> AppServer.properties
echo "security.password=RZq542wPRdtvDXdmXiln9A==">> AppServer.properties
echo "curam.security.credentials.jms.messagedrivenbean.username=SYSTEM">> AppServer.properties
echo "curam.security.credentials.jms.messagedrivenbean.password=hIAidlp83Q8=">> AppServer.properties
echo "node.name=localNode">> AppServer.properties
echo "curam.server.name=CuramServer">> AppServer.properties
echo "# The default port for WAS is 2809, for WLS is 7001, for NAS is 50504">> AppServer.properties
echo "curam.server.port=2809">> AppServer.properties
echo "curam.db.auth.alias=databaseAlias">> AppServer.properties
echo "curam.server.ipaddress=localhost">> AppServer.properties
echo "curam.webservices.httpport=9082">> AppServer.properties
echo "curam.client.httpport=$HTTPS_PORT">> AppServer.properties
echo " ">> AppServer.properties

cd ../..

# privileges for setenv
chmod 777 setenv.sh

# run the generated setenv within this shell (the '. ' means the props persist)
. ./setenv.sh

# privileges for appbuild
chmod 777 appbuild

# pull down devenv
./appbuild dummy

# privileges for java
cd $DEVENV_HOME/tools/java/
find . -type f -exec chmod 755 {} \;
cd $TI_DIR

# build TI targets
./appbuild server client tabtestapp tabtestdatabase cryptoconfig

# launch Eclipse
cd devenv
chmod 777 eclipse
./eclipse
cd ..

# run cryptoconfig again if the Apple Java used by Curam.epf is 
# used in eclipse and it hasn't yet got a CryptoConfig.jar
APPLE_JAVA="`/usr/libexec/java_home`"
APPLE_JAVA_EXT="$APPLE_JAVA"/jre/lib/ext
echo APPLE_JAVA=$APPLE_JAVA
echo APPLE_JAVA_EXT=$APPLE_JAVA_EXT
if [ -f "$APPLE_JAVA_EXT/CryptoConfig.jar" ]
then
	echo "CryptoConfig.jar found in eclipse JRE."
else
	echo "CryptoConfig.jar not found in the eclipse JRE. Please enter your password in the following prompt to allow the jar to be copied to that JRE."
	sudo chmod +a "user:$USER allow add_file" $APPLE_JAVA_EXT
	BAK_JAVA_HOME=$JAVA_HOME
	export JAVA_HOME=$APPLE_JAVA
	./appbuild cryptoconfig
	export JAVA_HOME=$BAK_JAVA_HOME
	unset BAK_JAVA_HOME
fi
unset APPLE_JAVA_EXT
unset APPLE_JAVA
