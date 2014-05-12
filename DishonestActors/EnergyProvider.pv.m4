let dishonestEP(c: channel)=
	in(c,idEP:ID);
	new chEP: channel;
	new skEP: skey;
	(!out(yellowpagesEP,(idEP,chEP,Pk(skEP))) |
	out(c,(idEP,chEP,Pk(skEP))) ).
