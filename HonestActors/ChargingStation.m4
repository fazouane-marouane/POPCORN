let honestCS(idCS:ID, skCS:skey, chCS:channel, idEP:ID, pkCS:pkey, chEP:channel, pkEP:pkey) =
	(* get infos *)
	(* connect securely to an electric vehicle (EV) *)
	new callback: channel;
	auth_server(chCS,skCS,callback) |
	in(callback,privateCh:channel);
	(*event securelyConnectedToEV(idCS,idEV);*)
	(* verify the credentials *)
	in(privateCh,credEV:anonymousCred);
	let m = verifyCred(credEV) in
	(* the credentials are valid*)
	(* start the charging session *)
	get gpkeyTable(gpk_) in 
	new meterReading: bitstring;
	(* 1.1 Send Meter reading *)
	out(privateCh,meterReading);
	(* 1.2 Get commit with group signature *)
	in(privateCh,signedMeterReading:bitstring);
	if meterReading = gchecksign(m,gpk_) then(
		(* Send Partial SDR with encrypted EP *)
		new trid: transactID;
		new payment: bitstring;
		let sdr=createSDR(trid, senc(IDTobitstring(idEP),kPH), payment) in
		out(privateCh,sdr);
		(* Send anonymously Commits+SDR to the EP *)
		out(chEP,(sdr,signedMeterReading)) (* Il faut utiliser ici un mecanisme d'authentification/signature *)
	).

let createCS(idCS: ID)=
	new chCS: channel;
	new skCS: skey;
	get EPTable(idEP,chEP,pkEP) in
	insert CSTable(idCS,chCS,idEP,Pk(skCS));
	!honestCS(idCS,skCS).
