# Figure 1

The first script included results of Figure 1B and Figure 6D (Plate trace results)
```bash
Rscript script/Figure1_B.R
```
The first script included results of Figure 1C and Figure 6E (Plate trace results)

```bash
# Figure 1B and 6D
## ready the data
bash script/Figure1_C.sh
## Plot
Rscript script/Figure1_C.R


# Figure 1C and 6E
## Ready the data and plot the chaining map
python script/Figure1_D.py
## for box plot for replicates
Rscript script/Figure1_D.R


# Figure 1F, Paired no head files courtship map
python script/Figure1_F.py


# Figure 1G, Paired no head files courtship; bar plots
## This script if for generate all paired flies infor
python script/Figure1_G.py
## after the script above is down, make the statistic and plot
Rscript script/Figure1_G.R
```

# Figure 2

```bash
#Figure 2A
Rscript script/Figure2_A.R


#Figure 2B
python script/Figure2_B.py


#Figure 2C
Rscript script/Figure2_C.R
```

# Figure S2A

All scripts and original figures are in directory `Figure3`.

```r
Rscript script/FigureS2_A.R
```
