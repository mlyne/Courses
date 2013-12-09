#!/usr/bin/perl
use strict;
use warnings;
use Bio::EnsEMBL::Registry;
use Bio::SeqIO;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
-host => 'ensembldb.ensembl.org',
-user => 'anonymous'
#-verbose => '1'
);

my $slice_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Slice' );
my $chrom_ref = $slice_adaptor->fetch_all('chromosome');
my @chroms = @{$chrom_ref};

print "There are ", scalar(@chroms), " chromosomes\n";

foreach my $chrom (@chroms) {
 print 
"Chrom:\t", $chrom->seq_region_name, "\tLength: ", $chrom->end,"\n";
}

my $slc = $slice_adaptor->fetch_by_gene_stable_id('ENSG00000101266', 2000);

print "\nHere's some stuff on your Gene: ENSG00000101266\n",
"chrom:\t", $slc->coord_system_name, " ", $slc->seq_region_name, "\n",
"Start:\t\t", $slc->start,"\n",
"End:\t\t", $slc->end,"\n",
"Strand:\t\t", $slc->strand,"\n",
"Slice:\t\t", $slc->name, "\n";

my $region = $slice_adaptor->fetch_by_region('chromosome', '20', '1', '1e6');

print "\nFile: chr20_10mb.fasta\tJust saving your sequence: \n",
"Coord system:\t", $region->coord_system_name, "\n",
"Seq region:\t", $region->seq_region_name, "\n",
"Start:\t\t", $region->start,"\n",
"End:\t\t", $region->end,"\n",
"Strand:\t\t", $region->strand,"\n",
"Slice:\t\t", $region->name, "\n",
"Please wait one moment... \n";

my $output = Bio::SeqIO->new( -file=>'>chr20_10mb.fasta',
 -format=>'Fasta');
$output->write_seq($region);


#"Seq region:\t", $slice->seq_region_name, "\n"
