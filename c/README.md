You will need to compile and install Percona Server for MongoDB
with SASL support before running this test.

First checkout the 3.0 or above branch of
percona-server-mongodb then compile and install with:


    mkdir -p $HOME/psmongodb
    scons --use-sasl-client --prefix=$HOME/psmongodb install

Before running the tests will need to have the
test ldap/sasl services deployed.  See 
support-files/ldap-sasl in the
percona-server-mongodb repository.

You will also need to run the jstests/external-auth
suite from the percona-server-mongodb repo which
will leave the database setup with the correct
external auth accounts to run this driver test.

Then run the mongod server like this:

    export MONGODB_HOME=$HOME/psmongodb
    ${MONGODB_HOME}/mongod --dbpath=${MONGODB_HOME}/data \
      --setParameter authenticationMechanisms=PLAIN,SCRAM-SHA-1 --auth &

In order to compile this test you will need a recent version of the
MongoDB C Driver


    apt-get install -y git autoconf libtool
    mkdir -p $HOME/mongoc 
    mkdir -p $HOME/git
    cd $HOME/git
    git clone https://github.com/mongodb/mongo-c-driver.git
    cd mongo-c-driver
    ./autogen
    ./configure --enable-sasl=yes --prefix=$HOME/mongoc
    make install

Then compile & run the driver test like this:

   
    cd $HOME/git
    git clone https://github.com/dbpercona/psfmo-external-auth-driver-tests.git
    cd psfmo-external-auth-driver-tests/c
    cmake .
    make
    ./run.sh

