let dishonestCS() =
	new idCS:ID;
	new chCS: channel;
	new skCS: skey;
	in(yellowpagesEP,(idEP:ID,chEP:channel,pkEP:pkey));
	(!out(yellowpagesCS,(idCS,chCS,idEP,Pk(skCS)) ) |
	out(publicChannel,(idCS,chCS,chEP,pkEP,skCS)) ).
