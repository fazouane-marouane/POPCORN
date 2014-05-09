ANALYZER='../../proverif -in pitype'

(
echo POPCORN
for i in SECRECY
do

echo $i
m4 -D$i popcorn.m4 > temp/prot-popcorn-$i.pv
$PROG $ANALYZER temp/prot-popcorn-$i.pv > temp/prot-popcorn-$i.result
egrep '(RESULT|goal reachable)' temp/prot-popcorn-$i.result
grep system temp/prot-popcorn-$i.result | grep user

done
) | tee Build/results.txt
