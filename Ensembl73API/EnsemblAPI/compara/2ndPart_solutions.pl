#!/usr/bin/perl

####################################

use strict;
use warnings;
use Data::Dumper;
use Bio::AlignIO;

use Bio::EnsEMBL::Registry;
#Bio::EnsEMBL::Registry->no_version_check(1);

# Auto-configure the registry
Bio::EnsEMBL::Registry->load_registry_from_db(
	-host=>'ensembldb.ensembl.org', -user=>'anonymous', 
	-port=>'5306');

# set up an AlignIO to format SimpleAlign output
my $alignIO = Bio::AlignIO->newFh(-interleaved => 0,
                                  -fh => \*STDOUT,
                                  -format => 'clustalw',
                                  -idlength => 20);



# We want to retrieve a small region of the mammal EPO multiple alignment using a region of human MT as the reference.

# get a compara MethodLinkSpeciesSet adaptor
my $method_link_species_set_adaptor =
    Bio::EnsEMBL::Registry->get_adaptor(
      "Multi", "compara", "MethodLinkSpeciesSet");


# get the method_link_species_set (data object) from the adaptor
my $methodLinkSpeciesSet = $method_link_species_set_adaptor->
	fetch_by_method_link_type_species_set_name("EPO", "mammals");


# define the start and end positions for the alignment
my ($ref_start, $ref_end) = (5065,5085);


# get a human **core** Slice adaptor
my $human_slice_adaptor =
    Bio::EnsEMBL::Registry->get_adaptor(
      "human", "core", "Slice");


# get the **core** slice (data object) corresponding to the region of interest 
my $human_slice = $human_slice_adaptor->fetch_by_region(
    "chromosome", "MT", $ref_start, $ref_end);


# get a compara GenomicAlignBlock adaptor 
my $genomic_align_block_adaptor =
    Bio::EnsEMBL::Registry->get_adaptor(
      "Multi", "compara", "GenomicAlignBlock");


# get a list-ref of (data objects) genomic_align_blocks
my $all_genomic_align_blocks = $genomic_align_block_adaptor->fetch_all_by_MethodLinkSpeciesSet_Slice(
        $methodLinkSpeciesSet, $human_slice);

foreach my $genomic_align_block (@{$all_genomic_align_blocks}){
#print Dumper $genomic_align_block;
	my $restricted_genomic_align_block = $genomic_align_block->restrict_between_alignment_positions($ref_start, $ref_end);

	# get some information from the data object
	print $alignIO $restricted_genomic_align_block->get_SimpleAlign;
	
}

####################################

~/workshop> perl -c test_script.pl
test_script.pl  syntax OK
~/workshop> perl test_script.pl
CLUSTAL W(1.81) multiple sequence alignment

homo_sapiens/MT/3071-3091          ttcagaccggagtaatccagg
gorilla_gorilla/MT/2491-2511       ttcagaccggagtaatccagg
bos_taurus/MT/2865-2885            ttcagaccggagtaatccagg
pongo_abelii/MT/2494-2514          ttcagaccggagcaatccagg
sus_scrofa/MT/3681-3701            ttcagaccggagcaatccagg
macaca_mulatta/MT/3021-3041        ttcagaccggagcaatccagg
mus_musculus/MT/2513-2533          ttcagaccggagcaatccagg
oryctolagus_cuniculus/MT/2508-2528 ttcagaccggagaaatccagg
rattus_norvegicus/MT/2502-2522     ttcagaccggagcaatccagg
canis_familiaris/MT/2504-2524      ttcagaccggagtaatccagg
                                   ************ ********

