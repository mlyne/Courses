use strict;
use warnings;

use Bio::EnsEMBL::Registry;

## Load the registry automatically
my $reg = "Bio::EnsEMBL::Registry";
$reg->load_registry_from_url('mysql://anonymous@ensembldb.ensembl.org');

## Get the human gene adaptor
my $human_gene_adaptor = $reg->get_adaptor("Homo sapiens", "core", "Gene");

## Get the Compara adaptors
my $gene_member_adaptor = $reg->get_adaptor("Multi", "compara", "GeneMember");
my $family_adaptor = $reg->get_adaptor("Multi", "compara", "Family");
my $gene_tree_adaptor = $reg->get_adaptor("Multi", "compara", "GeneTree");
my $mlss_adaptor = $reg->get_adaptor("Multi", "compara", "MethodLinkSpeciesSet");
my $homology_adaptor = $reg->get_adaptor("Multi", "compara", "Homology");


## Part 1
##########

## Get all existing gene object with the name SAFB
my $these_genes = $human_gene_adaptor->fetch_all_by_external_name('SAFB');

# Trick: the instructor confirmed that there is a single such human gene
my $this_gene = $these_genes->[0];


print $this_gene->source(), " ", $this_gene->stable_id(), ": ", $this_gene->description(), "\n";

## Get the compara member
my $gene_member = $gene_member_adaptor->fetch_by_source_stable_id("ENSEMBLGENE", $this_gene->stable_id());

## Print some info for this member
$gene_member->print_member();


## Part 2
##########


## Get all the families
my $all_families = $family_adaptor->fetch_all_by_Member($gene_member);

my $relevant_family = undef;

## For each family
foreach my $this_family (@{$all_families}) {

    # To discard the artifact family
    if (scalar(@{$this_family->get_all_Members}) > 10) {
        $relevant_family = $this_family;
        print "Family: ", $this_family->description(), " (description score = ", $this_family->description_score(), ")\n";
    }
    print "\n";
}


## Part 3
##########


## Get the tree for this member
my $this_tree = $gene_tree_adaptor->fetch_default_for_Member($gene_member);
# Speeds up the further operations
$this_tree->preload();
print "Tree: ", $this_tree->stable_id, ", ", scalar(@{$this_tree->get_all_Members}), " members\n";

## Part 4
##########

## Compare the contents of the family and the gene tree

sub compare_family_tree {
    my ($fam, $tree) = @_;

    my $in_fam = 0;
    my $in_tree = 0;
    my $in_both = 0;

    my %genes_in_family = ();
    foreach my $gene (@{$fam->get_all_GeneMembers}) {
        $genes_in_family{$gene->stable_id} = 1;
    }
    foreach my $gene (@{$tree->get_all_GeneMembers}) {
        if (exists $genes_in_family{$gene->stable_id}) {
            print $gene->stable_id." is in both the tree and the family\n";
            delete $genes_in_family{$gene->stable_id};
            $in_both++;
        } else {
            print $gene->stable_id." is only in the tree\n";
            $in_tree++;
        }
    }
    # The genes that are in the tree have been removed
    # The remaining keys are thus specific to the family
    foreach my $gene_stable_id (keys %genes_in_family) {
        print $gene_stable_id." is only in the family\n";
        $in_fam++;
    }
    print "Summary: $in_both in both, $in_fam in the family only, $in_tree in the tree only\n";
}

compare_family_tree($relevant_family, $this_tree);


## Part 4
##########

## Get the SAFB subtree for the taxon Sarcopterygii

my $sarco_subtree = undef;
foreach my $node (@{$this_tree->get_all_nodes}) {
    if ($node->taxon->name() eq 'Sarcopterygii') {
        my $found_safb = 0;
        foreach my $leaf (@{$node->get_all_leaves}) {
            if ($leaf->gene_member->stable_id eq $gene_member->stable_id) {
                $found_safb = 1;
                last;
            }
        }
        if ($found_safb) {
            $sarco_subtree = $node;
            print "The subtree is: ";
            $node->print_node;
            $node->print_tree;
            compare_family_tree($relevant_family, $node->get_AlignedMemberSet);
        }
    }
}


## Part 5
##########

## In the subtree, list the duplications and their confidence score

foreach my $node (@{$sarco_subtree->get_all_nodes}) {
    if ((not $node->is_leaf()) and ($node->node_type eq 'duplication')) {
        print "Found a duplication at ".$node->taxon->name()." with a score of ".$node->duplication_confidence_score."\n";
    }
}


## Part 6
##########

## For each species in the subtree, get the closest orthologue to SAFB

my %species;
foreach my $leaf (@{$sarco_subtree->get_all_leaves}) {
    $species{$leaf->taxon->name} = 1;
}

foreach my $species_name (keys %species) {
    my $all_orthologies = $homology_adaptor->fetch_all_by_Member_paired_species($gene_member, $species_name, ['ENSEMBL_ORTHOLOGUES']);
    print $species_name, ": ", scalar(@{$all_orthologies}). " orthologues\n";

    my $best_id = 0;
    my $best_orthologue = undef;
    foreach my $orthology (@$all_orthologies) {
        # In the homology pair, the first gene is the query gene (SAFB), and the second is the target gene (in $species_name)
        my $orthologue = $orthology->get_all_Members->[1];
        if ($orthologue->perc_id > $best_id) {
            $best_id = $orthologue->perc_id;
            $best_orthologue = $orthologue;
        }
    }
    if ($best_orthologue) {
        print " > The closest has $best_id % of identity, and is: ";
        $best_orthologue->print_member;
    }
}

