(* Anonymous credentials *)
type Open.
type Commitment.
type Proof.

fun Commit(bitstring,Open): Commitment.
fun Prove(pkey, bitstring, bitstring): Proof.
fun EqCommProve(bitstring,Open,Open): Proof.
fun ObtainSig(pkey,bitstring,Commitment,Open): bitstring [private].
fun VerifyEqComm(Commitment,Commitment,Proof): bool.
equation forall sk: skey, m: bitstring, open: Open; ObtainSig(Pk(sk), m, Commit(m,open), open)= Sign(m,sk).
reduc forall pk:pkey, m: bitstring, open: Open; VerifyProof(pk,Commit(m,open),Prove(pk,m,ObtainSig(pk,m,Commit(m,open),open)))= true.
equation forall m: bitstring, open1: Open, open2: Open; VerifyEqComm(Commit(m,open1),Commit(m,open2),EqCommProve(m,open1,open2))= true.
equation forall m: bitstring, open1: Open, open2: Open; VerifyEqComm(Commit(m,open1),Commit(m,open2),EqCommProve(m,open2,open1))= true.


(* trash*)
type ContractID.
fun createContractID(ID): ContractID [data, typeConverter].

type credInfo. (* the standard credentials*)
fun createValidCred(ID,bitstring): credInfo [private]. (* only the system can generate valid standard credentials. The second argument is just a random nonce *)

type anonymousCred.
fun createAnonymousCred(ID,credInfo): anonymousCred. (* That`''s probably not the way anonymous credentials work *)
reduc forall m:bitstring, id_:ID; verifyCred(createAnonymousCred(id_,createValidCred(id_,m))) = m.
