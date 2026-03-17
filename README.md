# Modern::Perl::Prelude

A small lexical prelude for writing modern-style Perl on Perl 5.30+.

## What it enables

- `strict`
- `warnings`
- `feature qw(say state fc)`
- `Feature::Compat::Try`
- selected functions from `builtin::compat`

## Usage

```perl
use Modern::Perl::Prelude;

state $counter = 0;

try {
    die "boom\n";
}
catch ($e) {
    warn $e;
}
```

Optional UTF-8 source mode:

```perl
use Modern::Perl::Prelude '-utf8';
```

Disable native pragmata/features lexically again:

```perl
no Modern::Perl::Prelude;
```

## Install

```bash
perl Makefile.PL
make
make test
make install
```

## `Changes`

```text
Revision history for Modern::Perl::Prelude

0.004  2026-03-17
    - Add argument handling tests in t/03-args.t
    - Reach 100% statement, branch, subroutine and total coverage
    - Fix UTF-8 option tests to match real lexical behavior
    - Silence once-only package variable warning in args test
    - Finalize test suite for use/no and option validation paths

0.003  2026-03-17
    - Make unimport honest: only undo native pragmata/features
    - Fix no.t to test only reliably reversible native features
    - Clarify POD about import-only compat layers
	- Fix Makefile.PL

0.002  2026-03-17
    - Add unimport support: no Modern::Perl::Prelude
    - Add author tests
    - Add GitHub Actions CI matrix for Perl 5.30 .. 5.42
    - Add cpanfile
    - Refresh distribution skeleton

0.001  2026-03-17
    - First version
```
