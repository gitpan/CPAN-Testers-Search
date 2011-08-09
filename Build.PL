use strict;use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign              => 1,
    module_name       => 'CPAN::Testers::Search',
    license           => 'perl',
    dist_author       => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from => 'lib/CPAN/Testers/Search.pm',
    add_to_cleanup    => [ 'CPAN-Testers-Search-*' ],
    build_requires    => {
        'Test::More'  => 0,
        'Readonly'    => '1.03',
        'Moose'       => '2.0006',
        'WWW::Mechanize'   => '1.60',
        'namespace::clean' => '0.20',
        'MooseX::Params::Validate'     => '0.16',
        'Moose::Util::TypeConstraints' => '2.0006',
    },
);

$builder->create_build_script();