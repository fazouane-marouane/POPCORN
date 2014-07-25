(* not needed at all *)
let dishonestEV(c: channel)=
	in(c,idEV:ID);
	new skEV:skey;
	new chUser:channel;
	new m:bitstring;
	new open: Open;
	in(yellowpagesPH,pkPH: pkey);
	let anonymcred = ObtainSig(pkPH,m,Commit(m,open),open) in
	in(yellowpagesMO,(idMO:ID,chMO:channel,pkMO:pkey));
	(!out(yellowpagesEV,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,ID_to_bitstring(idEV)),anonymcred)) |
	out(c,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,ID_to_bitstring(idEV)),m,open,anonymcred)) ).
