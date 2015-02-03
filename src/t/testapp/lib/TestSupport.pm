package TestSupport;

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/testapp/lib";
use JSON;
use Dancer2;
use Dancer2::Plugin::DBIC;
use HTTP::Request;
use HTTP::Request::Common;
use Strehler::Meta::Category;

sub reset_database
{
    my $schema = config->{'Strehler'}->{'schema'} ? schema config->{'Strehler'}->{'schema'} : schema;
    $schema->resultset('Artwork')->delete_all();
}

sub create_article
{
    my $cb = shift;
    my $counter = shift || '';
    my $category = '153';
    my $subcategory = '';
    my $custom_params = shift || {};
    my $r = $cb->( POST '/admin/article/add', 
                    [ 'image' => undef,
                      'category' => $category,
                      'subcategory' => $subcategory,
                      'tags' => exists $custom_params->{'tags'} ? $custom_params->{'tags'} : 'tag1',
                      'display_order' => exists $custom_params->{'display_order'} ? $custom_params->{'display_order'} : 14,
                      'publish_date' => exists $custom_params->{'publish_date'} ? $custom_params->{'publish_date'} : '12/03/2014',
                      'title_it' => exists $custom_params->{'title_it'} ? $custom_params->{'title_it'} : 'Automatic test ' . $counter . ' - title - IT',
                      'text_it' => exists $custom_params->{'text_it'} ? $custom_params->{'text_it'} : 'Automatic test ' . $counter . ' - body - IT',
                      'title_en' => exists $custom_params->{'title_en'} ? $custom_params->{'title_en'} : 'Automatic test ' . $counter . ' - title - EN',
                      'text_en' => exists $custom_params->{'text_en'} ? $custom_params->{'text_en'} : 'Automatic test ' . $counter . ' - body - EN' 
                     ]);
}

1;

