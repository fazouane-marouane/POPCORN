(* Charging station *)

let honestCS(idCS:ID, skCS:skey, chCS:channel, idEP:ID, pkCS:pkey, chEP:channel, pkEP:pkey) =
	(* get infos *)
	(* connect securely to an electric vehicle (EV) *)
	new callback: channel;
	authServer_unilateral(chCS,skCS,callback) |
	(
		in(callback,privateCh:channel);
		(*event securelyConnectedToEV(idCS,idEV);*)
		(* verify the credentials *)
		in(yellowpagesPH,pkPH:pkey);
		in(privateCh,(com:Commitment,credEV_anonymousProof:Proof));
		if VerifyProof(pkPH,com,credEV_anonymousProof) then
		(
			(* the credentials are valid*)
			(* start the charging session *)
			new meterReading: bitstring;
			(* 1.1 Send Meter reading *)
			out(privateCh,meterReading);
			(* 1.2 Get commit with group signature *)
			in(privateCh,signedMeterReading:bitstring);
			in(gpk,gpk_:pkey);
			if CheckSign(signedMeterReading,gpk_) then
			if meterReading = RecoverData(signedMeterReading) then(
				(* Send Partial SDR with encrypted EP *)
				new trid: transactID;
				new payment: bitstring;
				let sdr=createSDR(trid, aenc(ID_to_bitstring(idEP),pkPH), payment) in
				out(privateCh,sdr);
				(* Send anonymously Commits+SDR to the EP *)
				out(chEP,(sdr,signedMeterReading)) (* Il faut utiliser ici un mecanisme d'authentification/signature *)
			)
		)
	).

let createCS(idCS: ID)=
	new chCS: channel;
	new skCS: skey;
	in(yellowpagesEP,(idEP:ID,chEP:channel,pkEP:pkey));
	(!out(yellowpagesCS,(idCS,chCS,idEP,Pk(skCS))) |
	!honestCS(idCS,skCS,chCS,idEP,Pk(skCS),chEP,pkEP)).

let createCS_singleinstance(idCS: ID)=
	new chCS: channel;
	new skCS: skey;
	in(yellowpagesEP,(idEP:ID,chEP:channel,pkEP:pkey));
	(!out(yellowpagesCS,(idCS,chCS,idEP,Pk(skCS))) |
	honestCS(idCS,skCS,chCS,idEP,Pk(skCS),chEP,pkEP)).

