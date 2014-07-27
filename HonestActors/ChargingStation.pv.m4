(* Charging station *)

let honestCS(idCS:ID, skCS:skey, chCS:channel, idEP:ID) =
	(* get infos *)
	(* connect securely to an electric vehicle (EV) *)
	authServer_unilateral(chCS,skCS,privateCh);
	in(privateCh,trid:transactID);
	(*event securelyConnectedToEV(idCS,idEV);*)
	(* verify the credentials *)
	in(privateCh,(com:Commitment,credEV_anonymousProof:Proof));
	in(yellowpagesPH,(pkPH:pkey,chPH:channel));
	if VerifyProof(pkPH,com,credEV_anonymousProof) then
	(
		let createTransactionID(=idEP,k) =trid in
		(* the credentials are valid*)
		(* start the charging session *)
		new meterReading: MeterReading;
		new k: nonce;
		(* 1.1 Send Meter reading *)
		out(privateCh,(meterReading,k));
		(* 1.2 Get commit with group signature *)
		in(privateCh,(signedMeterReading:bitstring,=k));
		in(gpk,gpk_:pkey);
		if CheckSign(signedMeterReading,gpk_) then
		if (meterReading,k) = RecoverData(signedMeterReading) then(
			(* Send Partial SDR with encrypted EP *)
			new payment: bitstring;
			new r: nonce;
			let sdr=createSDR(trid, aenc_rand(ID_to_bitstring(idEP),r,pkPH), payment) in
			out(privateCh,sdr);
			in(yellowpagesEP,(=idEP,chEP:channel,pkEP:pkey));
			(* Send anonymously Commits+SDR to the EP *)
			out(chEP,(idCS,sdr,signedMeterReading)); (* Il faut utiliser ici un mecanisme d'authentification/signature *)
			event exit_CS
		)
	).

let createCS(idCS: ID)=
	new chCS: channel;
	new skCS: skey;
	in(yellowpagesEP,(idEP:ID,chEP:channel,pkEP:pkey));
	!(
		!out(yellowpagesCS,(idCS,chCS,idEP,Pk(skCS))) |
		honestCS(idCS,skCS,chCS,idEP)
	).

let createCS_singleinstance(idCS: ID)=
	new chCS: channel;
	new skCS: skey;
	in(yellowpagesEP,(idEP:ID,chEP:channel,pkEP:pkey));
	(
		!out(yellowpagesCS,(idCS,chCS,idEP,Pk(skCS))) |
		honestCS(idCS,skCS,chCS,idEP)
	).
