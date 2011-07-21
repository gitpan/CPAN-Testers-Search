#!perl

use strict; use warnings;
use CPAN::Testers::Search;
use Test::More tests => 4;

my $tester = CPAN::Testers::Search->new();

eval { $tester->search() };
like($@, qr/0 parameters were passed/);

eval { $tester->search('ABCD') };
like($@, qr/Parameter \#1/);

eval { $tester->search(id => 'ABCD') };
like($@, qr/Parameter \#1/);

eval { $tester->search(guid => 'ABCD') };
like($@, qr/Parameter \#1/);