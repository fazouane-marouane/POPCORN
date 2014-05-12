(* Mobility Operator *)
table receiptTable(transactID,bitstring).
let honestMO(idMO:ID, skMO:skey, chMO:channel, pkMO:pkey) =
	(* UseCase1 *)
	(
		(* Get complete SDR + Contract ID *)
		in(chMO,(sdr:bitstring,contract:ContractID));
		(* Send Payment+Enc(EP)+transaction number to PH *)
		new privateCh: channel;
		out(chPH,(privateCh,sdr));
		(* Get Payment receipt for transaction number *)
		in(privateCh,receipt:bitstring);
		(* Bill the user *)
		insert receiptTable(getTransactID(sdr),receipt)
	) |
	(* UseCase2 *)
	(
		(* Get a dispute verification request with SDR *)
		in(chMO,(privateCh:channel, sdr:bitstring)); (* il faut utiliser un mecanisme de signature/authentification *)
		let transactionNumber = getTransactID(sdr) in
		get receiptTable(=transactionNumber,receipt) in
		(* Respond with payment receipt if available *)
		out(privateCh,receipt)
		else
		(* Contact the user?? *)
		0
	).

let createMO(idMO: ID)=
	new chMO: channel;
	new skMO: skey;
	insert MOTable(idMO,chMO,Pk(skMO));
	!honestMO(idMO,skMO).
