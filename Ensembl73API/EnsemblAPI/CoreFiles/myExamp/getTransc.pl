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

my $gene_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Gene' );
my $gene = $gene_adaptor->fetch_by_display_label('CSNK2A1');

# print out the gene, its transcripts, and its exons
print "Gene: ", get_string($gene), "\n";

print "How many transcripts? ", scalar( @{ $gene->get_all_Transcripts } ), "\n";

my $count;

foreach my $transcript (@{ $gene->get_all_Transcripts }) {
 print "\n Transcript: ", get_string($transcript), "\n";
 my $translation = $transcript->translation;

 if ($translation) {
   print "  Has a Translation...\n";
   $count++;
 } else { 
   print "  No Translation!\n";
 }

print " has ", scalar( @{ $transcript->get_all_Exons } ), " exons:\n";
 foreach my $exon (@{ $transcript->get_all_Exons }) {
#  print "Exon: ", get_string($exon), "\n";
 }
}

print "\nTotal translations: ", $count, "\n";

### subs ###
# helper function: returns location and stable_id string for a feature
sub get_string {
 my $feature = shift;
 my $stable_id = $feature->stable_id;
 my $seq_region = $feature->slice->seq_region_name;
 my $start = $feature->start;
 my $end = $feature->end;
 my $strand = $feature->strand;
 return "$stable_id $seq_region:$start-$end($strand)";
}
