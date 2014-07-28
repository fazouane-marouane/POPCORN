(* POPCORN *)
(* Debug Options *)
set ignoreTypes = false.
set simplifyProcess = true.
set displayDerivation = false .
set traceDisplay = short.
set simplifyDerivation = false.
set abbreviateDerivation = false.
set reconstructTrace = false.
set movenew = true.

event exit.
event exit_EV.
event exit_PH.
event exit_DR.
event exit_CS.
event exit_CS2.
event exit_EP1.
event exit_EP2.
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

let publishSensitiveInfomation()= (* IDs are not passed, though *)
	(out(publicChannel,GPk(gmsk)))|
	!(in(yellowpagesMO,(idMO:ID,chMO:channel,pkMO:pkey));
	out(publicChannel,(chMO,pkMO)) ) |
	!(in(yellowpagesEP,(idEP:ID,chEP:channel,pkEP:pkey));
	out(publicChannel,(chEP,pkEP)) ) |
	!(in(yellowpagesCS,(idCS:ID,chCS:channel,idEP:ID,pkCS:pkey));
	out(publicChannel,(idCS,chCS,pkCS)) ) |
	!(in(yellowpagesPH,x:bitstring);
	out(publicChannel,x) ) |
	!(in(yellowpagesDR,x:bitstring);
	out(publicChannel,x) ).

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

let createHonestActors_singleinstance()=
	new skPH: skey;
	new skDR: skey;
	new chPH: channel;
	new chDR: channel;
	(
		!out(gpk,GPk(gmsk)) |
		DR(skDR,chDR) | !out(yellowpagesDR, (Pk(skDR),chDR)) |
		PH(skPH,chPH) | !out(yellowpagesPH, (Pk(skPH),chPH) )
	).

ifdef(`CORRESPONDANCE',
dnl query event(exit_EV).
dnl query event(exit_MO1).
dnl query event(exit_CS).
dnl query event(exit_EP1).
dnl query event(exit_EP2).
dnl query event(exit_PH).
dnl query event(exit_DR).

free idCS: ID [private].
free idEV: ID [private].
free idMO: ID [private].
free idEP: ID [private].

query attacker(idEV).

process
	(
		createHonestActors_singleinstance() |
		dnl publishSensitiveInfomation() |
		createEV_singleinstance(idEV) |
		createMO_singleinstance(idMO) |
		createCS_singleinstance(idCS) |
		createEP_singleinstance(idEP)
		(*!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()*)
	)
)

ifdef(`SECRECY1',

(* queries *)
free idEV: ID [private].
free idMO: ID [private].
query attacker(idEV).

process
	(
		createEV_MO(idEV,idMO) | createHonestActors() | publishSensitiveInfomation() |
		createMO(idMO) |
		!dishonestCS() | !dishonestEP() | !dishonestMO() 
	)
)

ifdef(`SECRECY2',

(* queries *)
free idEP: ID [private].
query attacker(idEP).

process
	(
		(new idEV:ID; createEV_EP(idEV,idEP)) |
		createHonestActors() |
		publishSensitiveInfomation() |
		createEP(idEP) |
		dishonestCS() | dishonestMO()
	)
)

ifdef(`ANONYMITY',
free idEV: ID [private].
free idMO: ID [private].

equivalence
	(
		(new idEV0:ID; createEV_MO(idEV,idMO)) | !(new idEV:ID; createEV(idEV) ) |
		createHonestActors() |
		publishSensitiveInfomation() |
		createMO(idMO) |
		dishonestCS() | dishonestEP()
	)
	(
		(new idEV:ID; createEV(idEV)) | !(new idEV:ID; createEV(idEV) ) |
		createHonestActors() |
		publishSensitiveInfomation() |
		createMO(idMO) |
		dishonestCS() | dishonestEP()
	)
)

ifdef(`STRONG_SECRECY1',
free idEV: ID [private].
free idMO: ID [private].
noninterf idEV.
noninterf idMO.

process
	(
		createEV_MO(idEV,idMO) |
		createHonestActors() |
		publishSensitiveInfomation() |
		createMO(idMO) |
		!dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`STRONG_SECRECY2',
dnl free idEP: ID [private].
dnl noninterf idEP.

process
	(
		new idEP0:ID; new idEP1:ID;
		new privateCh:channel;
		(out(privateCh,choice[idEP0,idEP1])) |
		(new idEV:ID; in(privateCh,idEP:ID); createEV_EP_singleinstance(idEV,idEP)) |
		!(new idEV:ID; createEV_singleinstance(idEV)) |
		createHonestActors_singleinstance() |
		publishSensitiveInfomation() |
		createEP_singleinstance(idEP0) |
		createEP_singleinstance(idEP1) |
		(new idCS:ID; createCS_singleinstance(idCS)) | (new idMO:ID; createMO_singleinstance(idMO))
	)
)

ifdef(`OFFLINE_GUESSING',
free idEV: ID [private].
free idMO: ID [private].

process
	(
		(new idEV0: ID; out(publicChannel,choice[idEV,idEV0]); createEV_MO_singleinstance(idEV,idMO)) |
		createHonestActors_singleinstance() |
		publishSensitiveInfomation() |
		createMO_singleinstance(idMO) |
		dishonestCS() | dishonestEP()
	)
)

ifdef(`UNLINKABILITY1',
free idMO: ID [private].

equivalence
	(
		!(new idEV:ID; createEV_MO(idEV,idMO)) |
		createHonestActors() |
		publishSensitiveInfomation() |
		createMO(idMO) |
		!dishonestCS() | !dishonestEP()
	)
	(
		!(new idEV:ID; createEV_MO_singleinstance(idEV,idMO)) |
		createHonestActors() |
		publishSensitiveInfomation() |
		createMO(idMO) |
		!dishonestCS() | !dishonestEP()
	)
)

ifdef(`UNLINKABILITY2',
free idEP: ID [private].

equivalence
	(
		createEP(idEP) | !(new idEV:ID; createEV_EP(idEV,idEP) ) |
		createHonestActors() |
		publishSensitiveInfomation() |
		!dishonestCS() | !dishonestEP() | !dishonestMO()
	)
	(
		createEP(idEP) | !(new idEV:ID; createEV(idEV) ) |
		createHonestActors() |
		publishSensitiveInfomation() |
		!dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)
