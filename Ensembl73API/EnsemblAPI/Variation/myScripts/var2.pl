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

#print "Source: ", $var->source(), "\n",

my @alleles = @{$var->get_all_Alleles()};

print "For id: $id... I found:\n";

foreach my $allele (@alleles) {

 print " allele: ", $allele->allele(), "\n" if $allele->allele();
 print " freq: ", $allele->frequency(), "\n" if $allele->frequency();
 print " pop: ", $allele->population()->name(), "\n" if $allele->population();
 print "  Submit: ", $allele->subsnp_handle(), "\n\n" if $allele->subsnp_handle();
}

print "Are you impressed?\n"
