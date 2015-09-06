
Before running the tests will need to have the
test ldap/sasl services deployed.  See 
support-files/ldap-sasl in the
percona-server-mongodb repository.

You will also need to run the jstests/external-auth
suite from the percona-server-mongodb repo which
will leave the database setup with the correct
external auth accounts to run this driver test.

Then run the mongod server like this:

    ${MONGODB_HOME}/mongod --dbpath=${MONGODB_HOME}/data \
      --setParameter authenticationMechanisms=PLAIN,SCRAM-SHA-1 --auth &

Then run the driver test like this

    cmake .
    make
    ./run.sh
