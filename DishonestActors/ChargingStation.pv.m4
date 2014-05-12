let dishonestCS(c: channel) =
	in(c,idCS:ID);
	new chCS: channel;
	new skCS: skey;
	get EPTable(idEP,chEP,pkEP) in
	insert CSTable(idCS,chCS,idEP,Pk(skCS));
	out(c,(idEP,chEP,pkEP));
	out(c,(idCS,chCS,idEP,Pk(skCS))).
