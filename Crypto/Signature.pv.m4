(* Digital signatures *)
fun Sign(bitstring, skey): bitstring.
fun CheckSign(bitstring, pkey): bool.

(* Simplified dynamic group signing *)
dnl type gskey. (* secret signing key *)
type gmskey. (* group manager's secret key *)
dnl type gpkey. (* group public key *)

fun GKeygen(gmskey,bitstring): skey [private].
fun GPk(gmskey): pkey.

equation forall k:bitstring, gmsk: gmskey; Pk(GKeygen(gmsk,k)) = GPk(gmsk).
equation forall k: skey, v: bitstring; CheckSign(Sign(v,k), Pk(k)) = true.
equation forall k:bitstring, gmsk: gmskey, v:bitstring; CheckSign(Sign(v,GKeygen(gmsk,k)), GPk(gmsk)) = true. (* this is a necessary rule to have a confluent and convergent reduction system *)
reduc forall k: skey, v: bitstring; RecoverKey(Sign(v,k)) = Pk(k).
reduc forall k: skey, v: bitstring; RecoverData(Sign(v,k)) = v.
reduc forall m:bitstring, k:bitstring, gmsk: gmskey; guncover(Sign(m,GKeygen(gmsk,k)),gmsk) = k.
