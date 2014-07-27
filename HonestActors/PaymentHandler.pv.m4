(* Payment Handler *)

let PH(skPH: skey,chPH: channel) =
	new callback: channel;
	authServer_unilateral(chPH,skPH,callback) |
	(
		in(callback,privateCh:channel);
		(* Get Payment, Enc(EP), transaction number *)
		in(privateCh,sdr:SDR);
		out(publicChannel,sdr); (* honest but curious actor *)
		(* compute the transaction number and the payment amount *)
		let createSDR(transactionNumber,enc_idEP, payment) = sdr in
		(* Compute EP = Dec(Enc(EP)) *)
		let ID_to_bitstring(idEP) = adec_rand(enc_idEP,skPH) in
		event exit_PH;
		in(yellowpagesEP,(=idEP,chEP:channel,pkEP:pkey));
		(* Send payment+transaction number to EP *)
		out(chEP,(payment,transactionNumber)); (* I guess we should use a signature mecanism here *)
		(* Send payment receipt to MO *)
		out(privateCh,createReceipt(transactionNumber));
		event exit_PH
	).
