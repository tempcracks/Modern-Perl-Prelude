# Modern::Perl::Prelude

A small lexical prelude for writing modern-style Perl on Perl 5.30+.

## What it enables by default

- `strict`
- `warnings`
- `feature qw(say state fc)`
- `Feature::Compat::Try`
- selected functions from `builtin::compat`

Default imported functions/features:

- `say`
- `state`
- `fc`
- `try` / `catch`
- `blessed`
- `refaddr`
- `reftype`
- `trim`
- `ceil`
- `floor`
- `true`
- `false`
- `weaken`
- `unweaken`
- `is_weak`

## Optional imports

### `-utf8`

Enables source-level UTF-8, like:

```perl
use Modern::Perl::Prelude '-utf8';
```

### `-class`

Enables `Feature::Compat::Class` on demand:

```perl
use Modern::Perl::Prelude '-class';

class Point {
    field $x :param = 0;
    field $y :param = 0;

    method sum {
        return $x + $y;
    }
}
```

### `-defer`

Enables `Feature::Compat::Defer` on demand:

```perl
use Modern::Perl::Prelude '-defer';

{
    defer { warn "leaving scope\n" };
    ...
}
```

## Combined options

Any combination is allowed:

```perl
use Modern::Perl::Prelude qw(
    -utf8
    -class
    -defer
);
```

## Usage

Basic usage:

```perl
use Modern::Perl::Prelude;

state $counter = 0;

my $s = trim("  hello  ");
my $folded = fc("Straße");

try {
    die "boom\n";
}
catch ($e) {
    warn $e;
}
```

With optional syntax extensions:

```perl
use Modern::Perl::Prelude qw(
    -class
    -defer
);

class Example {
    field $value :param = 0;

    method value {
        return $value;
    }
}

{
    defer { warn "scope ended\n" };
    my $obj = Example->new(value => 42);
    say $obj->value;
}
```

## Lexical disabling

You can disable native pragmata/features lexically again:

```perl
no Modern::Perl::Prelude;
```

This reliably disables native pragmata/features managed directly by the module, such as:

* `strict`
* warnings
* say
* state
* fc
* utf8

Compatibility layers are treated as import-only for cross-version use on Perl 5.30+, so they are not guaranteed to be symmetrically undone by:

```perl
no Modern::Perl::Prelude;
```

This applies to:

* `Feature::Compat::Try`
* `Feature::Compat::Class`
* `Feature::Compat::Defer`
* `builtin::compat`

## Design goals

This module is intended as a small project prelude for codebases that want a more modern Perl style while keeping runtime compatibility with Perl 5.30+.

It is implemented as a lexical wrapper using `Import::Into`, so pragmata and lexical features affect the caller's scope rather than the wrapper module itself.

Optional compatibility layers are loaded lazily and only when explicitly requested.

## Install

Using `MakeMaker`:

```bash
perl Makefile.PL
make
make test
make install
```

Using `cpanm` for dependencies:

```bash
cpanm --installdeps .
```

Including author/develop dependencies:

```bash
cpanm --with-develop --installdeps .
```

## Test

Run normal tests:

```bash
make test
```

Run author tests:

```bash
prove -lv xt/author
```

Run coverage:

```bash
cover -delete
HARNESS_PERL_SWITCHES=-MDevel::Cover prove -lr t xt/author
cover
```

## Current status

* Normal test suite: passing
* Author tests: passing
* POD coverage: passing
* Devel::Cover coverage: 100%

## License

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
