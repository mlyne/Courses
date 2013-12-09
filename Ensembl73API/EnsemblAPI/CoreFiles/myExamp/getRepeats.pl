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
my $rf_adaptor    = $registry->get_adaptor( 'Human', 'Core', 'RepeatFeature' );

my $region = $slice_adaptor->fetch_by_region('chromosome', '20', '1', '5e5');
my @repeats = @{ $rf_adaptor->fetch_all_by_Slice($region) };

print "Extracting your region: \n",
"Coord system:\t", $region->coord_system_name, "\n",
"Seq region:\t", $region->seq_region_name, "\n",
"Start:\t\t", $region->start,"\n",
"End:\t\t", $region->end,"\n",
"Strand:\t\t", $region->strand,"\n",
"Slice:\t\t", $region->name, "\n\n";

my @repeat_by_slice =@{ $region->get_all_RepeatFeatures() };

foreach my $rep ( @repeat_by_slice ) {
    printf( "%s %d-%d\n",
        $rep->display_id(), $rep->start(), $rep->end() );
}

print "Please wait one moment. Just extracting your repeats: \n";

foreach my $repeat ( @repeats ) {
 print 
 "\nID:\t", $repeat->display_id, "\n",
 "Coord system:\t", $repeat->coord_system_name, "\n",
 "Seq region:\t", $repeat->seq_region_name, "\n",
 "Consensus:\t", $repeat->seq_region_name, "\n",
 "Start:\t\t", $repeat->start,"\n",
 "End:\t\t", $repeat->end,"\n",
 "Slice:\t\t", $region->name, "\n";
}

#my $output = Bio::SeqIO->new( -file=>'>chr20_10mb.fasta',
# -format=>'Fasta');
#$output->write_seq($region);

