# About this app

A starter app to test github.com/godror/godror which is a golang oracle driver. 


## Build in a local Go development environment 
If you have a golang development environment on the build host, run this cmd to build the app executable for Linux platform:

```
make go-build
```

## Build in a containerized Go development environment 

The first part of this build process is to create a docker image containing the GO dev environment using dva-registry.internal.salesforce.com/dva/golang_build as its base image. For docker to successfylly pull the base image, you need to log into the register dva-registry.internal.salesforce.com as follows using your corporate username and password if you have not yet done so:

```
docker login dva-registry.internal.salesforce.com
```

Then, run cmd
```
make docker-build
```
## test env

ssh bastion.syssec.core002.dev1-uswest2.aws.sfdc.cl
ssh ad1-a1.coredb.core002.dev1-uswest2.aws.sfdc.is



 ## staticslly linking C to go
http://dominik.honnef.co/posts/2015/06/statically_compiled_go_programs__always__even_with_cgo__using_musl/
 go build --ldflags '-extldflags "-static"' file.go
 
 ## install glibc 2.14
 https://stackoverflow.com/questions/32316707/rhel-6-how-to-install-glibc-2-14-or-glibc-2-15


```
wget https://ftp.gnu.org/gnu/libc/glibc-2.14.tar.gz
tar xvfz glibc-2.14.tar.gz
cd glibc-2.14
ls
mkdir build
cd build
../configure --prefix=/opt/glibc-2.14
make
sudo make install
export LD_LIBRARY_PATH=/opt/glibc-2.14/lib:$LD_LIBRARY_PATH

```

##


  498  sudo chown -R `whoami` /usr/local/lib
  499  mkdir  /usr/local/lib/pkgconfig/
  500  vim /usr/local/lib/pkgconfig/oci8.pc
  501  env|grep ORA
  502  ls /opt/oracle/instantclient_12_2

vi /usr/local/lib/pkgconfig/oci8.pc
#content of oci8.pc
prefix=/opt/oracle/instantclient_12_2
libdir=${prefix}
includedir=${prefix}/sdk/include/
build=client64

Name: OCI
Description: Oracle database engine
Version: 12.2
Libs: -L${libdir} -lclntsh
Libs.private: 
Cflags: -I${includedir}

#end of oci8.pc

cat >>~/.bashrc <<EOF
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
EOF

. ~/.bashrc


## datasource

ad_tcps =(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCPS)(HOST = localhost)(PORT = 2484)))(CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = AD1A1)))

DATASOURCE=/@"(DESCRIPTION =(ADDRESS_LIST =(ADDRESS = (PROTOCOL = TCPS)(HOST = localhost)(PORT = 2484)))(CONNECT_DATA = (SERVER = DEDICATED)(SERVICE_NAME = AD1A1)))"

## build env setup
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"



# User specific aliases and functions
export ORACLE_SID=AD1A1
export ORACLE_HOME=/oracle/rdbms/11.2.0.4
export TNS_ADMIN=~/mtls_client/
export LD_LIBRARY_PATH=/oracle/rdbms/11.2.0.4/lib:/opt/glibc-2.14/lib:opt/oracle/instantclient_12_2



## check mTLS client files (TNS_ADMIN)

cwallet.sso  
ewallet.p12
sqlnet.ora

## sqlnet.ora

WALLET_LOCATION =
  (SOURCE =
    (METHOD = FILE)
    (METHOD_DATA =
      (DIRECTORY = /home/jusong.chen/mtls_client/)
    )
  )
SQLNET.AUTHENTICATION_SERVICES=(TCPS,NTS)
SSL_CLIENT_AUTHENTICATION = TRUE


