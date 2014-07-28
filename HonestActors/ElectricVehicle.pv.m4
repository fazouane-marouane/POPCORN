(* Electric Vehicle *)

(* Event Lists *)
event selectCS(ID,ID).
event securelyConnectedToCS(ID,ID).
event showAnonymousCredentials(ID,ID).
event sessionStarted(ID,ID).
event sendSignedCommits(ID,ID).
event getSDR(ID,ID).
event sendSDRToMO(ID,ID,ID).

define(`honestEV_definition',
``'
let honestEV`'ifelse(`$1',`EP',`_EP')(ifelse(`$1',`EP',`idEP:ID, ')idEV:ID, chEV:channel, skEV:skey, gskEV:skey, m:bitstring, open:Open, credEV: bitstring, idMO:ID, contract:ContractID) =
	(* get infos*)
	out(publicChannel,idEV);
	(* select a charging station (CS) *)
	in(yellowpagesCS,(idCS:ID, chCS:channel, ifelse(`$1',`EP',`=idEP',`idEP:ID') , pkCS:pkey) );
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
			event sendSDRToMO(idEV,idCS,idMO);
			event exit_EV
		)
	).
')

honestEV_definition(`EP')
honestEV_definition(`')

(* creates and registers n vehicles/users*)
define(`createEV_definition',
` `'
let createEV`'ifelse($1,`MO',`_MO')`'ifelse($2,`EP',`_EP')`'ifelse($3,`single',`_singleinstance') dnl
  (idEV:ID ifelse($1,`MO',`, idMO:ID') ifelse($2,`EP',`, idEP:ID'))=
	new skEV:skey;
	new chUser:channel;
	new m:bitstring;
	new open: Open;
	in(yellowpagesPH,(pkPH: pkey,chPH:channel));
	let anonymcred = ObtainSig(pkPH,m,Commit(m,open),open) in
	in(yellowpagesMO,(ifelse($1,`MO',`=idMO',`idMO:ID'),chMO:channel,pkMO:pkey));
	ifelse($3,`single',`',`!') dnl
	(
		!out(yellowpagesEV,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,idEV),anonymcred)) |
		honestEV`'ifelse($2,`EP',`_EP')(ifelse($2,`EP',`idEP,')`'idEV,chUser,skEV,GKeygen(gmsk,idEV),m,open,anonymcred,idMO,createContractID(idEV))
	).
')

createEV_definition(`',`',`')
createEV_definition(`MO',`',`')
createEV_definition(`',`EP',`')
createEV_definition(`MO',`EP',`')

(* creates and registers n vehicles/users*) 
createEV_definition(`',`',`single')
createEV_definition(`MO',`',`single')
createEV_definition(`',`EP',`single')
createEV_definition(`MO',`EP',`single')
