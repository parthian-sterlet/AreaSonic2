#!/usr/bin/perl
use 5.8.1; use strict; use warnings;

my ($cmd, $i, $file1, $file2, $file3, $file_out_txt, $file_out_dist, $iter, $genome, $nchr, $ext_len, $ext_nam);

$file1           =$ARGV[0];  #track 1
$file2           =$ARGV[1];  #track 2
$file3           =$ARGV[2];  #track 3
$genome          =$ARGV[3];  #genome mm, hg, at, dm
$iter            =$ARGV[4];  #number of iterations
$file_out_txt    =$ARGV[5];  #output file text
$file_out_dist   =$ARGV[6];  #output file distribution

my @chr_here;
my @chr_at = ('1', '2','3','4', '5');
my @chr_dm = ('2R', '2L','3R', '3L', 'X');
my @chr_hg = ('1', '2','3','4','5','6', '7','8','9','10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', 'X', 'Y');
my @chr_mm = ('1', '2','3','4','5','6', '7','8','9','10', '11', '12', '13', '14', '15', '16', '17', '18', '19', 'X', 'Y');

if($genome eq 'dm' || $genome eq 'DM') {
$nchr =5;
@chr_here = @chr_dm;
$ext_len = 'dm5', $ext_nam ='dm';
}

if($genome eq 'at' || $genome eq 'AT') {
$nchr =5;
@chr_here = @chr_mm;
$ext_len = 'at10', $ext_nam ='at';
}

if($genome eq 'hg' || $genome eq 'HG') {
$nchr =24;
@chr_here = @chr_mm;
$ext_len = 'hg38', $ext_nam ='hg';
}

if($genome eq 'mm' || $genome eq 'MM') {
$nchr =21;
@chr_here = @chr_mm;
$ext_len = 'mm10', $ext_nam ='mm';
}

for($i=0;$i<$nchr;$i++) {

$cmd= "./tabnslolbik_wordget.exe	${file1}.bed	${file1}_chr${chr_here[$i]}.bed	1	1	chr${chr_here[$i]}	1 1 1";
print "$cmd\n";
system $cmd;

$cmd= "./tabnslolbik_wordget.exe	${file2}.bed	${file2}_chr${chr_here[$i]}.bed	1	1	chr${chr_here[$i]}	1 1 1";
print "$cmd\n";
system $cmd;
}

$cmd= "./area_shuffling_pair_bed.exe	${file1}	chr_length_${ext_len}.txt	chr_name_${ext_nam}.txt	${file2}	${file3}	${iter}	${file_out_txt}	${file_out_dist}";
print "$cmd\n";
system $cmd;

$cmd= "./area_shuffling_pair_bed.exe	${file1}	chr_length_${ext_len}.txt	chr_name_${ext_nam}.txt	${file3}	${file2}	${iter}	${file_out_txt}	${file_out_dist}";
print "$cmd\n";
system $cmd;
