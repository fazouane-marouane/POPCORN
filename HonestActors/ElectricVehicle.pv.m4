(* Event Lists *)
event selectCS(ID,ID).
event securelyConnectedToCS(ID,ID).
event showAnonymousCredentials(ID,ID).
event sessionStarted(ID,ID).
event sendSignedCommits(ID,ID).
event getSDR(ID,ID).
event sendSDRToMO(ID,ID,ID).

let honestEV(idEV:ID, chEV:channel, skEV:skey, gskEV:gskey, credEV:anonymousCred, idMO:ID, chMO:channel, pkMO:pkey, contract:ContractID) =
	(* get infos*)
	(* select a charging station (CS) *)
	in(CSchannel,(idCS:ID, chCS:channel, idEP:ID, pkCS:pkey) );
	event selectCS(idEV,idCS);
	(* connect securely to the CS *)
	new callback:channel;
	auth_client(chCS,gskEV,pkCS,callback) |
	in(callback,privateCh:channel);
	event securelyConnectedToCS(idEV,idCS);
	(* Show anonymous credentials proof to CS *)
	out(privateCh,credEV); (* comment se proteger du partage du credEV? *)
	event showAnonymousCredentials(idEV,idCS);
	(* The response at this point is positive *)
	(* 1.1 Get the meter reading *)
	in(privateCh,meterReading:bitstring);
	event sessionStarted(idEV,idCS);
	(* 1.2 Commit with group signature *)
	out(privateCh,gsign(meterReading,gskEV));
	event sendSignedCommits(idEV,idCS);
	(* Get Partial SDR with encrypted EP *)
	in(privateCh,sdr:bitstring);
	event getSDR(idEV,idCS);
	(* Submit the SDR+ Contract ID to MO *)
	out(chMO,(sdr,contract));
	event sendSDRToMO(idEV,idCS,idMO).

(* creates and registers n vehicles/users*)
let createEV(idEV:ID)=
	new skEV:skey;
	new chUser:channel;
	new k:bitstring;
	let anonymcred = createAnonymousCred(idEV,createValidCred(idEV,k)) in
	!honestEV(idEV,chUser,skEV,gkgen(gmsk,idEV),anonymcred,idMO,chMO,pkMO,createContractID(idEV)).
