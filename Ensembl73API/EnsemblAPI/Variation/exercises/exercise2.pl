#!/usr/bin/env perl

use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $reg = 'Bio::EnsEMBL::Registry';

$reg->load_registry_from_db(
  -host => 'ensembldb.ensembl.org',
  -user => 'anonymous'
);

# get a variation adaptor
my $v_adaptor = $reg->get_adaptor("human", "variation", "variation");

# fetch the variation by name
my $variation = $v_adaptor->fetch_by_name('rs1333049');

# get all the alleles
my @alleles = @{$variation->get_all_Alleles()};

print "# rsID\tAllele\tFreq\tPopulation\tSubmitter\n";
foreach my $allele(@alleles) {
  print
    $variation->name, "\t",
    $allele->allele, "\t",
    (defined($allele->frequency) ? $allele->frequency : "-"), "\t",
    (defined($allele->population) ? $allele->population->name : "-"), "\t",
    (defined($allele->subsnp_handle) ? $allele->subsnp_handle : "-"), "\n";
}
