(* POPCORN *)
(* Debug Options *)
set traceDisplay = long.

(* Identifiers *)
type ID. (* Actor's Identifier *)
fun ID_to_bitstring(ID): bitstring [data, typeConverter].

(* Cryptographic primitives *)
include(`Crypto/Crypto.pv.m4')
(* sdr *)
type transactID.
fun createReceipt(transactID): bitstring [private].
fun createSDR(transactID, bitstring, bitstring): bitstring [data].
(*
reduc forall idEP: bitstring, payment: bitstring, trid: transactID; getTransactID(createSDR(trid,idEP,payment))=trid.
reduc forall idEP: bitstring, payment: bitstring, trid: transactID; getEncryptedEP(createSDR(trid,idEP,payment))=idEP.
reduc forall idEP: bitstring, payment: bitstring, trid: transactID; getPayment(createSDR(trid,idEP,payment))=payment.
*)

(* N.b. the yellow pages are not visible to the adversary *)
free yellowpagesEV: channel [private].
free yellowpagesCS: channel [private].
free yellowpagesEP: channel [private].
free yellowpagesMO: channel [private].


include(`HonestActors/_HonestActors.pv.m4')
dnl include(`DishonestActors/_DishonestActors.pv.m4')

(* main process *)
free publicChannel: channel.

let publishSensitiveInfomation()=
	out(publicChannel,GPk(gmsk));
	out(publicChannel,kPH).

(* queries *)
query attacker(idEV).

process
	new idEV: ID;
	new idCS: ID;
	new idEP: ID;
	new idMO: ID;

	( !out(gpk,GPk(gmsk)) |
		createEV(idEV) | createCS(idCS) | createEP(idEP) | createMO(idMO)| !DR() | !PH() |
		(*EVattacker() | CSattacker() | EPattacker() | (*MOattacker() |*)
		publishSensitiveInfomation() (*| out(c,choice[idEV,idEV2])*)
	)
ifdef(`EVCACHE',`
')