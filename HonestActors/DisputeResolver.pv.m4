(* Dispute resolver (DR) *)
free chDR: channel.
const gmsk: gmskey [private]. (* DR's gmskey *)

let DR() =
	(* Get dispute: Commits+SDR *)
	in(chDR, (sdr:bitstring,commits:bitstring));
	(* Uncover the EV-ID(Commits) *)
	let idEV = guncover(commits,gmsk) in
	get EVTable(=idEV,chEV,idMO,contract,skEV,gskEV,credEV) in
	get MOTable(=idMO,chMO,pkMO) in
	(* Verify Dispute(Send SDR to MO) *)
	new privateCh: channel;
	out(chMO,(privateCh,sdr));
	(* Get response *)
	in(chMO,receipt:bitstring)
	(* Do something with the receipt *)
	else
	(* contact the user?? *)
	0.
