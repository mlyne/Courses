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
my $string = "rs55710239,rs56385407,COSM998,CI003207";

my @ids = split(",", $string);

print "OK... Wait for it...\n\n";

foreach my $id (@ids) {
 my $var = $va->fetch_by_name("$id");

 print "For id: $id... I found:\n",
 " name: ", $var->name(), "\n",
 " class: ", $var->var_class(), "\n",
 " source: ", $var->source(), "\n\n",
}

print "Are you impressed?\n"
