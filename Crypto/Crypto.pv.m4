dnl symetric asymetric encryption
(* Identifiers *)
type nonce.
type ID. (* Actor's Identifier *)
fun ID_to_bitstring(ID): bitstring [data, typeConverter].
const dummy: ID [private].
(* sdr *)
type SDR.
type transactID.
fun createTransactionID(ID,nonce): transactID [data].
fun createReceipt(transactID): bitstring [data].
fun createSDR(transactID, bitstring, bitstring): SDR [data].


include(`Crypto/Encryption.pv.m4')dnl
include(`Crypto/Signature.pv.m4')dnl
dnl include(`Crypto/zeroknowledge.pv.m4')dnl
include(`Crypto/Credentials.pv.m4')dnl
include(`Crypto/Authentication.pv.m4')dnl
