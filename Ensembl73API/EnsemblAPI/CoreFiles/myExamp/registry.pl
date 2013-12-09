#!/usr/bin/perl

use strict;
use warnings;
use Bio::EnsEMBL::LookUp;
my $lookup = Bio::EnsEMBL::LookUp->new(-URL=>"http://bacteria.ensembl.org/registry.json",-NO_CACHE=>1);
my ($dba) = @{$lookup->get_by_name_exact('escherichia_coli_str_k_12_substr_mg1655')};   
my @dbas = @{$lookup->get_all_by_name_pattern('escherichia_coli_.*')};

