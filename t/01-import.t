use v5.30;
use strict;
use warnings;
use utf8;

use Test2::Bundle::Extended;
use Test2::Tools::Spec qw(describe it before_all);
use Test2::Tools::Basic qw(ok);
use Test2::Tools::Compare qw(is);

describe "Modern::Perl::Prelude imports" => sub {
	my $RESULT;
	before_all "setup test environment" => sub {
		my $ok = eval <<'PERL';
			package Local::Prelude::Smoke;

			use Modern::Perl::Prelude;

			our %RESULT;

			sub run {
				state $counter = 0;
				$counter++;

				my $out = '';
				{
					open my $fh, '>', \$out or die "open scalar fh failed: $!";
					local *STDOUT = $fh;
					say 'hello';
				}
				my $trimmed = trim(" hello \n");
				my $folded = fc("Straße");
				
				my $obj = bless {}, 'Local::Prelude::Smoke::Object';

				my $caught = '';
				try {
					die "boom\n";
				}
				catch ($e){
					$caught = $e;
				}

				my $tmp = [];
				my $ref = $tmp;

				my $weak_before = is_weak($ref) ? 1 : 0;
				weaken($ref);
				my $weak_after = is_weak($ref) ? 1 : 0;
				unweaken($ref);
				my $weak_restored = is_weak($ref) ? 1 : 0;

				%RESULT = (
					said            => $out,
					trimmed         => $trimmed,
					folded          => $folded,
					blessed         => blessed($obj),
					caught_like     => ($caught =~ /boom/) ? 1 : 0,
					true_value      => true  ? 1 : 0,
					false_value     => false ? 1 : 0,
					ceil_value      => ceil(1.2),
					floor_value     => floor(1.8),
					refaddr_defined => defined refaddr($obj) ? 1 : 0,
					reftype         => reftype($obj),
					state_counter   => $counter,
					weak_before     => $weak_before,
					weak_after      => $weak_after,
					weak_restored   => $weak_restored,
				);

				return 1;
			}


			run();
PERL

		ok($ok, 'module imports compile and run')
			or diag $@;
		$RESULT = \%Local::Prelude::Smoke::RESULT;
	};

	it "should import say" => sub {
		is($RESULT->{said}, "hello\n", 'say imported');
	};

	it "should import trim" => sub {
		is($RESULT->{trimmed}, 'hello', 'trim imported');
	};

	it "should import fc" => sub {
		is($RESULT->{folded}, 'strasse', 'fc imported');
    };
    
    it "should import blessed" => sub {
        is($RESULT->{blessed}, 'Local::Prelude::Smoke::Object', 'blessed imported');
    };
    
    it "should import try/catch" => sub {
        ok($RESULT->{caught_like}, 'try/catch imported');
    };
    
    it "should import true" => sub {
        is($RESULT->{true_value}, 1, 'true imported');
    };
    
    it "should import false" => sub {
        is($RESULT->{false_value}, 0, 'false imported');
    };
    
    it "should import ceil" => sub {
        is($RESULT->{ceil_value}, 2, 'ceil imported');
    };
    
    it "should import floor" => sub {
        is($RESULT->{floor_value}, 1, 'floor imported');
    };
    
    it "should import refaddr" => sub {
        ok($RESULT->{refaddr_defined}, 'refaddr imported');
    };
    
    it "should import reftype" => sub {
        is($RESULT->{reftype}, 'HASH', 'reftype imported');
    };
    
    it "should have state feature enabled" => sub {
        is($RESULT->{state_counter}, 1, 'state feature enabled');
    };
    
    it "should import is_weak and weaken" => sub {
        is($RESULT->{weak_before}, 0, 'is_weak before weaken');
        is($RESULT->{weak_after}, 1, 'weaken/is_weak imported');
    };
    
    it "should import unweaken" => sub {
        is($RESULT->{weak_restored}, 0, 'unweaken imported');
    };
};
done_testing;
