# Overview

This directory holds sample files for the S/MIME unit tests. The relevant S/MIME test scripts are:
- scripts/test/SMIME.t

# Sample files

The sample files are based on the novel "Voyage au Centre de la Terre" by Jules Verne. The main protagonist is "Professor Otto Lidenbrock"
who teaches geology at the Johanneum in Hamburg. In our case the Johanneum offers the root CA, the science department of the school
and the cabinet of Prof. Lidenbrock are subsidary CAs. Other protaganists are Axel, Gudrun, and Martha. Axel is the one who
deciphers the secret message from Arne Saknussemm,

The certificates were created with openssl. All of the passphrases are 'secret'.
Below are the commands which created the sample files.

## Root Certificate Authority SMIMECACertificate-Johanneum

This is the self signed root CA, the thingy that has to be imported into the mail tool.

We create the certificate and the private key in a single step. The password for the private key is 'secret'.
We use 3653 days for 10 years, including the 3 leap days. By specifying -keyout we request that a private key
is generated. CA=TRUE is set automatically.

    > cd /opt/otobo/scripts/test/sample/SMIME
    > openssl req -x509 -sha512  -days 3650 -out SMIMECACertificate-Johanneum.crt -keyout SMIMECAPrivateKey-Johanneum.pem

The fingerprint is included in scripts/test/SMIME.t:

    openssl x509  -noout -fingerprint -in SMIMECACertificate-Johanneum.crt
    openssl x509  -noout -subject_hash -in SMIMECACertificate-Johanneum.crt

## Intermediate CA, the geology department of the Johanneum

First the department needs a private key.

    > openssl genrsa -out SMIMECAPrivateKey-Geology.pem

Ask the Johanneum to create a signed certificate for the geology department:

    > openssl req -new -key SMIMECAPrivateKey-Geology.pem -out SMIMECASignRequest-Geology.csr

The Johanneum kindly signs the certificate sign request and the geology department gets its signed CA certificate.
Explicitly adding the X.509 v3 extensions in a strange way.

    > echo "basicConstraints = critical, CA:true, pathlen:1" > extfile
    > openssl x509 -req -days 3653 -extfile extfile -in SMIMECASignRequest-Geology.csr -CA SMIMECACertificate-Johanneum.crt -CAkey SMIMECAPrivateKey-Johanneum.pem -set_serial 00 -out SMIMECACertificate-Geology.crt

Check with:

    > openssl x509  -noout -text -in SMIMECACertificate-Geology.crt

Again, we need the fingerprint for the test script:

    > openssl x509  -noout -fingerprint -in SMIMECACertificate-Geology.crt
    > openssl x509  -noout -subject_hash -in SMIMECACertificate-Geology.crt

## The final CA in the chain, that is the cabinet of Prof. Lidenbrock, is signed by the geology department

First the cabinet needs a private key.

    > openssl genrsa -out SMIMECAPrivateKey-Cabinet.pem

Ask the Geology department to create a signed certificate for the cabinate of Prof. Lidenbrock.

    > openssl req -new -key SMIMECAPrivateKey-Cabinet.pem -out SMIMECASignRequest-Cabinet.csr

The geology department kindly signs the certificate sign request and Prof. Lidenbrock gets his signed CA certificate.
Explicitly adding the X.509 v3 extensions in a strange way.

    > echo "basicConstraints = critical, CA:true, pathlen:0" > extfile
    > openssl x509 -req -days 3653 -extfile extfile -in SMIMECASignRequest-Cabinet.csr  -CA SMIMECACertificate-Geology.crt -CAkey SMIMECAPrivateKey-Geology.pem -set_serial 00 -out SMIMECACertificate-Cabinet.crt

As usual, we need the subject hash and the fingerprint for the test script:

    > openssl x509  -noout -text -in SMIMECACertificate-Cabinet.crt
    > openssl x509  -noout -fingerprint -in SMIMECACertificate-Cabinet.crt
    > openssl x509  -noout -subject_hash -in SMIMECACertificate-Cabinet.crt

## User certificates are signed by the Cabinet CA

For now we only have Axel who receives crypted messages. In future other users might Otto, Martha, and Gudrun.

    > openssl genrsa -out SMIMEUserPrivateKey-Axel.pem
    > openssl req -new -key SMIMEUserPrivateKey-Axel.pem -out SMIMEUserSignRequest-Axel.csr
    > openssl x509 -req -days 3653 -in SMIMEUserSignRequest-Axel.csr  -CA SMIMECACertificate-Cabinet.crt -CAkey SMIMECAPrivateKey-Cabinet.pem -set_serial 00 -out SMIMEUserCertificate-Axel.crt
    > openssl x509  -noout -text -in SMIMEUserCertificate-Axel.crt
    > openssl x509  -noout -fingerprint -in SMIMEUserCertificate-Axel.crt
    > openssl x509  -noout -subject_hash -in SMIMEUserCertificate-Axel.crt

# See also:

- https://en.wikipedia.org/wiki/Journey_to_the_Center_of_the_Earth
- https://linuxconfig.org/how-to-generate-a-self-signed-ssl-certificate-on-linux for a tutorial.
- https://www.howtoforge.de/anleitung/mails-mit-ssl-zertifikaten-verschlusseln-smime/
- https://stackoverflow.com/questions/36920558/is-there-anyway-to-specify-basicconstraints-for-openssl-cert-via-command-line
