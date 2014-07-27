(* Electric Vehicle *)

(* Event Lists *)
event selectCS(ID,ID).
event securelyConnectedToCS(ID,ID).
event showAnonymousCredentials(ID,ID).
event sessionStarted(ID,ID).
event sendSignedCommits(ID,ID).
event getSDR(ID,ID).
event sendSDRToMO(ID,ID,ID).

let honestEV(idEV:ID, chEV:channel, skEV:skey, gskEV:skey, m:bitstring, open:Open, credEV: bitstring, idMO:ID, contract:ContractID) =
	(* get infos*)
	(* select a charging station (CS) *)
	in(yellowpagesCS,(idCS:ID, chCS:channel, idEP:ID, pkCS:pkey) );
	event selectCS(idEV,idCS);
	(* connect securely to the CS *)
	authClient_unilateral(chCS,pkCS,privateCh)
	(
		event securelyConnectedToCS(idEV,idCS);
		new k: nonce;
		let trid = createTransactionID(idEP,k) in
		out(privateCh,trid);
		(* Show anonymous credentials proof to CS *)
		in(yellowpagesPH,(pkPH: pkey,chPH:channel));
		out(privateCh,(Commit(m,open),Prove(pkPH,m,credEV)));
		event showAnonymousCredentials(idEV,idCS);
		(* The response at this point is positive *)
		(* 1.1 Get the meter reading *)
		in(privateCh,(meterReading:MeterReading,k:nonce));
		event sessionStarted(idEV,idCS);
		(* 1.2 Commit with group signature *)
		out(privateCh,(Sign((meterReading,k),gskEV),k));
		event sendSignedCommits(idEV,idCS);
		(* Get Partial SDR with encrypted EP *)
		in(privateCh,sdr:SDR);
		event getSDR(idEV,idCS);
		(* Submit the SDR+ Contract ID to MO *)
		in(yellowpagesMO,(=idMO,chMO:channel,pkMO:pkey));
		authClient_unilateral(chMO,pkMO,privateCh)
		(
			out(privateCh,(sdr,contract));
			out(publicChannel, idEV);
			event sendSDRToMO(idEV,idCS,idMO);
			event exit_EV
		)
	).

(* creates and registers n vehicles/users*)
let createEV(idEV:ID)=
	new skEV:skey;
	new chUser:channel;
	new m:bitstring;
	new open: Open;
	in(yellowpagesPH,(pkPH: pkey,chPH:channel));
	let anonymcred = ObtainSig(pkPH,m,Commit(m,open),open) in
	in(yellowpagesMO,(idMO:ID,chMO:channel,pkMO:pkey));
	!(
		!out(yellowpagesEV,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,idEV),anonymcred)) |
		honestEV(idEV,chUser,skEV,GKeygen(gmsk,idEV),m,open,anonymcred,idMO,createContractID(idEV))
	).

let createEV3(idEV:ID, idMO:ID)=
	new skEV:skey;
	new chUser:channel;
	new m:bitstring;
	new open: Open;
	in(yellowpagesPH,(pkPH: pkey,chPH:channel));
	let anonymcred = ObtainSig(pkPH,m,Commit(m,open),open) in
	in(yellowpagesMO,(=idMO,chMO:channel,pkMO:pkey));
	!(
		!out(yellowpagesEV,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,idEV),anonymcred)) |
		honestEV(idEV,chUser,skEV,GKeygen(gmsk,idEV),m,open,anonymcred,idMO,createContractID(idEV))
	).

(* creates and registers n vehicles/users*) 
let createEV_singleinstance(idEV:ID)=
	new skEV:skey;
	new chUser:channel;
	new m:bitstring;
	new open: Open;
	in(yellowpagesPH,(pkPH: pkey,chPH:channel));
	let anonymcred = ObtainSig(pkPH,m,Commit(m,open),open) in
	in(yellowpagesMO,(idMO:ID,chMO:channel,pkMO:pkey));
	(
		!out(yellowpagesEV,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,idEV),anonymcred)) |
		honestEV(idEV,chUser,skEV,GKeygen(gmsk,idEV),m,open,anonymcred,idMO,createContractID(idEV))
	).

let createEV3_singleinstance(idEV:ID, idMO:ID)=
	new skEV:skey;
	new chUser:channel;
	new m:bitstring;
	new open: Open;
	in(yellowpagesPH,(pkPH: pkey,chPH:channel));
	let anonymcred = ObtainSig(pkPH,m,Commit(m,open),open) in
	in(yellowpagesMO,(=idMO,chMO:channel,pkMO:pkey));
	(
		!out(yellowpagesEV,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,idEV),anonymcred)) |
		honestEV(idEV,chUser,skEV,GKeygen(gmsk,idEV),m,open,anonymcred,idMO,createContractID(idEV))
	).
