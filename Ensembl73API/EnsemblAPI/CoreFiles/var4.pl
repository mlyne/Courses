#!/usr/bin/perl

use strict;
use warnings;
use Bio::EnsEMBL::Registry;

my $registry = "Bio::EnsEMBL::Registry";

$registry->load_registry_from_db( -host => 'ensembldb.ensembl.org', -user => 'anonymous');
my $slice_adaptor = $registry->get_adaptor("rat", "core", "slice");

# get repeat features for part of chr20
my $slice = $slice_adaptor->fetch_by_region('chromosome', 20, 23000000, 23150000);
my @vars = @{ $slice->get_all_VariationFeatures };

foreach my $var (@vars) {
#  print $var->display_id, "\n";

  print "Variation: ",  $var->variation_name() ,"\tAlleles: ", $var->allele_string(), "\tlocation: " , $var->seq_region_name() ,":", $var->seq_region_start() ,"-",  $var->seq_region_end() , "\n";

#  my @alleles = @{$var->get_all_Alleles()};

#  foreach my $allele (@alleles) {
#   print " allele: ", $allele->allele_string(), "\n" if $allele->allele();
#  }
}




