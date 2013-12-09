#!/usr/bin/env perl 

use strict;
use warnings;
use Bio::EnsEMBL::Registry;

my $registry = "Bio::EnsEMBL::Registry";

$registry->load_registry_from_db( -host => 'ensembldb.ensembl.org', -user => 'anonymous');
my $tr_adaptor  = $registry->get_adaptor( 'Homo sapiens', 'Core', 'Transcript' );

my $tr = $tr_adaptor->fetch_by_stable_id('ENST00000001008');

print $tr->display_id(), "\n";


