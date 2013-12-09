#!/usr/bin/env perl 

use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous'
);

# get slice adaptor
my $sa = $registry->get_adaptor("rat", "core", "slice")||die "ERROR: $!\n";

# get variation feature adaptor
my $vfa = $registry->get_adaptor("rat", "variation", "variationfeature")||die "ERROR: $!\n";

# fetch slice object
my $slice_obj = $sa->fetch_by_region( 'toplevel', 20, 23000000, 23150000 );

# fetch all variation features
my $varfeats = $vfa->fetch_all_by_Slice($slice_obj);

# loop through variation features printing out locations
foreach my $vf_obj(@{$varfeats}){

    print "Variation: ",  $vf_obj->variation_name() ,"\tAlleles: ", $vf_obj->allele_string(), "\tlocation: " , $vf_obj->seq_region_name() ,":", $vf_obj->seq_region_start() ,"-",  $vf_obj->seq_region_end() , "\n";
}
