let dishonestCS() =
	new idCS:ID;
	new chCS: channel;
	new skCS: skey;
	in(yellowpagesEP,(idEP:ID,chEP:channel,pkEP:pkey));
	(!out(yellowpagesCS,(idCS,chCS,idEP,Pk(skCS)) ) |
	out(publicChannel,(idEP,chEP,pkEP));
	out(publicChannel,(idCS,chCS,idEP,skCS)) ).
