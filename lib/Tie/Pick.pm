package Tie::Pick;

#
# $Id: Pick.pm,v 1.1 1999/07/20 06:55:25 abigail Exp abigail $
#
# $Log: Pick.pm,v $
# Revision 1.1  1999/07/20 06:55:25  abigail
# Initial revision
#
#

use strict;

use vars qw /$VERSION/;

$VERSION = '$Revision: 1.1 $' =~ /([\d.]+)/;


sub TIESCALAR {
    my $class  =   shift;
    do { require Carp;
         Carp::croak ("tie needs more arguments")
    } unless @_;
    bless [@_] => $class;
}

sub FETCH     {
    my $values = shift;
    return undef unless @$values;
    my $index  = int rand @$values;
    unless ($index == $#$values) {
        @{$values} [$index, $#$values] = @{$values} [$#$values, $index];
    }
    pop @$values;
}

sub STORE     {
    my $self = shift;
    do { require Carp;
         Carp::croak ("assignment needs reference to non empty array")
    } unless 1 == @_ && 'ARRAY' eq ref $_ [0] && @{$_ [0]};
      @$self = @{$_ [0]};
}


"End of Tie::Pick";

__END__

=pod

=head1 NAME

Tie::Pick - Randomly pick (and remove) an element from a set.

=head1 SYNOPSIS

    use Tie::Pick;

    tie my $beatle => Tie::Pick => qw /Paul Ringo George John/;

    print "My favourite beatles are $beatle and $beatle.\n";
    # Prints: My favourite beatles are John and Ringo.

=head1 DESCRIPTION

C<Tie::Pick> lets you randomly pick an element from a set, and have
that element removed from the set.

The set to pick from is given as an list of extra parameters on tieing
the scalar. If the set is exhausted, the scalar will have the undefined
value. A new set to pick from can be given by assigning a reference to
an array of the values of the set to the scalar.

The algorithm used for picking values of the set is a variant of the
Fisher-Yates algorithm, as discussed in Knuth [3]. It was first published
by Fisher and Yates [2], and later by Durstenfeld [1]. The difference
is that we only perform one iteration on each look up.

If you want to pick elements from a set, without removing the element
after picking it, see the C<Tie::Select> module.

=head1 CAVEAT

Salfi [4] points to a big caveat. If the outcome of a random generator
is solely based on the value of the previous outcome, like a linear
congruential method, then the outcome of a shuffle depends on exactly
three things: the shuffling algorithm, the input and the seed of the
random generator. Hence, for a given list and a given algorithm, the
outcome of the shuffle is purely based on the seed. Many modern computers
have 32 bit random numbers, hence a 32 bit seed. Hence, there are at
most 2^32 possible shuffles of a list, foreach of the possible algorithms.
But for a list of n elements, there are n! possible permutations.
Which means that a shuffle of a list of 13 elements will not generate
certain permutations, as 13! > 2^32.

=head1 REFERENCES

=over

=item [1]

R. Durstenfeld: I<CACM>, B<7>, 1964. pp 420.

=item [2] 

R. A. Fisher and F. Yates: I<Statistical Tables>. London, 1938.
Example 12.

=item [3]

D. E. Knuth: I<The Art of Computer Programming>, Volume 2, Third edition.
Section 3.4.2, Algorithm P, pp 145. Reading: Addison-Wesley, 1997.
ISBN: 0-201-89684-2.

=item [4]

R. Salfi: I<COMPSTAT 1974>. Vienna: 1974, pp 28 - 35.

=back

=head1 REVISION HISTORY

    $Log: Pick.pm,v $
    Revision 1.1  1999/07/20 06:55:25  abigail
    Initial revision


=head1 AUTHOR

This package was written by Abigail.

=head1 COPYRIGHT and LICENSE

This package is copyright 1999 by Abigail.

This program is free and open software. You may use, copy, modify,
distribute and sell this program (and any modified variants) in any way
you wish, provided you do not restrict others to do the same.

=cut
