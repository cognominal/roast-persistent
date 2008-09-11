use v6;

use Test;

plan 32;

class Foo {
    has $.bar is rw;
    has $.value is rw;
    method baz { return 'Foo::baz' }
    method getme($self:) returns Foo { return $self }
}

class Foo::Bar is Foo {
    has $.bar2 is rw;
    method baz { return 'Foo::Bar::baz' }
    method fud { return 'Foo::Bar::fud' }
    method super_baz ($self:) { return $self.Foo::baz() }
}

my $foo_bar = Foo::Bar.new();
isa_ok($foo_bar, Foo::Bar);

ok(!defined($foo_bar.bar2()), '... we have our autogenerated accessor');
ok(!defined($foo_bar.bar()), '... we inherited the superclass autogenerated accessor');

lives_ok { $foo_bar.bar = 'BAR' }, '... our inherited the superclass autogenerated accessor is rw';
is($foo_bar.bar(), 'BAR', '... our inherited the superclass autogenerated accessor is rw');

lives_ok { $foo_bar.bar2 = 'BAR2'; }, '... our autogenerated accessor is rw';

is($foo_bar.bar2(), 'BAR2', '... our autogenerated accessor is rw');

is($foo_bar.baz(), 'Foo::Bar::baz', '... our subclass overrides the superclass method');

#?rakudo 2 skip "method resolution bug"
is($foo_bar.super_baz(), 'Foo::baz', '... our subclass can still access the superclass method through Foo::');
is($foo_bar.fud(), 'Foo::Bar::fud', '... sanity check on uninherited method');

#?rakudo skip 'stringification of objects'
is($foo_bar.getme, $foo_bar, 'can call inherited methods');
is($foo_bar.getme.baz, "Foo::Bar::baz", 'chained method dispatch on altered method');

ok(!defined($foo_bar.value), 'value can be used for attribute name in derived classes');
my $fud;

lives_ok { $fud = $foo_bar.getme.fud }, 'chained method dispatch on altered method';
is($fud, "Foo::Bar::fud", "returned value is correct");

# See thread "Quick OO .isa question" on p6l started by Ingo Blechschmidt:
# L<"http://www.nntp.perl.org/group/perl.perl6.language/22220">

# XXX are these still conforming to S12?
ok  Foo::Bar.isa(Foo),      "subclass.isa(superclass) is true";
ok  Foo::Bar.isa(Foo::Bar), "subclass.isa(same_subclass) is true";
#?pugs 2 todo "feature"
ok  Foo::Bar.isa(Class),    "subclass.isa(Class) is false";
#?rakudo skip 'does'
ok  Foo::Bar.does(Class),   "subclass.does(Class) is true";
#?rakudo 2 skip 'no ::CLASS class'
ok !Foo::Bar.does(::CLASS),   "subclass.does(CLASS) is false";
ok !Foo::Bar.isa(::CLASS),    "subclass.isa(CLASS) is false";
ok !Foo::Bar.HOW.isa(Foo::BAR, Foo),      "subclass.HOW.isa(superclass) is false";
ok !Foo::Bar.HOW.isa(Foo::BAR, Foo::Bar), "subclass.HOW.isa(same_subclass) is false";
#?pugs todo "bug"
#?rakudo todo 'oo'
ok !Foo::Bar.HOW.isa(Foo::BAR, Class),    "subclass.HOW.isa(Class) is false";
#?rakudo skip 'does'
ok !Foo::Bar.HOW.does(Foo::BAR, Class),   "subclass.HOW.does(Class) is false";
#?rakudo 2 skip 'no ::CLASS class'
ok !Foo::Bar.HOW.isa(Foo::BAR, ::CLASS),  "subclass.HOW.isa(CLASS) is false";
#?pugs todo "feature"
ok  Foo::Bar.HOW.does(Foo::BAR, ::CLASS),  "subclass.HOW.does(CLASS) is true";


#?rakudo skip 'indirect method call syntax'
{
    my $test = '$obj.$meth is canonical (audreyt says)';
    class Abc {
        method foo () { "found" }
    }
    class Child is Abc { }
    is( eval('my $meth = "foo"; my $obj= Child.new; $obj.$meth()'), 'found', $test);
}

# Erroneous dispatch found by TimToady++

class X {
    method j () { 'X' }
};
class Z is X {}
class Y is X {
    method k () { Z.new.j() }
    method j () { 'Y' }
};

is(Z.new.j(), 'X', 'inherited method dispatch works');
is(Y.new.k(), 'X', 'inherited method dispatch works inside another class with same-named method');

#?rakudo skip "assignment errors"
{
    class A {
      has @.x = <a b c>;
      has $.w = 9;

      method y($i) { return @.x[$i]; }
    }

    class B is A {
      has $.w = 10;
      method z($i) { return $.y($i); }
    }

    is( B.new.z(1), 'b', 'initializer carries through' );
    is( B.new.w, 10, 'initializer can be overriden by derived classes' );
}
