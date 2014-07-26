let dishonestCS(c: channel) =
	in(c,idCS:ID);
	new chCS: channel;
	new skCS: skey;
	in(yellowpagesEP,(idEP:ID,chEP:channel,pkEP:pkey));
	(!out(yellowpagesCS,(idCS,chCS,idEP,Pk(skCS)) ) |
	out(c,(idEP,chEP,pkEP));
	out(c,(idCS,chCS,idEP,skCS)) ).
