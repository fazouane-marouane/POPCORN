(* Electric Vehicle *)

(* Event Lists *)
event selectCS(ID,ID).
event securelyConnectedToCS(ID,ID).
event showAnonymousCredentials(ID,ID).
event sessionStarted(ID,ID).
event sendSignedCommits(ID,ID).
event getSDR(ID,ID).
event sendSDRToMO(ID,ID,ID).

let honestEV(idEV:ID, chEV:channel, skEV:skey, gskEV:skey, m:bitstring, open:Open, credEV: bitstring, idMO:ID, chMO:channel, pkMO:pkey, contract:ContractID) =
	(* get infos*)
	(* select a charging station (CS) *)
	in(yellowpagesCS,(idCS:ID, chCS:channel, idEP:ID, pkCS:pkey) );
	event selectCS(idEV,idCS);
	(* connect securely to the CS *)
	new callback:channel;
	authClient_unilateral(chCS,pkCS,callback) |
	in(callback,privateCh:channel);
	event securelyConnectedToCS(idEV,idCS);
	(* Show anonymous credentials proof to CS *)
	in(yellowpagesPH,pkPH: pkey);
	out(privateCh,(Commit(m,open),Prove(pkPH,m,credEV)));
	event exit;
	event showAnonymousCredentials(idEV,idCS);
	(* The response at this point is positive *)
	(* 1.1 Get the meter reading *)
	in(privateCh,meterReading:bitstring);
	event sessionStarted(idEV,idCS);
	(* 1.2 Commit with group signature *)
	out(privateCh,Sign(meterReading,gskEV));
	event sendSignedCommits(idEV,idCS);
	(* Get Partial SDR with encrypted EP *)
	in(privateCh,sdr:bitstring);
	event getSDR(idEV,idCS);
	(* Submit the SDR+ Contract ID to MO *)
	new callback:channel;
	authClient_unilateral(chMO,pkMO,callback) |
	(
		in(callback,privateCh:channel);
		out(callback,(sdr,contract));
		event sendSDRToMO(idEV,idCS,idMO);
		event exit
	).

(* creates and registers n vehicles/users*)
let createEV(idEV:ID)=
	new skEV:skey;
	new chUser:channel;
	new m:bitstring;
	new open: Open;
	in(yellowpagesPH,pkPH: pkey);
	let anonymcred = ObtainSig(pkPH,m,Commit(m,open),open) in
	in(yellowpagesMO,(idMO:ID,chMO:channel,pkMO:pkey));
	!(!out(yellowpagesEV,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,ID_to_bitstring(idEV)),anonymcred)) |
	honestEV(idEV,chUser,skEV,GKeygen(gmsk,ID_to_bitstring(idEV)),m,open,anonymcred,idMO,chMO,pkMO,createContractID(idEV)) ).

(* creates and registers n vehicles/users*) 
let createEV_singleinstance(idEV:ID)=
	new skEV:skey;
	new chUser:channel;
	new m:bitstring;
	new open: Open;
	in(yellowpagesPH,pkPH: pkey);
	let anonymcred = ObtainSig(pkPH,m,Commit(m,open),open) in
	in(yellowpagesMO,(idMO:ID,chMO:channel,pkMO:pkey));
	(!out(yellowpagesEV,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,ID_to_bitstring(idEV)),anonymcred)) |
	honestEV(idEV,chUser,skEV,GKeygen(gmsk,ID_to_bitstring(idEV)),m,open,anonymcred,idMO,chMO,pkMO,createContractID(idEV)) ).

