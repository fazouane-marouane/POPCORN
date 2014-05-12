(* Payment Handler *)
free chPH: channel.
free kPH: key [private].

let PH() =
	(* Get Payment, Enc(EP), transaction number *)
	in(chPH,(chMO:channel,sdr:bitstring));
	(* compute the transaction number and the payment amount *)
	let transactionNumber = getTransactID(sdr) in
	let payment = getPayment(sdr) in
	(* Compute EP = Dec(Enc(EP)) *)
	let idEP = bitstringToID(sdec(getEncryptedEP(sdr),kPH)) in
	get EPTable(=idEP,chEP,pkEP) in
	(* Send payment+transaction number to EP *)
	out(chEP,(payment,transactionNumber)); (* Il manque le mecanisme de signature *)
	(* Send payment receipt to MO *)
	out(chMO,createReceipt(transactionNumber)).