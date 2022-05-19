This directory holds sample files for the SMIME unit tests.

The self signed certificates were created with openssl.
See https://linuxconfig.org/how-to-generate-a-self-signed-ssl-certificate-on-linux for a tutorial.

# 3653 days is 10 years, including the 3 leap days
openssl req -x509  -sha512  -days 3650 -out SMIMECACertificate-OTOBOLab1.crt -keyout SMIMECAPrivateKey-OTOBOLab1.pem
openssl x509  -noout -fingerprint -in SMIMECACertificate-OTOBOLab1.crt

bes:~/devel/OTOBO/otobo/scripts/test/sample/SMIME (rel-10_1)$ openssl x509  -noout -subject_hash -issuer -fingerprint -sha1 -serial -subject -startdate -enddate -email -modulus -in SMIMECACertificate-OTOBOLab1.crt
5310b779
issuer=C = DE, ST = Niederbayern, L = Oberwalting, O = OTOBO, CN = otobo.org, emailAddress = unittests@otobo.org
SHA1 Fingerprint=E1:6F:D0:9A:04:DD:EB:02:E6:C1:CC:08:46:0B:71:15:02:78:30:2E
serial=6E7696412B3C67DD3A4580ACE5F6986D629AC2AC
subject=C = DE, ST = Niederbayern, L = Oberwalting, O = OTOBO, CN = otobo.org, emailAddress = unittests@otobo.org
notBefore=May 19 14:09:33 2022 GMT
notAfter=May 16 14:09:33 2032 GMT
unittests@otobo.org
Modulus=D3EDBA9E6BA0D057B818C6A5652686009CB48AC795E1260C979DF5B306E74E0525B2B8A277FC13D7935862B63DCDAF9813107C48CA5D5665BE87C8536654F7B459FBB1B2BCCBE45BE90AEA47D135D5D0E648DD584FAD816E9FABDCF51A25106CE6C5BC7604B9DE929612F56DA2F8F9E13DB3665F751FE731CE7DDA9F861C6AA7BC0B722DB766041DDEC0641855ACBD7BA4C4B5058D4801766C3A8C631D9B151B015A28110FC518D4A2019FFCDC528FDAFF6B2087EB80AC1779751ECEAD53C8EA2321B0273CDD3CB3C190DCE3E36A02DDD83823FBE6039CC625E0A810E98F237FB25CFD1494DD38082B160829264A68385E62C7D4D44E60A9D93B3D75355DB1AF
