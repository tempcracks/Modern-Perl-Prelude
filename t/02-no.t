use v5.30;
use strict;
use warnings;

use Test::More;

my $ok_say = eval <<'PERL';
    package Local::Prelude::No::Say;

    use Modern::Perl::Prelude;
    no Modern::Perl::Prelude;

    say 'hello';
    1;
PERL

ok(!$ok_say, 'say unavailable after no Modern::Perl::Prelude');

my $ok_trim = eval <<'PERL';
    package Local::Prelude::No::Trim;

    use Modern::Perl::Prelude;
    no Modern::Perl::Prelude;

    my $x = trim("  x  ");
    1;
PERL

ok(!$ok_trim, 'trim unavailable after no Modern::Perl::Prelude');

my $ok_try = eval <<'PERL';
    package Local::Prelude::No::Try;

    use Modern::Perl::Prelude;
    no Modern::Perl::Prelude;

    try {
        die "boom\n";
    }
    catch ($e) {
        return 1;
    }

    1;
PERL

ok(!$ok_try, 'try/catch unavailable after no Modern::Perl::Prelude');

done_testing;