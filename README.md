# AreaSonic2
Estimation of the significance of an overlap between two whole genome sets of regions with respect to a third one, by Monte Carlo simulation and normal distribution modeling
# Description
AreaSonic2 program estimates the significance (P-value) of a total overlap between two sets of while-genome regions (tracks) with respect to a third track. All three tracks conventianally are described in BED format. As an option for RNA-seq data analysis where three tracks are peaks and promoters of differentially expressed genes (DEGs) and the rest genes, AreaSonic2 takes as input data a BED files for peaks and promoters of all genomes (with an obligatory column of gene ID) and a list IDs for DEGs. The one of the pillars of probability theory, [Central limit theorem](https://en.wikipedia.org/wiki/Central_limit_theorem) proves that the overlap between two tracks should possess the normal distribution due to (a) large number of iterations in Monte Carlo simulation and (b) large counts of regions in both tracks. AreaSonic2 fits a normal model of the total overlap length, and applies Monte Carlo simulation to estimate the distribution of expected overlap length. AreaSonic2 takes into account and perfectly models both the distributions of lengths of tracks regions and those of spacers lengths between regions. 
AreaSonic2 assigns to the first track the label 'fixed', while the second and third ones are marked as 'permuted'. Next, AreaSonic2 combines the first and the second tracks, and the first and the third ones, applying the approach of [AreaSonic](https://github.com/parthian-sterlet/AreaSonic), see Scheme 1 below. Below we consider the pair first/second. At first step, the observed value 'Real' of total overlap length between two tracks is computed (see Step #1 in 1st scheme below). Now, the first iteration is started: regions and spacers between them for the permuted track are indexed, this gives two arrays {Regions} and {Spacers} (Step #2); indices of each array are swapped (Step #3), and chimeric sequence of regions and spacers is assembled (Step #4); thus, an estimate of the overlap length between the fixed and permuted track is computed at the end of the first itatation (Step #5). Next, hundreeds or thousand iterations are performed (Step #6). These iterations estimate the expected overlap length 'Av' and its standard deviation 'SD' (Step #7). These values are used to compute Z-score estimate as follows: Z-score = (Real - Av) / SD. Positive/negative Z-score imply the enrichment/depletion in the total overlap length between two tracks. Finally, for extremly large Z-scores (Z-score > 14) the asymptotic expansion of the [complementary error function](https://en.wikipedia.org/wiki/Error_function) is used to compute P-value, otherwise it computed directly as the integral for the stadard normal distribution (Step #8). 

Scheme 1 of AreaSonic2 algorithm, permutation algorithm for a pair of tracks
![scheme](https://github.com/parthian-sterlet/AreaSonic2/blob/main/examples/AreaSonic21_github.png)

Thus, for two pairs of tracks, first/second and first/third, two overlap lengths, two expected overlap lengths, two standard deviations, two Z-scores and two p-values are computed (Real12 and Real13, Av12 and Av13, σ12 and σ13, Z-score12 and Z-score13,  p-value12 and p-value13), and three total lengths of tracks L1, L2 and L3. We should check the hypothesis that ratios between (a) the deviations of the overlap length Real12 and Real13 and from their expectations Av12 and Av13, and (b) the total length of tracks L2 and L3, are equal, see Scheme 2 below. Therefore, we check 

Z-score = {(Real12 - Av12) / L2 - (Real13 - Av13) / L3} / SQRT{(σ12 * σ12) / (L2 * L2) + (σ13 * σ13) / (L3 * L3)}. 

This value allow to compute the final significance of the overlap of the second and third track woth respect to the first track, p-value. It is computed through the calculation of integral or for the large Z-scores with the asypmtoptic approximation, as described above.

Scheme 2 of AreaSonic2 algorithm, combination of three tracks: test of the significance of two track with respect to another track
![scheme](https://github.com/parthian-sterlet/AreaSonic2/blob/main/examples/AreaSonic22_github.png)

The Areasonic2 program is based on the [AreaSonic](https://github.com/parthian-sterlet/AreaSonic) algorithm that was successively applied earlier in [Khoroshko et al. (2016)](https://doi.org/10.1371/journal.pone.0157147) and [Boldyreva et al. (2017)](https://www.researchgate.net/publication/303295899_Protein_and_Genetic_Composition_of_Four_Chromatin_Types_in_Drosophila_melanogaster_Cell_Lines). Another motivation for AreaSonic2 tool came from the [CisCross](https://plamorph.sysbio.ru/ciscross/) tool, which aimed to reveal the enriched profile of DAP-seq/ChIP-seq peaks significantly enriched in promoters of DEGs compared to the promoters of the rest genes.

# Requirements
AreaSonic2 source code is written in C++ language. To compile exetubables from the source code you need:

* In Linux system, C++ compiler, e.g. [GCC](https://gcc.gnu.org/) compiler 
* In Windiws system any VC++ package, e.g. [Microsoft Visual Studio Community](https://visualstudio.microsoft.com/vs/community/)

# Input data
Input data include two tracks in [BED format](https://genome.ucsc.edu/FAQ/FAQformat.html#format1). First three columns in a track file are critically important, they represent a chromosome name and left/right positions of genomic regions. Note that regions in a BED file are presumed to be sorted in the ascending order of positions, the overlaps between neighbor regions are forbidden. Two input text files for the list of chromosome names and their lengths are required too, see their ready examples for D. melanogaster (dm5), A. thaliana (at10), M. musculus (mm10) and H. sapiens (hg38) genomes in [src](https://github.com/parthian-sterlet/AreaSonic/tree/main/src) folder, e.g. [chr_name_dm.txt](https://github.com/parthian-sterlet/AreaSonic2/blob/main/src/chr_name_dm.txt) and [chr_length_dm5.txt](https://github.com/parthian-sterlet/AreaSonic2/blob/main/src/chr_length_dm5.txt)

# Source code
Folder [**src**](https://github.com/parthian-sterlet/areasonic2/tree/master/src) contains files with AreaSonic2 source codes, they respect to decribed below separate modules of pipeline.

# How to compile
* In Linux system: 

git clone https://github.com/parthian-sterlet/areasonic2 \
cd areasonic2\src\
chmod a+x build.sh\
./build.sh

* In Windiws system:

separate compilation of all source files in VC++

Modules **Partition of a genome track by separate chromosomes** and **Permutations** should run consequently if input files are given as whole-genome track, if they are already partitioned by chromosomes, the second module **Permutations** can be used alone

# How to run separate modules
Lists of command line arguments for all modules are described below

## 1. Partition of a genome track by separate chromosomes
This is a parsing of a bed formatted file according to values in the first column designating chromosome names. For subsequent separate files for all chromosomes are required
[tabnslolbik_wordget.cpp](https://github.com/parthian-sterlet/areasonic/blob/master/src/tabnslolbik_wordget.cpp)

Command line arguments:
1. input file, text table
2. output file, processed text table
3. int number of criteria
4. int list of columns numbers, comma separated 
5. char list of words respecting columns 
6. int match type: 1 exact coincidence (word in a column exactly equal to given input word), 0 only occurrence (substring in a string is enough)
7. int contain type: 0/1 mean searches of lines containing / do not containing words 
8. int logic: 1 means stringent requirement for criteria in all columns, 0 means mild requirement for only one of criteria in at least one of columns

## 2. Permutations
The main part of algorithm performing Monte Carlo simulation, three tracks in BED format
[area_shuffling_pair_bed.cpp](https://github.com/parthian-sterlet/areasonic2/blob/master/src/area_shuffling_pair_bed.cpp)

Command line arguments:
1. input file in BED format, permuted track 
2. input file, the list of chromosome lengths 
3. input file, list of chromosome names
4. input file in BED format, fixed track, test
5. input file in BED format, fixed track, control
6. integer number of iterations, minimal 100, at least 500 is required for stable results
7. output file, statistical estimates for the overlap length between two tracks
8. output file, distribution of expected overlap length 

The main part of algorithm performing Monte Carlo simulation, one track in BED format, promoters of whole genome promoters with gene IDs, list of gene IDs for DEGs 
[area_shuffling_pair_bed.cpp](https://github.com/parthian-sterlet/areasonic2/blob/master/src/area_shuffling_pair.cpp)

Command line arguments:
1. input file in BED format, permuted track 
2. input file, the list of chromosome lengths 
3. input file, list of chromosome names
4. input file in BED format, fixed track, promoters with gene IDs, BED format
5. input file in BED format, fixed track, list of gene IDs for DEGs
6. integer number of iterations, minimal 100, at least 500 is required for stable results
7. output file, statistical estimates for the overlap length between two tracks
8. output file, distribution of expected overlap length 

Perl script file [test.pl](https://github.com/parthian-sterlet/AreaSonic/blob/main/src/test.pl) shows the example runs of AreaSonic for two tracks: (1) domains of active aquamarine D.melanogaster chromatin from the [HMM model from Boldyreva et al. (2017)](https://www.researchgate.net/publication/303295899_Protein_and_Genetic_Composition_of_Four_Chromatin_Types_in_Drosophila_melanogaster_Cell_Lines) and (2) peaks of Chriz/Chromator protein from [GSM1147251](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM1147251). Example presents two runs of programs alternatively using first and second tracks as the permuted one. The output file from 6-th command line argument [as.dist](https://github.com/parthian-sterlet/AreaSonic/blob/main/examples/as.dist) shows the expected distribution for the total overlap length between fixed and permuted tracks. The output file from 5-th command line argument [as.txt](https://github.com/parthian-sterlet/AreaSonic/blob/main/examples/as.txt) lists calculation results as follows.

 Label                | Value                          | Meaning |
|----------------------|--------------------------------|---------|
| AreaVar              | EIN3_Chang  1230 275.513               | Permuted track (first): file name, total number of regions, total length of regions in bp
| AreaConst1           | DHS_Ath_seedling_normal 36064 5465.344 | Fixed track (second): file name, total number of regions, total length of regions in bp
| AreaConst2           | DHS_Ath_root_normal 62804 9558.864     | Fixed track (third): file name, total number of regions, total length of regions in bp
| Ncyc                 | 5000 5000                              | Number of iterations between the first and second tracks, and between the first and third tracks
| Real                 | 98.463 85.477                          | Real12, Real13 Observed overlap length between the first and second, the first and third tracks, in kbp (1000 bp)
| Av                   | 12.592590 22.001664                    | Av12, Av13 Average expected overlap length between the first and second, the first and third tracks, in kbp (1000 bp)
| SD                   | 1.221718 1.559410                      | Standard deviation of expected overlap length, the first and second, the first and third tracks, in kbp (1000 bp)
| Z                    | 70.286589 40.704702                    | Z12, Z13 Z-scores of expected overlap length, between the first and second tracks, and the first and third tracks, positive/negative Z-score implies the enrichment/depletion in the total overlap length
| -Log10[Pval]         | 1074.7 361.494                         | P-value in logarithmic scale, estimation of the significance for the total overlap length between first and second tracks, and between the first and third tracks
| Av                   | 0.015712 0.006640                      | Ratios between (a) the deviations of the overlap length Real12 and Real13 and from their expectations Av12 and Av13, and (b) the total length of tracks L2 and L3, are equal
| SD                   | 0.000277                               | Standard deviation of expected overlap length, in kbp (1000 bp)
| Z                    | 32.779568                              | Z-score of expected overlap length, Z-score12 = (Real12 - Av12) / SD12, positive/negative Z-score implies the enrichment/depletion in the total overlap length between first and third tracks
| -Log10[Pval]         | 234.94                                 | P-value in logarithmic scale, estimation of the significance for the total overlap length between second and third tracks, with respect to first track
