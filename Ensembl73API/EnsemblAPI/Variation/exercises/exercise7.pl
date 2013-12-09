#!/usr/local/bin/perl
use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $reg = 'Bio::EnsEMBL::Registry';

$reg->load_registry_from_db(
  -host => 'ensembldb.ensembl.org',
  -user => 'anonymous'
);

# get ld adaptor
my $lda = $reg->get_adaptor("human", "variation", "ldfeaturecontainer");

# get slice adaptor
my $sa = $reg->get_adaptor("human", "core", "slice");

# get population adaptor
my $pa = $reg->get_adaptor("human", "variation", "population");

# get the slice
my $slice = $sa->fetch_by_region("chromosome", 9, 22124000, 22126000);

# get the population
my $pop = $pa->fetch_by_name("1000GENOMES:phase_1_GBR");
print "Number of individuals in the population: ",$pop->size,"\n\n";

# get the container
my $ldc = $lda->fetch_by_Slice($slice, $pop);

foreach my $hash(@{$ldc->get_all_ld_values()}) {
  next unless $hash->{r2} == 1;
  
  print $hash->{variation1}->variation_name, "-",
        $hash->{variation2}->variation_name, ":\t\t",
        "r2 = ", $hash->{r2}, ", ",
        "d_prime = ", $hash->{d_prime}, "\n";
}
