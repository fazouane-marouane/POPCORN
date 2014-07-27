(* Digital signatures *)
fun Sign(bitstring, skey): bitstring.
fun CheckSign(bitstring, pkey): bool.

(* Simplified dynamic group signing *)
dnl type gskey. (* secret signing key *)
type gmskey. (* group manager's secret key *)
dnl type gpkey. (* group public key *)

fun GKeygen(gmskey,ID): skey [private].
fun GPk(gmskey): pkey.

dnl equation forall k:bitstring, gmsk: gmskey; Pk(GKeygen(gmsk,k)) = GPk(gmsk).
equation forall k: skey, v: bitstring; CheckSign(Sign(v,k), Pk(k)) = true.
equation forall k:ID, gmsk: gmskey, v:bitstring; CheckSign(Sign(v,GKeygen(gmsk,k)), GPk(gmsk)) = true. (* this is a necessary rule to have a confluent and convergent reduction system *)
reduc forall k: skey, v: bitstring; RecoverKey(Sign(v,k)) = Pk(k).

reduc forall k: skey, v: bitstring; RecoverData(Sign(v,k)) = v.
reduc forall m:bitstring, k:ID, gmsk: gmskey; guncover(Sign(m,GKeygen(gmsk,k)),gmsk) = k.
dnl reduc forall k: skey; Sk(Pk(k))=k [private].

(* Blind signatures *)
dnl fun blind(bitstring, key): bitstring.
dnl fun unblind(bitstring, key): bitstring.
dnl equation forall x: bitstring, y: skey, z:key; unblind(Sign(blind(x,z),y),z) = Sign(x,y).