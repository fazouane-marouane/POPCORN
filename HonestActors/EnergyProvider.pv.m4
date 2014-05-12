(* Energy Provider (EP) *)

table PaidSessions(transactID).
let honestEP(idEP: ID,skEP:skey, chEP:channel, pkEP:pkey)=
	(* Get the anonymous Commit +SDR *)
	in(chEP,(sdr:bitstring, commits:bitstring));
	let createSDR(transactionNumber,enc_idEP, payment) = sdr in
	(
		(* wait for the payment *)
		in(chEP,(payment:bitstring,=transactionNumber));
		insert PaidSessions(transactionNumber)
	) |
	(
		(* waits 10 time units before reporting a dispute to DR *)
		get PaidSessions(=transactionNumber) in 0
		else(
			(* report to DR *)
			out(chDR, (sdr,commits))
		)
	).

let createEP(idEP: ID)=
	new chEP: channel;
	new skEP: skey;
	(!out(yellowpagesEP,(idEP,chEP,Pk(skEP)))|
	!honestEP(idEP,skEP,chEP,Pk(skEP)) ).
