(* hash *)
dnl  hash(bitstring): bitstring. dnl [data]

(* Symmetric key encryption *)
type nonce.
type key.

fun senc(bitstring, key): bitstring.
reduc forall m: bitstring, k: key; sdec(senc(m,k),k) = m.

(* Asymmetric key encryption *)
type skey. (* secret key/private key *)
type pkey. (* public key *)

fun Pk(skey): pkey.
fun aenc(bitstring, pkey): bitstring.
reduc forall m: bitstring, sk: skey; adec(aenc(m,Pk(sk)),sk) = m.
