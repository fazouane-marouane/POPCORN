(* Dispute resolver (DR) *)
free chDR: channel.
const gmsk: gmskey [private]. (* DR's gmskey *)
free gpk: channel [private].
 


let DR() =
	(* Get dispute: Commits+SDR *)
	in(chDR, (sdr:bitstring,commits:bitstring));
	(* Uncover the EV-ID(Commits) *)
	let idEV = guncover(commits,gmsk) in
	in(yellowpagesEV,(=idEV,chEV:channel,idMO:ID,contract:ContractID,skEV:skey,gskEV:skey,credEV:anonymousCred));
	in(yellowpagesMO,(=idMO,chMO:channel,pkMO:pkey));
	(* Verify Dispute(Send SDR to MO) *)
	new privateCh: channel;
	out(chMO,(privateCh,sdr));
	(* Get response *)
	in(chMO,receipt:bitstring)
	(* Do something with the receipt *)
	else
	(* contact the user?? *)
	0.
