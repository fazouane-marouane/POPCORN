ANALYZER='../../proverif -in pitype'

(
echo ">>>>" POPCORN "<<<<"
# SECRECY ANONYMITY STRONG_SECRECY OFFLINE_GUESSING UNLINKABILITY 
for i in CORRESPONDANCE
do
mkdir -p Build
mkdir -p Temp
echo "*" $i
m4 -D$i popcorn.pv.m4 > Temp/prot-popcorn-$i.pv
$PROG $ANALYZER Temp/prot-popcorn-$i.pv > Temp/prot-popcorn-$i.result
egrep '(RESULT|goal reachable)' Temp/prot-popcorn-$i.result
grep system Temp/prot-popcorn-$i.result | grep user

done
) | tee Build/results.txt
