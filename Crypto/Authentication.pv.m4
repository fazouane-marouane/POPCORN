(* Secure session establishment *)

(* I. Unilateral authetication*)

(* I.1. Client side authentication *)
define(`authClient_unilateral',
	`new authClient_unilateral_k:bitstring;
	new $3:channel;
	new authClient_unilateral_skClient: skey;
	out($1, aenc(Sign(($3,authClient_unilateral_k,Pk(authClient_unilateral_skClient)),authClient_unilateral_skClient),$2));
	in($3,authClient_unilateral_m:bitstring);
	if CheckSign(authClient_unilateral_m,$2) then
	if authClient_unilateral_k= adec(RecoverData(authClient_unilateral_m),authClient_unilateral_skClient) then')

(* I.2. Server side authentication*)
define(`authServer_unilateral',
	`in($1, authClient_unilateral_m:bitstring);
	let authClient_unilateral_signed=adec(authClient_unilateral_m,$2) in
	let ($3:channel, authClient_unilateral_k:bitstring,authClient_unilateral_pkClient: pkey) = RecoverData(authClient_unilateral_signed) in
	if CheckSign(authClient_unilateral_signed,authClient_unilateral_pkClient) then
	out($3, Sign(aenc(authClient_unilateral_k,authClient_unilateral_pkClient),$2))')

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
