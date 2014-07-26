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
dnl query event(exit).
dnl query event(exit_MO3).

process
	(
		createEV(idEV,dummy,dummy) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() | (new idMO: ID; createMO(idMO)) |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`SECRECY1',

(* queries *)
free idEV: ID [private].
query attacker(idEV).

dnl (new idEP: ID; createMO(idEP)) |

process
	(
		createEV(idEV,dummy,dummy) | createHonestActors() | publishSensitiveInfomation() |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO() 
	)
)

ifdef(`SECRECY2',

(* queries *)
free idEP: ID [private].
query attacker(idEP).

process
	(
		(new idEV:ID; createEV(idEV,idEP,dummy)) | createHonestActors() | publishSensitiveInfomation() |
		!dishonestEV() | !dishonestCS() | !dishonestMO() 
	)
)

ifdef(`ANONYMITY',
dnl Question: is SECRECY <-> ANONYMITY ??

free privateChannel: channel [private].

process
	(
		(new idEV0:ID;out(privateChannel,idEV0)) | (new idEV:ID; in(privateChannel,idEV0:ID); createEV(choice[idEV,idEV0],dummy,dummy) ) |
		!(new idEV:ID; createEV(idEV) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`STRONG_SECRECY1',

free idEV: ID [private].
free idEV0: ID [private].

process
	(
		createEV(choice[idEV,idEV0],dummy,dummy) | !(new idEV:ID; createEV(idEV,dummy,dummy) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`STRONG_SECRECY2',

free idEP: ID [private].
free idEP0: ID [private].

process
	(
		createEP(idEP) |
		(new idEV:ID; createEV(idEV,choice[idEP,idEP0],dummy)) | !(new idEV:ID; createEV(idEV,dummy,dummy) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`OFFLINE_GUESSING',
free idEV: ID [private].

process
	(
		(new idEV0: ID; out(publicChannel,choice[idEV,idEV0]); createEV(idEV,dummy,dummy)) | !(new idEV:ID; createEV(idEV,dummy,dummy) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)

ifdef(`UNLINKABILITY1',

process
	(
		!(new idEV:ID; if choice[false,true] then createEV(idEV,dummy,dummy) else createEV_singleinstance(idEV,dummy,dummy) ) |
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

process
	(
		createEP(idEP) | !(new idEV:ID; createEV(idEV,choice[idEP,dummy],dummy) ) |
		(new skPH: skey;new skDR: skey;
			(!out(gpk,GPk(gmsk)) |
			 !DR(skDR) | !out(yellowpagesDR, Pk(skDR)) |
			 !PH(skPH) | !out(yellowpagesPH,Pk(skPH))) ) |
		publishSensitiveInfomation() |
		!dishonestEV() | !dishonestCS() | !dishonestEP() | !dishonestMO()
	)
)
