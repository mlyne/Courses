#!/usr/bin/env perl 

## extract all association data for a variant regardless of significance

use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous'
);

#get variation adaptor
my $va = $registry->get_adaptor('human', 'variation', 'variation'); 
# Extract all association data
$va->db->include_non_significant_phenotype_associations(1);

# get population adaptor
my $pa = $registry->get_adaptor("human", "variation", "population")||die "ERROR: $!\n";

# fetch variation object 
foreach my $var_name ( qw[rs10209020 rs1052373]){

    print "\nReporting $var_name\n";
    my $var_obj = $va->fetch_by_name( $var_name );
    
    #get phenotype features for the variation
    my $phenofeats = $var_obj->get_all_PhenotypeFeatures();
    
    # loop through the phenotype features printing out required information
    foreach my $pf_obj (@{$phenofeats}){
	
	print "Phenotype: ", $pf_obj->phenotype()->description(),
	"\tis_significant:", $pf_obj->is_significant();
	print "\tp-value: ", $pf_obj->p_value()  if defined $pf_obj->p_value();
	print "\trisk allele:\t", $pf_obj->risk_allele() if defined $pf_obj->risk_allele();
	print "\n";
    }
}
