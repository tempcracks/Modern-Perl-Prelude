requires 'Import::Into';
requires 'Feature::Compat::Try';
requires 'builtin::compat';

on 'test' => sub {
    requires 'Test::More', '0.96';
};

on 'develop' => sub {
    requires 'Test::Pod';
    requires 'Test::Pod::Coverage';
    requires 'Test::EOL';
};
