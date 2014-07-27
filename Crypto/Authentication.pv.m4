(* Secure session establishment *)

(* I. Unilateral authetication*)

(* I.1. Client side authentication *)
let authClient_unilateral(server:channel, pkServer:pkey, callback:channel) =
	new k:bitstring;
	new privateCh:channel;
	new skClient: skey;
	out(server, aenc(Sign((privateCh,k,Pk(skClient)),skClient),pkServer));
	in(privateCh,m:bitstring);
	if CheckSign(m,pkServer) then
	if k= adec(RecoverData(m),skClient) then
	out(callback,privateCh). (*else authentication failed*)

(* I.2. Server side authentication*)
let authServer_unilateral(server:channel, skServer:skey, callback:channel) =
	in(server, m:bitstring);
	let signed=adec(m,skServer) in
	let (privateCh:channel, k:bitstring,pkClient: pkey) = RecoverData(signed) in
	if CheckSign(signed,pkClient) then
	out(privateCh, Sign(aenc(k,pkClient),skServer));
	out(callback, privateCh).


(* II. Bilateral authentication*)

(* II.1. Client side authentication *)
let authClient_bilateral(server:channel, skClient:skey, pkServer:pkey, callback:channel) =
	new k:bitstring;
	new privateCh:channel;
	out(server,Sign((privateCh,k),skClient));
	in(privateCh,m:bitstring);
	if CheckSign(m,pkServer) then out(callback,privateCh).

(* II.2. Server side authentication*)
let authServer_bilateral(server:channel, skServer:skey, pkClient:pkey, callback:channel) =
	in(server, m:bitstring);
	if CheckSign(m,pkClient) then
	let (privateCh:channel, k:bitstring) = RecoverData(m) in
	out(privateCh, Sign(k,skServer));
	out(callback, privateCh).
