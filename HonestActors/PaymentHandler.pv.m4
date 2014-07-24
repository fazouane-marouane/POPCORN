(* Payment Handler *)
free chPH: channel.

let PH(skPH: skey) =
	(* Get Payment, Enc(EP), transaction number *)
	in(chPH,(chMO:channel,sdr:bitstring));
	(* compute the transaction number and the payment amount *)
	let createSDR(transactionNumber,enc_idEP, payment) = sdr in
	(* Compute EP = Dec(Enc(EP)) *)
	let ID_to_bitstring(idEP) = adec(enc_idEP,skPH) in
	in(yellowpagesEP,(=idEP,chEP:channel,pkEP:pkey));
	(* Send payment+transaction number to EP *)
	out(chEP,(payment,transactionNumber)); (* I guess we should use a signature mecanism here *)
	(* Send payment receipt to MO *)
	out(chMO,createReceipt(transactionNumber));
	event exit_PH.
