use v5.30;
use strict;
use warnings;
use utf8;

use Test::More;

my $ret = eval <<'PERL';
    package Local::Prelude::Corinna::Smoke;

    use Modern::Perl::Prelude qw(
        -corinna
        -utf8
    );

    class Local::Prelude::Corinna::Person {
        field $name :param;
        field $age  :param = 0;

        method greet {
            return "Hello, I'm $name and I'm $age years old";
        }

        method have_birthday {
            $age++;
            return $age;
        }
    }

    class Local::Prelude::Corinna::Employee :isa(Local::Prelude::Corinna::Person) {
        field $title  :param;
        field $salary :param = 0;

        method title {
            return $title;
        }

        method salary {
            return $salary;
        }

        method give_raise ($amount) {
            $salary += $amount;
            return $salary;
        }
    }

    my $alice = Local::Prelude::Corinna::Person->new(
        name => 'Alice',
        age  => 30,
    );

    my $bob = Local::Prelude::Corinna::Person->new(
        name => 'Bob',
    );

    my $jose = Local::Prelude::Corinna::Person->new(
        name => 'José',
    );

    my $employee = Local::Prelude::Corinna::Employee->new(
        name   => 'Charlie',
        age    => 28,
        title  => 'Developer',
        salary => 50_000,
    );

    [
        $alice->greet,
        $alice->have_birthday,
        $bob->greet,
        $employee->title,
        $employee->salary,
        $employee->give_raise(5_000),
        $employee->have_birthday,
        $employee->greet,
        utf8::is_utf8($jose->greet) ? 1 : 0,
    ];
PERL

ok($ret, 'optional -corinna import compiles and runs')
    or diag $@;

is($ret->[0], "Hello, I'm Alice and I'm 30 years old", 'Object::Pad class method works');
is($ret->[1], 31, 'Object::Pad field mutation works');
is($ret->[2], "Hello, I'm Bob and I'm 0 years old", 'default field value works');
is($ret->[3], 'Developer', 'subclass field reader method works');
is($ret->[4], 50_000, 'initial subclass state works');
is($ret->[5], 55_000, 'subclass method with argument works');
is($ret->[6], 29, 'inherited method works');
is($ret->[7], "Hello, I'm Charlie and I'm 29 years old", 'inherited greet works');
ok($ret->[8], '-corinna works together with -utf8');

my $ok_no = eval <<'PERL';
    package Local::Prelude::Corinna::No;

    use Modern::Perl::Prelude '-corinna';
    no Modern::Perl::Prelude '-corinna';

    1;
PERL

ok($ok_no, 'no Modern::Perl::Prelude accepts -corinna option')
    or diag $@;

done_testing;
