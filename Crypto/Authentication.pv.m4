(* Client side authentication *)
let authClient(server:channel, skClient:skey, pkServer:pkey, callback:channel) =
	new k:nonce;
	new privateCh:channel;
	out(server,Sign((privateCh,k),skClient));
	in(privateCh,m:bitstring);
	if CheckSign(m,pkServer) then out(callback,privateCh).

(* Server side authentication*)
let authServer(server:channel, skServer:skey, pkClient:pkey, callback:channel) =
	in(server, m:bitstring);
	if CheckSign(m,pkClient) then
	let (privateCh:channel, k:bitstring) = RecoverData(m) in
	out(privateCh, Sign(k,skServer));
	out(callback, privateCh).
