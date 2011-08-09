use strict;use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'CPAN::Testers::Search',
    AUTHOR        => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM  => 'lib/CPAN/Testers/Search.pm',
    ABSTRACT_FROM => 'lib/CPAN/Testers/Search.pm',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'CPAN-Testers-Search-*' },
    PREREQ_PM     => {
        'Test::More'  => 0,
        'Readonly'    => '1.03',
        'Moose'       => '2.0006',
        'WWW::Mechanize'   => '1.60',
        'namespace::clean' => '0.20',
        'MooseX::Params::Validate'     => '0.16',
        'Moose::Util::TypeConstraints' => '2.0006',
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
);