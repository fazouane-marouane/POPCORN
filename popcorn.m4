(* POPCORN *)
(* Debug Options *)
set traceDisplay = long.

(* Identifiers *)
type ID. (* Actor's Identifier *)
fun ID_to_bitstring(ID): bitstring [data, typeConverter].

(* Cryptographic primitives *)
include(`Crypto/Crypto.m4')




(* sdr *)
type transactID.
fun createReceipt(transactID): bitstring [private].
fun createSDR(transactID, bitstring, bitstring): bitstring.
reduc forall idEP: bitstring, payment: bitstring, trid: transactID; getTransactID(createSDR(trid,idEP,payment))=trid.
reduc forall idEP: bitstring, payment: bitstring, trid: transactID; getEncryptedEP(createSDR(trid,idEP,payment))=idEP.
reduc forall idEP: bitstring, payment: bitstring, trid: transactID; getPayment(createSDR(trid,idEP,payment))=payment.


(* ID: the identifier; channel: contact address; pkey: private key *)
(* N.b. tables are not visible to the adversary *)
free CSchannel: channel [private].
free EPchannel: channel [private].
free MOchannel: channel [private].


include(`HonestActors/HonestActors.m4')
include(`DishonestActors/DishonestActors.m4')

(* main process *)
free publicChannel: channel.

let publishSensitiveInfomation()=
	out(publicChannel,gpk(gmsk));
	out(publicChannel,kPH).

(* queries *)
query attacker(idEV).

process
	new idEV2: ID;
	insert gpkeyTable(gpk(gmsk));
	(
		createEV(idEV) | createCS(idCS) | createEP(idEP) | createMO(idMO)| !DR() | !PH() |
		(*EVattacker() |*) CSattacker() | EPattacker() | (*MOattacker() |*)
		sendSensitiveInfos() (*| out(c,choice[idEV,idEV2])*)
	)
ifdef(`EVCACHE',`

') dnl