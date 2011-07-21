package CPAN::Testers::Search;

use Moose;
use MooseX::Params::Validate;
use Moose::Util::TypeConstraints;
use namespace::clean;

use Carp;
use Data::Dumper;

use Readonly;
use WWW::Mechanize;

=head1 NAME

CPAN::Testers::Search - Interface to search CPAN Testers.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
Readonly my $URL => 'http://stats.cpantesters.org/cpanmail.html';

=head1 DESCRIPTION

This module is a very thin wrapper for "Find A Tester" feature provided by cpantesters.org.

=cut

subtype 'IDORGUID'
    => as 'Str'
    => where { (/^\d+$/) || (/^[a-z0-9]+\-[a-z0-9]+\-[a-z0-9]+\-[a-z0-9]+\-[a-z0-9]+$/) };

coerce 'IDORGUID'
    => from 'Num'
    => via { [ $_ ] }
    => from 'Str'
    => via { [ $_ ] };

has  'browser' => (is => 'ro', isa => 'WWW::Mechanize', default => sub { return new WWW::Mechanize(autocheck => 1); });

=head1 METHODS

=head2 search()

Search a CPAN Tester for the given ID or GUID. Please use with care and do *NOT* generate spam
attacks on testers.
Currently CPAN Testers reports are publicly available via the CPAN Testers Reports site, using 
a unique ID used by 'cpanstats' database or a GUID used by the Metabase  data store. Either of 
these  can  be used to perform a lookup. The ID or GUID is displayed via the report display on
the CPAN Testers Reports site. For example,

    http://www.cpantesters.org/cpan/report/7019327
    http://www.cpantesters.org/cpan/report/07019335-b19f-3f77-b713-d32bba55d77f

Here 7019327 is the ID and 07019335-b19f-3f77-b713-d32bba55d77f is the GUID.

	use strict; use warnings;
	use CPAN::Testers::Search;

	my $tester = CPAN::Testers::Search->new();
	
	print $tester->search('7019327') . "\n";
	# or
	print $tester->search('07019335-b19f-3f77-b713-d32bba55d77f') . "\n";
	# or
	print $tester->search(id => '7019327') . "\n";
	# or
	print $tester->search(guid => '07019335-b19f-3f77-b713-d32bba55d77f') . "\n";

=cut

around 'search' => sub
{
    my $orig  = shift;
    my $class = shift;

    if (@_ > 1 && !ref $_[0])
    {
        return $class->$orig($_[1]);
    }
    else
    {
        return $class->$orig(@_);
    }
};

sub search
{
    my $self = shift;
    my ($id) = pos_validated_list(\@_,
               { isa => 'IDORGUID', coerce => 1, required => 1 },
               MX_PARAMS_VALIDATE_NO_CACHE => 1);

    $self->{browser}->get($URL);
    $self->{browser}->form_number(1);
    $self->{browser}->field('id', $id);
    $self->{browser}->submit();
    my $content = $self->{browser}->content;
    return "No data found.\n" unless defined $content;
    
    if ($content =~ /\<tr\>\<th\>Address\:\<\/th\>\<td\>(.*)\<\/td\>\<\/tr\>/)
    {
        return $1;
    }
    else
    {
        return "No data found.\n";
    }
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs  or  feature requests to C<bug-cpan-testers-search at rt.cpan.org>,  or
through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CPAN-Testers-Search>.
I will be notified and then you'll automatically be notified of progress on your bug as I make
changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CPAN::Testers::Search

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CPAN-Testers-Search>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CPAN-Testers-Search>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CPAN-Testers-Search>

=item * Search CPAN

L<http://search.cpan.org/dist/CPAN-Testers-Search/>

=back

=head1 ACKNOWLEDGEMENT

This wouldn't have been possible without the service of cpantesters.org.

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Mohammad S Anwar.

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed in the hope that it will be useful,  but  WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

__PACKAGE__->meta->make_immutable;
no Moose; # Keywords are removed from the CPAN::Testers::Search package
no Moose::Util::TypeConstraints;

1; # End of CPAN::Testers::Search