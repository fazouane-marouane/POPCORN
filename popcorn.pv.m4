(* POPCORN *)
(* Debug Options *)
set ignoreTypes = false.
set simplifyProcess = true.
set displayDerivation = false .
set traceDisplay = short.
dnl set simplifyDerivation = true.
dnl set abbreviateDerivation = true.
dnl set reconstructTrace = true.
set movenew = true.

event exit.
event exit_EV.
event exit_PH.
event exit_DR.
event exit_CS.
event exit_CS2.
event exit_EP.
event exit_MO.
event exit_MO1.
event exit_MO2.
event exit_MO3.

free publicChannel: channel.
(* N.b. the yellow pages are not visible to the adversary *)
free yellowpagesEV: channel [private].
free yellowpagesCS: channel [private].
free yellowpagesEP: channel [private].
free yellowpagesMO: channel [private].
free yellowpagesPH: channel [private].
free yellowpagesDR: channel [private].

(* Cryptographic primitives *)
include(`Crypto/Crypto.pv.m4')
include(`HonestActors/_HonestActors.pv.m4')
include(`DishonestActors/_DishonestActors.pv.m4')

(* main process *)

let publishSensitiveInfomation()=
	(out(publicChannel,GPk(gmsk)))|
	!(in(yellowpagesMO,x:bitstring);
	out(publicChannel,x)) |
	!(in(yellowpagesEP,x:bitstring);
	out(publicChannel,x)) |
	!(in(yellowpagesCS,x:bitstring);
	out(publicChannel,x)) |
	!(in(yellowpagesPH,x:bitstring);
	out(publicChannel,x)) |
	!(in(yellowpagesDR,x:bitstring);
	out(publicChannel,x)).

let createHonestActors()=
	new skPH: skey;
	new skDR: skey;
	new chPH: channel;
	new chDR: channel;
	(
		!out(gpk,GPk(gmsk)) |
		!DR(skDR,chDR) | !out(yellowpagesDR, (Pk(skDR),chDR)) |
		!PH(skPH,chPH) | !out(yellowpagesPH, (Pk(skPH),chPH) )
	).


ifdef(`CORRESPONDANCE',
dnl query event(exit_EV).
query event(exit_EP).
dnl query event(exit_MO).
dnl query event(exit_CS).
dnl query event(exit_PH).
dnl query event(exit_DR).
dnl query event(exit_EV).
dnl query event(exit_EP).
dnl query event(exit_CS2).
free idCS: ID [private].
free idEV: ID [private].
free idMO: ID [private].
free idEP: ID [private].
dnl query attacker(idEV).

process
	(
		createHonestActors() |
		dnl publishSensitiveInfomation() |
		createEV(idEV) |
		createMO(idMO) |
		createCS(idCS) |
		createEP(idEP)
		(*!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()*)
	)
)

ifdef(`SECRECY1',

(* queries *)
free idEV: ID [private].
free idMO: ID [private].
query attacker(idEV).

dnl (new idEP: ID; createMO(idEP)) |

process
	(
		createEV3(idEV,idMO) | createHonestActors() | publishSensitiveInfomation() |
		createMO(idMO) |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO() 
	)
)

ifdef(`SECRECY2',

(* queries *)
free idEP: ID [private].
query attacker(idEP).

process
	(
		(new idEV:ID; createEV2(idEV,idEP)) | createHonestActors() | publishSensitiveInfomation() |
		!dishonestEV() | !dishonestCS() | !dishonestMO() 
	)
)

ifdef(`ANONYMITY',
free idEV: ID [private].
free idMO: ID [private].

equivalence
	(
		createEV3(idEV,idMO) | !(new idEV:ID; createEV(idEV) ) |
		createHonestActors() |
		publishSensitiveInfomation() |
		createMO(idMO) |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
	(
		(new idEV:ID; createEV(idEV)) | !(new idEV:ID; createEV(idEV) ) |
		createHonestActors() |
		publishSensitiveInfomation() |
		createMO(idMO) |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`STRONG_SECRECY1',
(* false model *)
free idEV: ID [private].
noninterf idEV.
free idMO: ID [private].

process
	(
		createEV3(idEV,idMO) | !(new idEV:ID; createEV(idEV)) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		createMO(idMO) |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`STRONG_SECRECY2',
(* false model *)
free idEP: ID [private].
noninterf idEP.

process
	(
		createEP(idEP) |
		(new idEV:ID; createEV2(idEV,idEP)) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestEV() | !(new idCS:ID; createCS(idCS)) | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`OFFLINE_GUESSING',
free idEV: ID [private].
free idMO: ID [private].

process
	(
		(new idEV0: ID; out(publicChannel,choice[idEV,idEV0]); createEV3(idEV,idMO)) |
		createHonestActors() |
		publishSensitiveInfomation() |
		createMO(idMO) |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`UNLINKABILITY1',

equivalence
	(
		(new idEV:ID; createEV(idEV)) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
	(
		(new idEV:ID; createEV_singleinstance(idEV) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`UNLINKABILITY2',
free idEP: ID [private].

equivalence
	(
		createEP(idEP) | !(new idEV:ID; createEV2(idEV,idEP) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestCS() | !dishonestEP() | !dishonestMO()
	)
	(
		createEP(idEP) | !(new idEV:ID; createEV(idEV) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)
