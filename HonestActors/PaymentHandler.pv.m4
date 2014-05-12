(* Payment Handler *)
free chPH: channel.
free kPH: key [private].

let PH() =
	(* Get Payment, Enc(EP), transaction number *)
	in(chPH,(chMO:channel,sdr:bitstring));
	(* compute the transaction number and the payment amount *)
	let createSDR(transactionNumber,enc_idEP, payment) = sdr in
	(* Compute EP = Dec(Enc(EP)) *)
	let ID_to_bitstring(idEP) = sdec(enc_idEP,kPH) in
	in(yellowpagesEP,(=idEP,chEP:channel,pkEP:pkey));
	(* Send payment+transaction number to EP *)
	out(chEP,(payment,transactionNumber)); (* I guess we should use a signature mecanism here *)
	(* Send payment receipt to MO *)
	out(chMO,createReceipt(transactionNumber)).
