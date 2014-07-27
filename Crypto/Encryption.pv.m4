(* hash *)
dnl  hash(bitstring): bitstring. dnl [data]

(* Symmetric key encryption *)
type key.

fun senc(bitstring, key): bitstring.
reduc forall m: bitstring, k: key; sdec(senc(m,k),k) = m.

(* Asymmetric key encryption *)
type skey. (* secret key/private key *)
type pkey. (* public key *)

fun Pk(skey): pkey.
fun aenc(bitstring, pkey): bitstring.
reduc forall m: bitstring, sk: skey; adec(aenc(m,Pk(sk)),sk) = m.

fun aenc_rand(bitstring,nonce, pkey): bitstring.
reduc forall m: bitstring, sk: skey, r:nonce; adec_rand(aenc_rand(m,r,Pk(sk)),sk) = m.