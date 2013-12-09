#!/usr/bin/env perl 

use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous'
);
# get transcript adaptor from core database
my $tra = $registry->get_adaptor("human", "core", "transcript")||die "ERROR: $!\n";

# get transcriptvariation adaptor
my $tva = $registry->get_adaptor("human", "variation", "transcriptvariation")||die "ERROR: $!\n";

my $name = "ENST00000001008";

# get transcript object
my $tran_obj = $tra->fetch_by_stable_id($name);

# get all transcript variations
my $tvs = $tva->fetch_all_by_Transcripts([$tran_obj]);

# loop through transcript variation objects printing out required information
foreach my $tv_obj (@{$tvs }){
    
    my $variation_name     = $tv_obj->variation_feature->variation_name;
    my $consequence_term   = $tv_obj->display_consequence;
    my $amino_acid_change  = $tv_obj->pep_allele_string || '-';
    my $cdna_coords        = (defined $tv_obj->cdna_start) ? $tv_obj->cdna_start.'-'.$tv_obj->cdna_end : '-';
    my $translation_coords = (defined $tv_obj->translation_start) ? $tv_obj->translation_start.'-'.$tv_obj->translation_end : '-';
    
    print "Variation: $variation_name\tConsequence: $consequence_term\tLocation in cDNA: $cdna_coords\tPeptide change: $amino_acid_change\tLocation in peptide\t$translation_coords\n";
}

