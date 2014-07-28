(* Energy Provider (EP) *)

free PaidSessions: channel [private].

let honestEP(idEP: ID,skEP:skey, chEP:channel)=
	(* Get the anonymous Commit +SDR *)
	authServer_unilateral(chEP,skEP,privateCh); (* with the CS*)
	in(privateCh,(idCS:ID, sdr:SDR, commits:bitstring));
	let createSDR(transactionNumber,enc_idEP, payment) = sdr in
	(
		(* wait for the payment *)
		authServer_unilateral(chEP,skEP,privateCh); (* with the PH *)
		in(privateCh,(=payment,=transactionNumber)); (* TODO: we probably need a secure communication here *)
		event exit_EP1;
		!out(PaidSessions,transactionNumber)
	) |
	(
		(* reporting a dispute to DR *)
		new callback: channel;
		(
			in(PaidSessions,=transactionNumber);
			out(callback, false)
		)|
		(
			in(callback,branch:bool);
			if branch then
			(
				in(yellowpagesDR,(pkDR:pkey,chDR:channel));
				authClient_unilateral(chDR,pkDR,privateCh) (* with the DR*)
				(
					out(privateCh, (sdr,commits)); (* report to DR *)
					event exit_EP2
				)
			)
		)|
		out(callback,true)
	).

let createEP(idEP: ID)=
	new chEP: channel;
	new skEP: skey;
	!(
		!out(yellowpagesEP,(idEP,chEP,Pk(skEP))) |
		honestEP(idEP,skEP,chEP)
	).

let createEP_singleinstance(idEP: ID)=
	new chEP: channel;
	new skEP: skey;
	(
		!out(yellowpagesEP,(idEP,chEP,Pk(skEP))) |
		honestEP(idEP,skEP,chEP)
	).
