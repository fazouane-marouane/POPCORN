(* POPCORN *)
(* Debug Options *)
set ignoreTypes = false.
set simplifyProcess = true.
set displayDerivation = false .
set traceDisplay = short.
set movenew = true.

event exit.
event exit_PH.
event exit_MO1.
event exit_MO2.
event exit_MO3.

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
free yellowpagesPH: channel [private].

include(`HonestActors/_HonestActors.pv.m4')
include(`DishonestActors/_DishonestActors.pv.m4')

(* main process *)
free publicChannel: channel.

let publishSensitiveInfomation()=
	(out(publicChannel,GPk(gmsk)))|
	!(in(yellowpagesMO,x:bitstring);
	out(publicChannel,x)) |
	!(in(yellowpagesEP,x:bitstring);
	out(publicChannel,x)) |
	!(in(yellowpagesCS,x:bitstring);
	out(publicChannel,x)) |
	!(in(yellowpagesPH,x:bitstring);
	out(publicChannel,x)).

let createHonestActors()=
	new idCS: ID;
	new idEP: ID;
	new idMO: ID;
	new skPH: skey;

	(!out(gpk,GPk(gmsk)) | !DR() | !out(yellowpagesPH,Pk(skPH)) | !PH(skPH) |
	createCS(idCS) | createEP(idEP) | createMO(idMO)).


ifdef(`CORRESPONDANCE',
`define(`CORRESPONDANCE_SECRECY')'
free idEV: ID [private].
(* TODO: queries on events to prove correspondance and injective correspondance properties *)
dnl query event().
query event(exit).
)
ifdef(`SECRECY',
`define(`CORRESPONDANCE_SECRECY')'
(* queries *)
free idEV: ID [private].
query attacker(idEV).
)
ifdef(`CORRESPONDANCE_SECRECY',

process
	(
		createEV(idEV) | !(new idEV:ID; createEV(idEV) ) | createHonestActors() | publishSensitiveInfomation() |
		(*dishonestEV(publicChannel) |*) dishonestCS(publicChannel) | dishonestEP(publicChannel) (*| dishonestMO(publicChannel)*)
	)
)
ifdef(`ANONYMITY',
dnl Question: is SECRECY <-> ANONYMITY ??

equivalence
	(
		new privateChannel: channel;
		(new idEV0:ID;out(privateChannel,idEV0)) |(new idEV:ID; in(privateChannel,idEV0:ID); createEV(idEV0) ) | !(new idEV:ID; createEV_singleinstance(idEV) ) | createHonestActors() | publishSensitiveInfomation() |
		(*dishonestEV(publicChannel) |*) dishonestCS(publicChannel) | dishonestEP(publicChannel) (*| dishonestMO(publicChannel)*)
	)
	(
		new privateChannel: channel;
		(new idEV0:ID;out(privateChannel,idEV0)) |(new idEV:ID; in(privateChannel,idEV0:ID); createEV(idEV) ) | !(new idEV:ID; createEV_singleinstance(idEV) ) | createHonestActors() | publishSensitiveInfomation() |
		(*dishonestEV(publicChannel) |*) dishonestCS(publicChannel) | dishonestEP(publicChannel) (*| dishonestMO(publicChannel)*)
	)
)
ifdef(`STRONG_SECRECY',

free idEV: ID [private].
noninterf idEV.

process
	(
		createEV(idEV) | !(new idEV:ID; createEV(idEV) ) | createHonestActors() | publishSensitiveInfomation() |
		(*dishonestEV(publicChannel) |*) dishonestCS(publicChannel) | dishonestEP(publicChannel) (*| dishonestMO(publicChannel)*)
	)
)
ifdef(`OFFLINE_GUESSING',

free idEV: ID [private].
weaksecret idEV.

process
	(
		createEV(idEV) | !(new idEV:ID; createEV(idEV) ) | createHonestActors() | publishSensitiveInfomation() |
		(*dishonestEV(publicChannel) |*) dishonestCS(publicChannel) | dishonestEP(publicChannel) (*| dishonestMO(publicChannel)*)
	)

)
ifdef(`UNLINKABILITY',

equivalence
	(
		!(new idEV:ID; createEV(idEV) ) | createHonestActors() | publishSensitiveInfomation() |
		(*dishonestEV(publicChannel) |*) dishonestCS(publicChannel) | dishonestEP(publicChannel) | dishonestMO(publicChannel)
	)
	(
		!(new idEV:ID; createEV_singleinstance(idEV) ) | createHonestActors() | publishSensitiveInfomation() |
		(*dishonestEV(publicChannel) |*) dishonestCS(publicChannel) | dishonestEP(publicChannel) | dishonestMO(publicChannel)
	)
)
