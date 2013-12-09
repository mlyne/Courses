#!/usr/bin/env perl 

# find phenotype information for a variant

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

# get population adaptor
my $pa = $registry->get_adaptor("human", "variation", "population")||die "ERROR: $!\n";

# fetch variation object 
my $var_name = "rs11765954";
my $var_obj = $va->fetch_by_name( $var_name );

#get phenotype features for the variation
my $phenofeats = $var_obj->get_all_PhenotypeFeatures();

# loop through the phenotype features printing out required information
foreach my $pf_obj (@{$phenofeats}){

    print "Phenotype: ", $pf_obj->phenotype()->description() ;
    print "\tp-value: ", $pf_obj->p_value()  if defined $pf_obj->p_value();
    print "risk allele:\t", $pf_obj->risk_allele() if defined $pf_obj->risk_allele();
    print "\n";
    
    if(defined $pf_obj->risk_allele()){

	print "\nAllele frequency for risk allele:\n";
	# get allele objects
	my $als =  $var_obj->get_all_Alleles();
	foreach my $al_obj (@{$als}){

	    # filter for required allele
	    next unless $al_obj->allele() eq $pf_obj->risk_allele();

	    # filter for required population
	    next unless defined $al_obj->population() && $al_obj->population()->name() =~/1000/;

	    print $al_obj->allele(), "\t", $al_obj->frequency(), "\t", $al_obj->population()->name(), "\n";
	}	    
    }
}
