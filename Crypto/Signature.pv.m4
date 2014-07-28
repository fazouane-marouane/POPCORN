(* Digital signatures *)
fun Sign(bitstring, skey): bitstring.
fun CheckSign(bitstring, pkey): bool.

(* Simplified dynamic group signing *)
type gmskey. (* group manager's secret key *)

fun GKeygen(gmskey,ID): skey [private].
fun GPk(gmskey): pkey.

equation forall k: skey, v: bitstring; CheckSign(Sign(v,k), Pk(k)) = true.
equation forall k:ID, gmsk: gmskey, v:bitstring; CheckSign(Sign(v,GKeygen(gmsk,k)), GPk(gmsk)) = true. (* this is a necessary rule to have a confluent and convergent reduction system *)
reduc forall k: skey, v: bitstring; RecoverKey(Sign(v,k)) = Pk(k).

reduc forall k: skey, v: bitstring; RecoverData(Sign(v,k)) = v.
reduc forall m:bitstring, k:ID, gmsk: gmskey; guncover(Sign(m,GKeygen(gmsk,k)),gmsk) = k.
reduc forall gmsk: gmskey, id:ID; secretkey_is_personal(GKeygen(gmsk,id))=id.
