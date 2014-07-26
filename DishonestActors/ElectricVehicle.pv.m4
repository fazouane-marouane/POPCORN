(* not needed at all *)
let dishonestEV()=
	new idEV: ID;
	new skEV:skey;
	new chUser:channel;
	new m:bitstring;
	new open: Open;
	in(yellowpagesPH,pkPH: pkey);
	let anonymcred = ObtainSig(pkPH,m,Commit(m,open),open) in
	in(yellowpagesMO,(idMO:ID,chMO:channel,pkMO:pkey));
	(!out(yellowpagesEV,(idEV,chUser,idMO,createContractID(idEV),skEV,GKeygen(gmsk,ID_to_bitstring(idEV)),anonymcred)) |
	out(publicChannel,(idEV,chUser,skEV,GKeygen(gmsk,ID_to_bitstring(idEV)),m,open,anonymcred,idMO,chMO,pkMO,createContractID(idEV))) ).
