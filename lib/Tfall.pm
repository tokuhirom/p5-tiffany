package Tfall;
use strict;
use warnings;
use 5.00800;
our $VERSION = '0.01_05';

sub load {
    my ($class, $klass, $args) = @_;
    $klass = _load_class($klass, 'Tfall');
    return $klass->new($args);
}

# code taken from Plack::Util::load_class.
my %loaded;
sub _load_class {
    my ( $class, $prefix ) = @_;

    if ($prefix) {
        unless ( $class =~ s/^\+// || $class =~ /^$prefix/ ) {
            $class = "$prefix\::$class";
        }
    }

    return $class if $loaded{$class}++;

    my $file = $class;
    $file =~ s!::!/!g;
    require "$file.pm";    ## no critic

    return $class;
}

1;
__END__

=encoding utf8

=head1 NAME

Tfall - Generic interface for Perl5 template engines.

=head1 SYNOPSIS

    use Tfall;

    my $tmpl = Tfall->load('Text::Xslate', {syntax => 'TTerse'});
    $tmpl->render(\'Hello, [% name %]', {name => 'John'});
    # => "Hello, John"

=head1 DESCRIPTION

Tfall is generic interface for Perl5 template engines.

=head1 FACTORY METHOD

Tfall.pm provides factory feature for Tfall::* classes.

=over 4

=item my $tfall = Tfall->load($klass, $args)

Load Tfall::* class and create new instance.

    my $xslate = Tfall->load("Text::Xslate", +{syntax => 'TTerse'});

    my $xslate = Tfall->load("+My::Template::Engine", +{option => 'here'});

=back

=head1 The Tfall Protocol

The Tfall protocol is based on duck typing.

=over 4

=item my $tfall = Tfall::Thing->new([$args:HashRef|ArrayRef]);

The module SHOULD have B<new> method.

This method creates new instance of Tfall module.

$args should pass to the constructor of template engine.

=item $tmpl->render($stuff:Scalar|ScalarRef [, @args]);

The module SHOULD have B<render> method.

This method rendering template with @args.

If template engine found any errors, this method MUST throw exception.

If the template engine throws any exceptions, Tfall module SHOULD pass through.

B<$stuff> SHOULD allows Str for filename. And the module MAY allows ScalarRef for text.

This method MUST return plain string. Do not return blessed reference.

=back

=head1 HOW TO USE IT IN MY WEB APPLICATION FRAMEWORK?

Example code is here: eg/sinatraish/.

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF GMAIL COME<gt>

=head1 SEE ALSO

L<Any::Template>, L<http://github.com/rtomayko/tilt>

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
