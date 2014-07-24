(* Mobility Operator *)

free receiptTable: channel [private].

let honestMO(idMO:ID, skMO:skey, chMO:channel, pkMO:pkey) =
	(* UseCase1 *)
	!(
		(* Get complete SDR + Contract ID *)
		in(chMO,(sdr:bitstring,contract:ContractID));
		(* Send Payment+Enc(EP)+transaction number to PH *)
		new privateCh: channel;
		out(chPH,(privateCh,sdr));
		(* Get Payment receipt for transaction number *)
		in(privateCh,receipt:bitstring);
		(* Bill the user *)
		let createSDR(transactionNumber,enc_idEP, payment) = sdr in
		event exit_MO1;
		!out(receiptTable,(transactionNumber,receipt))
	) |
	(* UseCase2 *)
	(
		(* Get a dispute verification request with SDR *)
		in(chMO,(privateCh:channel, sdr:bitstring)); (* il faut utiliser un mecanisme de signature/authentification *)
		let createSDR(transactionNumber,enc_idEP, payment) = sdr in
		new callback: channel;
		(
			in(receiptTable,(=transactionNumber,receipt:bitstring));
			(
				(out(callback,false);event exit_MO2) |
				(out(privateCh,receipt);event exit_MO3) (* Respond with payment receipt if available *)

			)
		) |
		(
			in(callback,branch:bool);
			if branch then 0 (* Contact the user?? *)
		) |
		( out(callback,true) )
	).

let createMO(idMO: ID)=
	new chMO: channel;
	new skMO: skey;
	(!out(yellowpagesMO,(idMO,chMO,Pk(skMO))) |
	honestMO(idMO,skMO,chMO,Pk(skMO)) ).
