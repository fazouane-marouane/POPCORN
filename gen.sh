ANALYZER='../../proverif -in pitype'

(
echo POPCORN
for i in SECRECY
do
mkdir Build
mkdir Temp
echo $i
m4 -D$i popcorn.m4 > Temp/prot-popcorn-$i.pv
$PROG $ANALYZER Temp/prot-popcorn-$i.pv > Temp/prot-popcorn-$i.result
egrep '(RESULT|goal reachable)' Temp/prot-popcorn-$i.result
grep system Temp/prot-popcorn-$i.result | grep user

done
) | tee Build/results.txt
