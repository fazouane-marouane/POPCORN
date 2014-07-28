(* Payment Handler *)

let PH(skPH: skey,chPH: channel) =
	authServer_unilateral(chPH,skPH,privateCh); (* with the MO *)
	(* Get Payment, Enc(EP), transaction number *)
	in(privateCh,sdr:SDR);
	(*out(publicChannel,sdr);*) (* honest but curious actor *)
	(* compute the transaction number and the payment amount *)
	let createSDR(transactionNumber,enc_idEP, payment) = sdr in
	(* Compute EP = Dec(Enc(EP)) *)
	let ID_to_bitstring(idEP) = adec_rand(enc_idEP,skPH) in
	(* Send payment receipt to MO *)
	out(privateCh,createReceipt(transactionNumber));
	in(yellowpagesEP,(=idEP,chEP:channel,pkEP:pkey));
	(* Send payment+transaction number to EP *)
	authClient_unilateral(chEP,pkEP,privateCh) (* with the EP *)
	(
		out(privateCh,(payment,transactionNumber)); (* I guess we should use a signature mecanism here *)
		event exit_PH
	).
