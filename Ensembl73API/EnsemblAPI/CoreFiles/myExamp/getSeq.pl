#!/usr/bin/perl
use strict;
use warnings;
use Bio::EnsEMBL::Registry;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
-host => 'mysql.ebi.ac.uk',
-port => 4157,
-user => 'anonymous'
#-verbose => '1'
);

my @dba = @{ $registry->get_all_DBAdaptors() };

#foreach my $dbase (@dba) {
# print $dbase;
#}

# my $slice_adaptor = $registry->get_adaptor('bacillus_subtilis_subsp_subtilis_str_168','Core', 'slice')

