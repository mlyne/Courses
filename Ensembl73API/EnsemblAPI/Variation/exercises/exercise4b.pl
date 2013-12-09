#!/usr/bin/env perl 

# Find a variant location given a variant name

use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous'
);


my @variation_names = ('rs7107418', 'rs671', 'rs17646946', 'rs4988235');

# get variation adaptor
my $va = $registry->get_adaptor('human', 'variation', 'variation');

foreach my $name (@variation_names) {
  my $variation = $va->fetch_by_name($name);

  # get all variation features for our variation:
  my @vfs = @{$variation->get_all_VariationFeatures()};
  foreach my $vf (@vfs) {
      print "Variation: ", $vf->variation_name, "\tAlleles ", $vf->allele_string,
      "\tlocation: ", $vf->seq_region_name, ":", $vf->seq_region_start, "-", $vf->seq_region_end,"\n";
  }
}
