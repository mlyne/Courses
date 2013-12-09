#!/usr/bin/env perl

use strict;
use warnings;

use Bio::EnsEMBL::Registry;

my $reg = 'Bio::EnsEMBL::Registry';

$reg->load_registry_from_db(
  -host => 'ensembldb.ensembl.org',
  -user => 'anonymous'
);

# get StructuralVariation adaptor from variation database
my $sv_adaptor = $reg->get_adaptor("human", "variation", "structuralvariation");

my $structural_var = $sv_adaptor->fetch_by_name('esv234231');

print '> Structural variation ', $structural_var->variation_name, ' of class ', $structural_var->var_class, "\n";

# Structural variation coordinates		
foreach my $svf (@{$structural_var->get_all_StructuralVariationFeatures}) {
	print "Chromosome: ", $svf->seq_region_name, "\n";
	
	print "Outer start: ", $svf->outer_start, "\n" if (defined($svf->outer_start));
	print "Inner start: ", $svf->inner_start, "\n" if (defined($svf->inner_start));
	
	print "Start: ",$svf->start,"\nEnd: ",$svf->end,"\n";
	
	print "Inner end: ", $svf->inner_end, "\n" if (defined($svf->inner_end));
	print "Outer end: ", $svf->outer_end, "\n" if (defined($svf->outer_end));
}

print "\n> Supporting evidence(s):\n";
# Supporting evidences
foreach my $ssv (@{$structural_var->get_all_SupportingStructuralVariants}) {
	print "Supporting evidence ", $ssv->variation_name, " of class ", $ssv->class_SO_term, "\n";
}
