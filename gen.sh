ANALYZER='../../proverif -in pitype'
# SECRECY ANONYMITY STRONG_SECRECY OFFLINE_GUESSING CORRESPONDANCE UNLINKABILITY
# SECRECY1 SECRECY2 ANONYMITY STRONG_SECRECY1 STRONG_SECRECY2 OFFLINE_GUESSING CORRESPONDANCE UNLINKABILITY1 UNLINKABILITY2
# SECRECY1 STRONG_SECRECY1 CORRESPONDANCE
(
echo ">>>>" POPCORN "<<<<"
for i in OFFLINE_GUESSING
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
