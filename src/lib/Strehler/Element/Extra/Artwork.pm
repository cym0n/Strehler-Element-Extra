package Strehler::Element::Extra::Artwork;

use strict;
use Cwd 'abs_path';
use Moo;
use Dancer2 0.154000;

extends 'Strehler::Element';
with 'Strehler::Element::Role::Maintainer';

my $module_file_path = __FILE__;
my $root_path = abs_path($module_file_path);
$root_path =~ s/Artwork\.pm//;
my $form_path = $root_path . "../../forms";
my $views_path = $root_path . "../../views";

sub metaclass_data 
{
    my $self = shift;
    my $param = shift;
    my %element_conf = ( item_type => 'artwork',
                         ORMObj => 'Artwork',
                         category_accessor => 'artworks',
                         multilang_children => 'artdescriptions' );
    return $element_conf{$param};
}

sub form { return "$form_path/extra/artwork.yml" }
sub multilang_form { return "$form_path/extra/artwork_multilang.yml" }
sub categorized { return 1; }

sub save_form
{
    my $self = shift;
    my $id = shift;
    #my $img = shift;
    my $form = shift;
    my $uploads = shift;

    my $img = $uploads->{'photo'};
    my $thumb = $uploads->{'thumbnail'};
        
    my $ref_img; 
    my $ref_thumb; 
    my $path;
    my $public;
    
    if($img)
    {
        $public = Strehler::Helpers::public_directory();
        $ref_img = '/upload/' . $img->filename;
        $path = $public . $ref_img;
        $img->copy_to($path);
    }
    if($thumb)
    {
        $public = Strehler::Helpers::public_directory();
        $ref_thumb = '/upload/' . $thumb->filename;
        $path = $public . $ref_thumb;
        $thumb->copy_to($path);
    }
    
    my $category;
    if($form->param_value('subcategory'))
    {
        $category = $form->param_value('subcategory');
    }
    elsif($form->param_value('category'))
    {
        $category = $form->param_value('category');
    }
    
    my $img_row;
    if($id)
    {
        $img_row = $self->get_schema()->resultset('Artwork')->find($id);
        $img_row->update({ category => $category });
        if($img)
        {
            $img_row->update({ image => $ref_img });
        }
        if($thumb)
        {
            $img_row->update({ thumbnail => $ref_thumb });
        }
     
        $img_row->artdescriptions->delete_all();
    }
    else
    {
        $img_row = $self->get_schema()->resultset('Artwork')->create({ image => $ref_img, thumbnail => $ref_thumb, category => $category });
    }
    my @languages = @{config->{Strehler}->{languages}};
    for(@languages)
    {
        my $lan = $_;
        $img_row->artdescriptions->create( { title => $form->param_value('title_' . $lan), description => $form->param_value('description_' . $lan), language => $lan }) if($form->param_value('title_' . $lan) || $form->param_value('description_' . $lan));;
    }
    Strehler::Meta::Tag->save_tags($form->param_value('tags'), $img_row->id, 'image');
    return $img_row->id;     
}

sub main_title
{
    my $self = shift;
    my @desc = $self->row->artdescriptions->search({ language => config->{Strehler}->{default_language } });
    if($desc[0])
    {
        return $desc[0]->title;
    }
    else
    {
        return "*** no title ***";
    }
}
sub custom_add_snippet
{
    my $self = shift;
    if(ref($self))
    {
        return "<h4>Image and thumbnail</h4>" .
               "<h5>Thumbnail</h5>" .
               '<img class="span2" src=' . $self->get_attr('thumbnail') . " />" .
               '<br />' .
               "<h5>Image</h5>" .
               '<img class="span2" src=' . $self->get_attr('image') . " />";
    }
    else
    {
        return undef;
    }
}


sub fields_list
{
    my $self = shift;
    my @fields = ( { 'id' => 'id',
                     'label' => 'ID',
                     'ordinable' => 1 },
                   { 'id' => 'artdescriptions.title',
                     'label' => 'Title',
                     'ordinable' => 1 },
                   { 'id' => 'category',
                       'label' => 'Category',
                       'ordinable' => 0 },
                   { 'id' => 'Preview',
                       'label' => 'Image',
                       'ordinable' => 0 },
                   { 'id' => 'Thumbnail',
                       'label' => 'Thumbnail',
                       'ordinable' => 0 }
               );
    return \@fields;
    
}
sub custom_list_template
{
    my $root_path = __FILE__;
    $root_path =~ s/Artwork\.pm//;
    return $views_path . "/extra/artwork_list.tt";
}

sub install
{
    my $self = shift;
    my $dbh = shift;
    $self->deploy_entity_on_db($dbh, ["Strehler::Schema::Extra::Artwork", "Strehler::Schema::Extra::Artdescription"]);
    return "Artwork entity available!\n\nDeploy of database tables completed\n\nCheck above for errors\n\nRun strehler schemadump to update your model\n\n";
}
1;
