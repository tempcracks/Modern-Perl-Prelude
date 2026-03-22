#!/usr/bin/env perl
use strict;
use warnings;
use Test2::V0;
use Test2::Tools::Spec;

# Test module that uses our corinna import
package TestWithCorinna;
use Modern::Perl::Prelude '-corinna';

# Test class definition using Corinna syntax
class Test::Person {
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

package main;

	use Modern::Perl::Prelude '-corinna';
describe "Corinna import functionality" => sub {
    
    
    it "should allow creating Corinna objects" => sub {
        my $person = Test::Person->new(name => "Alice", age => 30);
        isa_ok($person, 'Test::Person');
        
        is($person->greet, "Hello, I'm Alice and I'm 30 years old", 
            "greet method works");
        
        is($person->have_birthday, 31, "have_birthday increments age");
        is($person->have_birthday, 32, "have_birthday works again");
    };
    
    it "should handle default values in fields" => sub {
        my $person = Test::Person->new(name => "Bob");
        isa_ok($person, 'Test::Person');
        
        is($person->greet, "Hello, I'm Bob and I'm 0 years old",
            "default age is 0");
        
        is($person->have_birthday, 1, "age increments from default");
    };
it "should work with multiple corinna classes in same file" => sub {
	#  package Test::Animal;

        class Test::Animal {
            field $species :param;
            field $sound   :param;
            
            method speak {
                return "The $species says $sound!";
            }
        }
       
        my $dog = Test::Animal->new(species => "dog", sound => "woof");
        is($dog->speak, "The dog says woof!", "Animal class works");
        
        my $cat = Test::Animal->new(species => "cat", sound => "meow");
        is($cat->speak, "The cat says meow!", "Another animal works");
    };
it "should support inheritance with corinna" => sub {

        class Test::Employee :isa(Test::Person) {
            field $title :param;
            field $salary :param = 0;
            
            method get_title { return $title; }
            
            method get_salary { return $salary; }
            
            method give_raise($amount) {
                $salary += $amount;
                return $salary;
            }
            
            method greet {
                my $parent_greet = $self->SUPER::greet();
                return "$parent_greet I'm a $title.";
            }
        }
       
        my $employee = Test::Employee->new(
            name => "Charlie",
            age => 28,
            title => "Developer",
            salary => 50000
        );
        isa_ok($employee, 'Test::Employee');
        isa_ok($employee, 'Test::Person');
        
        is($employee->get_title, "Developer", "gets title");
        is($employee->get_salary, 50000, "gets salary");
        
        is($employee->greet, "Hello, I'm Charlie and I'm 28 years old I'm a Developer.",
            "inherited greet with super works");
        
        is($employee->give_raise(5000), 55000, "raise works");
        is($employee->have_birthday, 29, "inherited method works");
    };
it "should work with other imported features together" => sub {
        use Modern::Perl::Prelude '-utf8';
        class Test::Mixed {
            field $name :param;
            field $unicode_string :param;
            
            method get_unicode {
                return "Name: $name, Unicode: $unicode_string";
            }
        }
        
        my $obj = Test::Mixed->new(
		name => "José",
            unicode_string => "café ☕️"
        );

        is($obj->get_unicode, "Name: José, Unicode: café ☕️",
            "Corinna works with unicode");

        # Check that utf8 is enabled
        ok(utf8::is_utf8($obj->get_unicode), "utf8 flag is set");
    };
};

done_testing();
