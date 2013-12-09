#!/usr/bin/env perl 

use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous'
);

# get adaptors
my $va = $registry->get_adaptor("human", "variation", "variation")||die "ERROR: $!\n";
my $pa = $registry->get_adaptor("human", "variation", "publication")||die "ERROR: $!\n";


foreach my $name(qw[ rs2234693   rs3730070 ] ){

    # get the variation object 
    my $var_obj = $va->fetch_by_name($name);

    # find all publications citing this variant
    my $publications = $pa->fetch_all_by_Variation($var_obj);
    foreach my $pub_obj(@{$publications}){

	print "$name\tPMID=" ,  $pub_obj->pmid() ,"\tyear=", $pub_obj->year() , " title=" , $pub_obj->title() ,"\n";
    }
}
