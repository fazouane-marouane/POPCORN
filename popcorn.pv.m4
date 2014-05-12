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

(* N.b. the yellow pages are not visible to the adversary *)
free yellowpagesEV: channel [private].
free yellowpagesCS: channel [private].
free yellowpagesEP: channel [private].
free yellowpagesMO: channel [private].


include(`HonestActors/_HonestActors.pv.m4')
include(`DishonestActors/_DishonestActors.pv.m4')

(* main process *)
free publicChannel: channel.

let publishSensitiveInfomation()=
	out(publicChannel,GPk(gmsk));
	out(publicChannel,kPH).

ifdef(`SECRECY',
(* queries *)
query attacker(new idEV[]).

process
	new idEV: ID;
	new idCS: ID;
	new idEP: ID;
	new idMO: ID;

	( !out(gpk,GPk(gmsk)) |
		createEV(idEV) | createCS(idCS) | createEP(idEP) | createMO(idMO)| !DR() | !PH() |
		(*EVattacker(publicChannel) |*) dishonestCS(publicChannel) | dishonestEP(publicChannel) | (*dishonestMO(publicChannel) |*)
		publishSensitiveInfomation() (*| out(c,choice[idEV,idEV2])*)
	)
)
ifdef(`ANONYMITY',

)
