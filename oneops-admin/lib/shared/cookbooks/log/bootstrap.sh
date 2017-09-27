#!/bin/bash

if [[ -z "${CONFIGURED}" ]]; then
    echo "installing base yum packages"
    yum -d0 -e0 -y install sudo file make gcc gcc-c++ glibc-devel libgcc ruby ruby-libs ruby-devel libxml2-devel libxslt-devel ruby-rdoc rubygems perl perl-Digest-MD5 nagios nagios-devel nagios-plugins
    echo "downloading base gems"
    sudo /opt/chef/embedded/bin/gem env gemdir
    sudo /opt/chef/embedded/bin/gem install aws-s3 -v 0.6.3 --conservative
    sudo /opt/chef/embedded/bin/gem install parallel -v 1.9.0 --conservative
    sudo /opt/chef/embedded/bin/gem install i18n -v 0.6.9 --conservative
    sudo /opt/chef/embedded/bin/gem install activesupport -v 3.2.11 --conservative
    echo "Done"
    sudo echo "export CONFIGURED=\"TRUE\"" >> /etc/environment


else
    echo "already configured"
fi
    # create cert
    # Specify where we will install
    # the xip.io certificate
    SSL_DIR="/testcerts"

    # Set the wildcarded domain
    # we want to use
    DOMAIN="*.example.io"

    # A blank passphrase
    PASSPHRASE=""

    # Set our CSR variables
    SUBJ="/C=US/ST=Arkansas/O=stuff/localityName=example/commonName=$DOMAIN/organizationalUnitName=Walmart/emailAddress=example@site.com"

    # Create our SSL directory
    # in case it doesn't exist
    sudo mkdir -p "$SSL_DIR"
    sudo chmod 777 /testcerts
    # Generate our Private Key, CSR and Certificate
    sudo openssl genrsa -out "$SSL_DIR/testcert.key" 2048
    sudo openssl req -new -subj "$(echo -n "$SUBJ")" -key "$SSL_DIR/testcert.key" -out "$SSL_DIR/testcert.csr" -passin pass:$PASSPHRASE
    sudo openssl x509 -req -days 365 -in "$SSL_DIR/testcert.csr" -signkey "$SSL_DIR/testcert.key" -out "$SSL_DIR/testcert.crt"