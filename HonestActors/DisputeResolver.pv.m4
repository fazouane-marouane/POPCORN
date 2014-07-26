(* Dispute resolver (DR) *)
free chDR: channel.
const gmsk: gmskey [private]. (* DR's gmskey *)
free gpk: channel [private].
 


let DR(skDR: skey) =
	new callback: channel;
	authServer_unilateral(chDR,skDR,callback) |
	(
		in(callback,privateCh_EP:channel);
		(* Get dispute: Commits+SDR *)
		in(privateCh_EP, (sdr:bitstring,commits:bitstring));
		(* Uncover the EV-ID(Commits) *)
		let idEV = guncover(commits,gmsk) in
		in(yellowpagesEV,(=idEV,chEV:channel,idMO:ID,contract:ContractID,skEV:skey,gskEV:skey,credEV:bitstring));
		in(yellowpagesMO,(=idMO,chMO:channel,pkMO:pkey));
		(* Verify Dispute(Send SDR to MO) *)
		new callback: channel;
		authClient_unilateral(chMO,pkMO,callback) |
		(
			in(callback,privateCh_MO:channel);
			out(privateCh_MO,sdr);
			(* Get response *)
			in(privateCh_MO,receipt:bitstring);
			(* Do something with the receipt *)
			out(privateCh_EP,receipt);
			(* contact the user?? *)
			event exit_DR
		)
	)
	.
