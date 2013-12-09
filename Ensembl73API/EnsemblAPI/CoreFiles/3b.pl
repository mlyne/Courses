use strict;
use warnings;
use Bio::EnsEMBL::Registry;

my $registry = "Bio::EnsEMBL::Registry";

$registry->load_registry_from_db( -host => 'ensembldb.ensembl.org', -user => 'anonymous');


my $slice_adaptor = $registry->get_adaptor( 'Human', 'Core', 'Slice' );


# fetch by Gene Stable id with 2Kb of flanking dna
my $slice = $slice_adaptor->fetch_by_gene_stable_id('ENSG00000101266', 2000);

print "Found long slice:  " . $slice->name. " \n" ;

my $short_slice = $slice_adaptor->fetch_by_gene_stable_id('ENSG00000101266');
print "Found short slice: " . $short_slice->name() . "\n";
