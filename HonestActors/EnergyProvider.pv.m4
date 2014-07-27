(* Energy Provider (EP) *)

free PaidSessions: channel [private].

let honestEP(idEP: ID,skEP:skey, chEP:channel, pkEP:pkey)=
	(* Get the anonymous Commit +SDR *)
	in(chEP,(idCS:ID, sdr:SDR, commits:bitstring));
	out(publicChannel, idCS);
	let createSDR(transactionNumber,enc_idEP, payment) = sdr in
	(
		(* wait for the payment *)
		in(chEP,(=payment,=transactionNumber)); (* TODO: we probably need a secure communication here *)
		event exit_EP;
		!out(PaidSessions,transactionNumber)
	) |
	(
		(* waits 10 time units before reporting a dispute to DR *)
		new callback: channel;
		(
			in(PaidSessions,=transactionNumber);
			out(callback, false)
		)|
		(
			in(callback,branch:bool);
			if branch then
			(
				new callback: channel;
				in(yellowpagesDR,(pkDR:pkey,chDR:channel));
				authClient_unilateral(chDR,pkDR,callback) |
				(
					in(callback,privateCh:channel);
					out(privateCh, (sdr,commits)); (* report to DR *)
					event exit_EP
				)
			)
		)|
		out(callback,true)
	).

let createEP(idEP: ID)=
	new chEP: channel;
	new skEP: skey;
	(!out(yellowpagesEP,(idEP,chEP,Pk(skEP)))|
	!honestEP(idEP,skEP,chEP,Pk(skEP)) ).

let createEP_singleinstance(idEP: ID)=
	new chEP: channel;
	new skEP: skey;
	(!out(yellowpagesEP,(idEP,chEP,Pk(skEP)))|
	honestEP(idEP,skEP,chEP,Pk(skEP)) ).