#!/usr/bin/perl
use strict;
use warnings;
use Bio::EnsEMBL::Registry;

my $registry = 'Bio::EnsEMBL::Registry';

$registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous',
);

# Regulatory Feature vs ENCODE Segmentation classification


#Grab the adaptors
my $regfeat_adaptor = $registry->get_adaptor('Human', 'funcgen', 'regulatoryfeature');
my $segfeat_adaptor = $registry->get_adaptor('Human', 'funcgen', 'segmentationfeature');
my %ctype_segfeats  = ();


#Fetch ENSR00000623613 reg feats for all cell types.
my @rfs = @{$regfeat_adaptor->fetch_all_by_stable_ID('ENSR00001348194')};


print "Regulatory Build vs ENCODE segmentation classifications for:\t";
print $rfs[0]->stable_id.' ('.$rfs[0]->length."bp)\n";

my $rf_slice = $rfs[0]->feature_Slice;


foreach my $seg_feat( @{$segfeat_adaptor->fetch_all_by_Slice($rf_slice)} ){
  my $cell_type = $seg_feat->cell_type->name;
  if(defined $cell_type){
    push @{ $ctype_segfeats{$cell_type} } , $seg_feat;
  }
}



# Print out the details
foreach my $rf(@rfs){
  my $ctype = $rf->cell_type->name;

  print "\nCellType\t".$ctype."\n";
  print "RegulatoryFeature Classification:\t".$rf->feature_type->name."\n";


  if(exists $ctype_segfeats{$ctype}){

    print "SegmentationFeature Classification:\t".
      join(', ', ( map { $_->feature_type->name }
                   @{ $ctype_segfeats{ $ctype } }
                 ))."\n";
## Equivalent to above, but has a trailing comma
#    for my $segfeat (@{$ctype_segfeats{$ctype}}){
#      print $segfeat->feature_type->name.",";
#    }
  }
  else{
    print "SegmentationFeature Classication:\tNo ENCODE segmentation available for ".$ctype."\n";
  }
}



__END__

# Segmentation is often more accurate, but Reg Build is available for more cell lines
perl regulatory_features_4.pl
Regulatory Build vs ENCODE segmentation classifications for:    ENSR00001348194 (1530bp)

CellType        NHEK
RegulatoryFeature Classification:       Promoter Associated
SegmentationFeature Classication:       No ENCODE segmentation available for NHEK

CellType        H1ESC
RegulatoryFeature Classification:       Promoter Associated
SegmentationFeature Classication:       Predicted Repressed/Low Activity, Predicted Enhancer, Predicted Repressed/Low Activity

CellType        HUVEC
RegulatoryFeature Classification:       Gene Associated
SegmentationFeature Classication:       Predicted Promoter with TSS

CellType        HMEC
RegulatoryFeature Classification:       Promoter Associated
SegmentationFeature Classication:       No ENCODE segmentation available for HMEC

CellType        CD4
RegulatoryFeature Classification:       Promoter Associated
SegmentationFeature Classication:       No ENCODE segmentation available for CD4

CellType        NH-A
RegulatoryFeature Classification:       Gene Associated
SegmentationFeature Classication:       No ENCODE segmentation available for NH-A

CellType        HepG2
RegulatoryFeature Classification:       Unclassified
SegmentationFeature Classication:       Predicted Repressed/Low Activity

CellType        IMR90
RegulatoryFeature Classification:       Unclassified
SegmentationFeature Classication:       No ENCODE segmentation available for IMR90

CellType        HSMM
RegulatoryFeature Classification:       Promoter Associated
SegmentationFeature Classication:       No ENCODE segmentation available for HSMM

CellType        MultiCell
RegulatoryFeature Classification:       Unclassified
SegmentationFeature Classication:       No ENCODE segmentation available for MultiCell

CellType        K562
RegulatoryFeature Classification:       Unclassified
SegmentationFeature Classication:       Predicted Promoter with TSS

CellType        GM12878
RegulatoryFeature Classification:       Promoter Associated
SegmentationFeature Classication:       Predicted Promoter with TSS


#http://www.ensembl.org/Homo_sapiens/Share/c4f593fa0b3bb188eb088714440f380b89648374



#Ensembl Regulatory Build lacks specificity of classification with many unclassified, also has potential resolution issues. Also does no explicitly annotate 'dead' regions/
#Conversely...
#ENCODE segmentation lacks restricted to 6 cell types, as well as potential fragmention issues. No common feature location definition across cell lines. No MultiCell summary set. ~Genomewide coverage,


