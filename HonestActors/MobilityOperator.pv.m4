(* Mobility Operator *)

free receiptTable: channel [private].

let honestMO(idMO:ID, skMO:skey, chMO:channel) =
	(* UseCase1 *)
	(
		authServer_unilateral(chMO,skMO,privateCh); (* with the EV *)
		(* Get complete SDR + Contract ID *)
		in(privateCh,(sdr:SDR,contract:ContractID));
		(* Send Payment+Enc(EP)+transaction number to PH *)
		in(yellowpagesPH,(pkPH: pkey,chPH:channel));
		authClient_unilateral(chPH,pkPH,privateCh) (* with the PH *)
		(
			out(privateCh,sdr);
			(* Get Payment receipt for transaction number *)
			in(privateCh,receipt:bitstring);
			(* Bill the user *)
			let createSDR(transactionNumber,enc_idEP, payment) = sdr in
			event exit_MO1;
			!(out(receiptTable,(transactionNumber,receipt)))
		)
	) |
	(* UseCase2 *)
	(
		authServer_unilateral(chMO,skMO,privateCh); (* with the DR *)
		(* Get a dispute verification request with SDR *)
		in(privateCh,sdr:SDR); (* il faut utiliser un mecanisme de signature/authentification *)
		let createSDR(transactionNumber,enc_idEP, payment) = sdr in
		event exit_MO;
		in(receiptTable,(=transactionNumber,receipt:bitstring));
		(
			(event exit_MO2 (* Contact the user?? *)) |
			(out(privateCh,receipt);event exit_MO3) (* Respond with payment receipt if available *)
		)
	).

let createMO(idMO: ID)=
	new chMO: channel;
	new skMO: skey;
	!(
		!out(yellowpagesMO,(idMO,chMO,Pk(skMO))) |
		honestMO(idMO,skMO,chMO)
	).

let createMO_singleinstance(idMO: ID)=
	new chMO: channel;
	new skMO: skey;
	!(
		!out(yellowpagesMO,(idMO,chMO,Pk(skMO))) |
		honestMO(idMO,skMO,chMO)
	).
