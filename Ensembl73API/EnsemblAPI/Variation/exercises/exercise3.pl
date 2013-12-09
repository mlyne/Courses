#!/usr/bin/env perl 

use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous'
);

# get variation adaptor
my $va = $registry->get_adaptor("human", "variation", "variation")||die "ERROR: $!\n";

# fetch variation object
my $var_obj = $va->fetch_by_name('rs1333049');

# fetch all genotypes
my $genos = $var_obj->get_all_IndividualGenotypes();

foreach my $gen_obj(@{$genos}){
   
    print "Genotype=" ,  $gen_obj->genotype_string() , 
    "\tIndividual=", $gen_obj->individual()->name() , 
    " (" .  $gen_obj->individual()->gender() ,")\t" ;

    print $gen_obj->subsnp_handle() if defined $gen_obj->subsnp_handle();
    print "\n";
}
