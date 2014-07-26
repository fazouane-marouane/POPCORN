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
free yellowpagesDR: channel [private].

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
	new skDR: skey;

	(!out(gpk,GPk(gmsk)) |
	 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
	 !PH(skPH) | !out(yellowpagesPH,Pk(skPH)) |
	 createCS(idCS) | createEP(idEP) ).


ifdef(`CORRESPONDANCE',
free idEV: ID [private].
(* TODO: queries on events to prove correspondance and injective correspondance properties *)
dnl query event().
query event(exit).

process
	(
		createEV(idEV) |
		| (new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestEV(publicChannel) | !dishonestCS(publicChannel) | !dishonestEP(publicChannel) | !dishonestMO(publicChannel)
	)
)
ifdef(`SECRECY1',

(* queries *)
free idEV: ID [private].
query attacker(idEV).

process
	(
		createEV(idEV) | createHonestActors() | publishSensitiveInfomation() |
		dishonestCS(publicChannel) | dishonestEP(publicChannel)
	)
)

ifdef(`SECRECY2',

(* queries *)
free idEV: ID [private].
query attacker(new idEP[]).

process
	(
		createEV(idEV) | createHonestActors() | publishSensitiveInfomation() |
		dishonestCS(publicChannel) | dishonestMO(publicChannel) 
	)
)

ifdef(`ANONYMITY',
dnl Question: is SECRECY <-> ANONYMITY ??

free privateChannel: channel [private].

process
	(
		(new idEV0:ID;out(privateChannel,idEV0)) | (new idEV:ID; in(privateChannel,idEV0:ID); createEV(choice[idEV,idEV0]) ) |
		!(new idEV:ID; createEV(idEV) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		dishonestEV(publicChannel) | dishonestCS(publicChannel) | dishonestEP(publicChannel) | dishonestMO(publicChannel)
	)
)

ifdef(`STRONG_SECRECY',

free idEV: ID [private].
free idEV0: ID [private].

process
	(
		createEV(choice[idEV,idEV0]) | !(new idEV:ID; createEV(idEV) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		dishonestEV(publicChannel) | dishonestCS(publicChannel) | dishonestEP(publicChannel) | dishonestMO(publicChannel)
	)
)

ifdef(`OFFLINE_GUESSING',
free idEV: ID [private].

process
	(
		(new idEV0: ID; out(publicChannel,choice[idEV,idEV0]); createEV(idEV)) | !(new idEV:ID; createEV(idEV) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		dishonestEV(publicChannel) | dishonestCS(publicChannel) | dishonestEP(publicChannel) | dishonestMO(publicChannel)
	)
)

ifdef(`UNLINKABILITY',
process
	(
		!(new idEV:ID; if choice[false,true] then createEV(idEV) else createEV_singleinstance(idEV) ) |
		| (new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestEV(publicChannel) | !dishonestCS(publicChannel) | !dishonestEP(publicChannel) | !dishonestMO(publicChannel)
	)
)
