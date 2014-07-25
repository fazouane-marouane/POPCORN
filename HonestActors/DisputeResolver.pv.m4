(* Dispute resolver (DR) *)
free chDR: channel.
const gmsk: gmskey [private]. (* DR's gmskey *)
free gpk: channel [private].
 


let DR(skDR: skey) =
	new callback: channel;
	authServer_unilateral(chDR,skDR,callback) |
	(
		in(callback,privateCh:channel);
		(* Get dispute: Commits+SDR *)
		in(privateCh, (sdr:bitstring,commits:bitstring));
		(* Uncover the EV-ID(Commits) *)
		let idEV = guncover(commits,gmsk) in
		in(yellowpagesEV,(=idEV,chEV:channel,idMO:ID,contract:ContractID,skEV:skey,gskEV:skey,credEV:bitstring));
		in(yellowpagesMO,(=idMO,chMO:channel,pkMO:pkey));
		(* Verify Dispute(Send SDR to MO) *)
		new callback: channel;
		authClient_unilateral(chMO,pkMO,callback) |
		(
			in(callback,privateCh:channel);
			out(privateCh,sdr);
			(* Get response *)
			in(privateCh,receipt:bitstring)
			(* Do something with the receipt *)
			dnl else
			(* contact the user?? *)
			dnl 0
		)
	)
	.
