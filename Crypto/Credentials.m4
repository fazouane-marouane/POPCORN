(* Anonymous credentials *)
type ContractID.
fun createContractID(ID): ContractID [data, dataConverter].

type credInfo. (* the standard credentials*)
fun createValidCred(ID,bitstring): credInfo [private]. (* only the system can generate valid standard credentials. The second argument is just a random nonce *)

type anonymousCred.
fun createAnonymousCred(ID,credInfo): anonymousCred. (* That`''s probably not the way anonymous credentials work *)
reduc forall m:bitstring, id_:ID; verifyCred(createAnonymousCred(id_,createValidCred(id_,m))) = m.
