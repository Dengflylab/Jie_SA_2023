for ii in $(awk -F, '{print $1}' data/Group_list2.csv| sort | uniq| tail -10); do
	  for  i in $(grep -w $ii data/Group_list2.csv| awk -F\, '{print $3}');do
			File=$(ls data/csv/*| grep -w $i.csv);
			FLY=$(grep " 0 " $File|wc -l);
			CH=$(grep " 3 " $File|wc -l);
			FW=$(grep " 4 " $File|wc -l);
			TC=$(grep " 5 " $File|wc -l);
			RESULT_C=$(echo 10000\*$CH/$FLY|bc);
			RESULT_F=$(echo 10000\*$FW/$FLY|bc);
			RESULT_T=$(echo 10000\*$TC/$FLY|bc);
			echo $ii $File $RESULT_C $RESULT_F $RESULT_T
		done;done  > data/Beha.csv &