use utf8;
package Strehler::Schema::Extra::Artdescription;

=head1 NAME

Strehler::Schema::Extra::Artdescription;

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<ARTDESCRIPTIONS>

=cut

__PACKAGE__->table("ARTDESCRIPTIONS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 image

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 title

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 language

  data_type: 'varchar'
  is_nullable: 1
  size: 2

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "image",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "language",
  { data_type => "varchar", is_nullable => 1, size => 2 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 image

Type: belongs_to

Related object: L<SilviaTesta::SilviaDB::Result::Artwork>

=cut

__PACKAGE__->belongs_to(
  "artwork",
  "Strehler::Schema::Extra::Artwork",
  { id => "image" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-09-23 00:15:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X4Ro5w9iagjhwmDihh878Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
