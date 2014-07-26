dnl symetric asymetric encryption
(* Identifiers *)
type ID. (* Actor's Identifier *)
fun ID_to_bitstring(ID): bitstring [data, typeConverter].
const dummy: ID [private].
(* sdr *)
type transactID.
fun createReceipt(transactID): bitstring [private].
fun createSDR(transactID, bitstring, bitstring): bitstring [data].


include(`Crypto/Encryption.pv.m4')dnl
include(`Crypto/Signature.pv.m4')dnl
dnl include(`Crypto/zeroknowledge.pv.m4')dnl
include(`Crypto/Credentials.pv.m4')dnl
include(`Crypto/Authentication.pv.m4')dnl
