#!/usr/bin/perl
use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $reg = "Bio::EnsEMBL::Registry";

$reg->load_registry_from_db(
  -host => 'ensembldb.ensembl.org',
  -user => 'anonymous'
#  -verbose => 1
);

my $va = $reg->get_adaptor('human', 'variation', 'variation');
my $id = "rs1333049";

print "OK... Wait for it...\n\n";

my $var = $va->fetch_by_name("$id");

 print "For id: $id... I found:\n",
 " name: ", $var->name(), "\n",
 " class: ", $var->var_class(), "\n",
 " source: ", $var->source(), "\n\n";

my @genotypes = @{$var->get_all_IndividualGenotypes()};

foreach my $genotype (@genotypes) {
 print "genotype: ", $genotype->genotype_string(), "\n";
}


print "Are you impressed?\n"
