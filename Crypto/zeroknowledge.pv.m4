(* zero knowledge proofs *)

(* I. helper functions/Base theory *)
(* I.1. Pairs and tuples *)
(*
fun pair(bitstring, bitstring): bitstring [data].
reduc forall x:bitstring, y:bitstring; fst(pair(x,y)) = x.
reduc forall x:bitstring, y:bitstring; snd(pair(x,y)) = y.

fun at(bitstring,Nat): bitstring.
*)
(* I.2. Blind signatures. *)
fun blind(bitstring, key): bitstring.
fun unblind(bitstring, key): bitstring.
equation forall x: bitstring, y: skey, z:key; unblind(Sign(blind(x,z),y),z) = Sign(x,y).

(* II. Zero-Knowledge *)
type Formula.
type NPrelation.
type Proof.
type CRefS.

(*
fun NPrelation_from_Formula(Formula): NPrelation [data,typeConverter].
fun ChoiceOperator(NPrelation,bitstring,nonce): bitstring.
fun CommonRefString(NPrelation,nonce): CRefS.
fun ZKProve(CRefS,bitstring,bitstring,nonce): Proof.
*)
(* Perfect Soundness & Perfect Correctness *)
(*reduc forall rel: NPrelation, s1: nonce, s2:nonce, s3: nonce, x:bitstring; Verify(CommonRefString(rel,s1),Prove(c,x,ChoiceOperator(rel,x,s2),s3))=true.*)

(* See:  M. Backes, M. Maffei, and D. Unruh, 2007. Implementation of the compiler from
zero-knowledge protocol descriptions into ProVerif-accepted specifications. Available
at http://www.infsec.cs.uni-sb.de/zk.zip *)