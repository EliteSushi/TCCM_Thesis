module load SciPy-bundle/2023.12-iimkl-2023b #load python
for r in 5 6 8 10 12 15 20 30 40; do
	infile=Q0_32_${r}.inp
	cat head.in > $infile
	python3 add_H2O.py -p 0.6797420000000001 -1.2828496666666667 -0.0016993333333333333 -v 2.583358 0.001274 1.876662 -l -$r >> $infile
	cat template.in >> $infile
	qchemjob_H2OScan_NoL.sh $infile #run in vsc wice
done
