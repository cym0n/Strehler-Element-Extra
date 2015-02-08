package Strehler::Element::Extra::Chapter;

use Moo;
use Text::Markdown 'markdown';

extends 'Strehler::Element::Article';

sub item_type
{
    return 'chapter';
}

sub text
{
    my $self = shift;
    my $text = shift;
    return markdown($text);
}
sub bare_text
{
    my $self = shift;
    my $text = shift;
    return $text;
}

sub abstract
{
    my $self = shift;
    my $language = shift;
    my $text = $self->get_attr_multilang('text', $language, 1);
    return markdown(substr($text, 0, 800) . "...");
}

sub incipit
{
    my $self = shift;
    my $language = shift;
    my $text = $self->get_attr_multilang('text', $language, 1);
    return substr($text, 0, 100) . "...";
}

sub get_ext_data
{
    my $self = shift;
    my $language = shift;
    my %data = $self->SUPER::get_ext_data($language);
    $data{'incipit'} = $self->incipit($language);
    $data{'abstract'} = $self->abstract($language);
    return %data; 
}

sub install
{
    return "This is just a different front-end representation of standard Article.\nNo installation is needed";
}

=encoding utf8

=head1 NAME

Strehler::Element::Extra::Artwork - Artwork entity

=head1 DESCRIPTION

Just a new Article representation for frontend. Text content is parsed using L<Text::Markdown> and new attributes are made available.

Article, in the backend, are still inserted using Article entity.

=head1 INSTALLATION

No installation is needed, just use Strehler::Element::Extra::Chapter while retrieving Strehler::Element::Article objects.

=head1 ATTRIBUTES

Chapter has the same attributes of L<Strehler::Element::Article>. 

Text manipulations (truncates) are added.

=over 4

=item B<incipit>

First 100 characters of the body, parsed using L<Text::Markdown>. Text is terminated with "...".

=item B<abstract>

First 800 characters of the body, parsed using L<Text::Markdown>. Text is terminated with "...".

=back

=head1 NOTES

This is the implementation of what is described in L<Strehler::Manual::MarkdownArticleTutorial>.

=cut

1;
