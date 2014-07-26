let dishonestMO(c: channel)=
	in(c,idMO:ID);
	new chMO: channel;
	new skMO: skey;
	(!out(yellowpagesMO,(idMO,chMO,Pk(skMO))) |
	out(c,(idMO,chMO,skMO)) ).
