(* not needed at all *)
let dishonestEV(c: channel)=
	in(c,idEV:ID);
	new skEV:skey;
	new chUser:channel;
	new k:bitstring;
	let anonymcred = createAnonymousCred(idEV,createValidCred(idEV,k)) in
	in(yellowpagesMO,(idMO:ID,chMO:channel,pkMO:pkey));
	(!out(yellowpagesEV,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,ID_to_bitstring(idEV)),anonymcred)) |
	out(c,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,ID_to_bitstring(idEV)),anonymcred)) ).
