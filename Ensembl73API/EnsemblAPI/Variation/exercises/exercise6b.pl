#!/usr/bin/env perl
use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $reg = 'Bio::EnsEMBL::Registry';

$reg->load_registry_from_db(
  -host => 'ensembldb.ensembl.org',
  -user => 'anonymous'
);

# get transcriptvariation adaptor from variation database
my $tv_adaptor = $reg->get_adaptor("human", "variation", "transcriptvariation");

# get transcript adaptor from core 
my $t_adaptor = $reg->get_adaptor("human", "core", "transcript");

# fetch the transcript
my $transcript = $t_adaptor->fetch_by_stable_id('ENST00000001008');

# get all transcript variations
my @tvs = @{$tv_adaptor->fetch_all_by_Transcripts([$transcript])};


# Allele transcript
foreach my $tv (@tvs) {

  # Only coding variations
  next if (!$tv->pep_allele_string);

  my $variation_name = $tv->variation_feature->variation_name();
  my $amino_acid_change = $tv->pep_allele_string; 
    
  # Only alternate alleles
  # use get_all_TranscriptVariationAlleles to get reference and alternate alleles
  foreach my $tv_allele (@{$tv->get_all_alternate_TranscriptVariationAlleles}) {
    my $alleles             = $tv_allele->allele_string;
    my $alt_allele          = $tv_allele->feature_seq;
    my $codon               = $tv_allele->display_codon_allele_string;
    my $peptide             = $tv_allele->peptide;
    my $sift_prediction     = $tv_allele->sift_prediction || '-';
    my $polyphen_prediction = $tv_allele->polyphen_prediction || '-';
    printf("Variation name: %18s,  Alleles: %3s,  Alt allele: %1s,  Codon change: %5s,  AA change: %3s,  Peptide: %1s,  Sift prediction: %11s,  PolyPhen prediction: %17s\n",
            $variation_name, $alleles, $alt_allele, $codon, $amino_acid_change, $peptide, $sift_prediction, $polyphen_prediction
          );
  }
}
