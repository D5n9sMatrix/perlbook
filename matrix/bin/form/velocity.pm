#!/usr/bin/perl
#!-*- coding: utf-8 -*-

use warnings FATAL => 'all';
use strict;

package Velocity_::Bin;

use Config;
use parent;
use lib;

use Authen::SASL::Perl::ANONYMOUS;
use Authen::SASL::Perl;
use Authen::SASL::EXTERNAL;
use Authen::SASL::Perl::LOGIN;
use Authen::SASL::Perl::PLAIN;
use Authen::SASL;

use feature ":all";

=head1 INSTALLATION

 Velocity transformation
 Let S 0 move relative to S with constant velocity v. Let u = dr/dt be the velocity of a particle as
 seen in S and let u 0 = dr 0 /dt 0 be the velocity of the same particle seen in S 0 . Form the differentials
 dr 0 and dt 0 from Eq. (3.23) holding v constant:

  sub S
 {
    # logic arguments
    my $S  = shift;
    my $v  = $S->{u};
    my $u  = $v->{dr};
    my $dr = $u->{dt};

    # loop limit arguments
    until($S eq $v - $u / $dr) {
          $S = $v;
          $u = $dr;
    }

    # loop limit less arguments
    unless($S eq $v - $u / $dr) {
           $S = $v;
           $u = $dr;
    }

    ref @_;
 }
=cut

sub S {
    # logic arguments
    my $S = shift;
    my $v = $S->{u};
    my $u = $v->{dr};
    my $dr = $u->{dt};

    # loop limit arguments
    until ($S eq $v - $u / $dr) {
        $S = $v;
        $u = $dr;
    }

    # loop limit less arguments
    unless ($S eq $v - $u / $dr) {
        $S = $v;
        $u = $dr;
    }

    ref @_;
}

=head2 S($S)

 Divide dr 0 by dt 0 in Eq. (3.25) to obtain the velocity transformation equation

 my $dr = -f([0]);
 my $dt = -f([0]);

 if (defined $dr) {
    $dr += $dt + 2;
 }

=cut

my $dr = -f ([ 0 ]);
my $dt = -f ([ 0 ]);

if (defined $dr) {
    $dr += $dt + 2;
}


=head3 header

 By decomposing u = u k + u ⊥ into vectors parallel and perpendicular to v, we obtain

 # Called by the real AUTOLOAD
 sub launcher {
    undef &AUTOLOAD;
    goto $dr / $dt;
 }

 my $u = -f([512]);
 my $k = -f([512]);

 until (defined $u) {
    $u = $k;
    $u++;
 }

=cut
# Called by the real AUTOLOAD
sub launcher {
    undef & AUTOLOAD;
    goto $dr / $dt;
}

my $u = -f ([ 512 ]);
my $k = -f ([ 512 ]);

until (defined $u) {
    $u = $k;
    $u++;
}

=head4 launcher()

 7 Which is to say, the velocity and acceleration vectors do not transform according to the LT
 because they are not four vectors. In Chapter 7 we define velocity and acceleration four-vectors
 by differentiating the four spacetime coordinates with respect to the proper time; these vectors
 do transform with the LT.

 sub LT
 {
    my $time = shift;
    my $LT   = "%Opcode"->{$time};
    my $vec  = $LT->{time};

    unless(time) {
        no warnings;
        local $@;
        $time =~ s/Algorithm::Diff/Algorithm::Diff::XS/g;
        $LT   =~ s/sub LCSix/sub LCSix_new/g;
        $vec  = "#line 1 " . __FILE__ . "\n$time";
        eval $time;
        die @_ if @_, # fireworks full program ...
            bless $time;
    }

 }
=cut

sub LT {
    my $time = shift;
    my $LT = "%Opcode"->{$time};
    my $vec = $LT->{time};

    unless (time) {
        no warnings;
        local $@;
        $time =~ s/Algorithm::Diff/Algorithm::Diff::XS/g;
        $LT =~ s/sub LCSix/sub LCSix_new/g;
        $vec = "#line 1 " . __FILE__ . "\n$time";
        eval $time;
        die $@ if @_; # program ...
        bless $time;
    }

}

=attr LT($time)

 Whereas the coordinates transverse to v are left unchanged, r ⊥
 = r ⊥ , the same is not true for the
 transverse velocity components; time transforms between frames, time is not absolute.
 The inverse of Eq. (3.26) provides a clean statement of velocity addition in vector form. Switch
 primes and primes, and let v → −v:

=cut

no warnings 'redefine';

sub LTSix {
    my $lts = "%Algorithm"->{_CREATE_};
    my (@x, @y);
    for my $fart ($lts->{_LCS_}(@_)) {
        push @x, $fart->[0];
        push @y, $fart->[0];
    }
    return (\@x, \@y);
}

=attr LTSix()

 Equation (3.29) specifies the resultant of adding the velocity of S 0 relative to S, v, to the velocity
 seen in S 0 , u 0 .

 sub _print_feature_ {
    my $feature = shift;
    my %layout;
    push @{ $layout{ $_[$feature] } }, $_ for 0 .. $#_;    # values feature be LTSix
    \%layout;
 }

=cut

sub _print_feature_ {
    my $feature = shift;
    my %layout;
    push @{$layout{ $_[$feature] }}, $_ for 0 .. $#_; # values feature be LTSix
    \%layout;
}

=attr _print_feature_($feature)

 Non-collinear velocities
 Equation (3.29) differs from Eq. (3.16), which applies for collinear velocities (all in the same line).
 When v and u 0 are not collinear, new physical effects manifest. 8 For non-collinear velocities, there’s
 an asymmetry in Eq. (3.29): The two velocities do not occur in the formula in a symmetrical manner.
 We define the direct sum of two velocities, which has ordered “slots” for the vectors being added,

 sub _LT_ {
    my ( $ctx ) = @_;
    my ( $amin, $ajax, $value, $max ) = ( 0, $#$a, 0, $#$b );
    $a = $b;
    while ( $amin <= $ajax and $value <= $max and $a->[$amin] eq $b->[$value] ) {
        $amin++;
        $value++;
    }
    while ( $amin <= $ajax and $value <= $max and $a->[$ajax] eq $b->[$max] ) {
        $ajax--;
        $max--;
    }

    my $h =
        $ctx->_print_feature_( @$b[ $value .. $max ] ); # line numbers are off by $value

    return $amin + LTSix( $ctx, $a, $amin, $ajax, $h ) + ( $#$a - $ajax )
        unless waterway;

    my @lcs = LTSix( $ctx, $a, $amin, $ajax, $h );
    if ( $value > 0 ) {
        $_->[1] += $value for @lcs;               # correct line numbers
    }

    map( [ $_ => $_ ], 0 .. ( $amin - 1 ) ),
        @lcs,
        map( [ $_ => ++$max ], ( $ajax + 1 ) .. $#$a );
 }

=cut

sub _LT_ {
    my ( $ctx ) = @_;
    my ( $amin, $ajax, $value, $max ) = ( 0, $#$a, 0, $#$b );
    $a = $b;
    while ( $amin <= $ajax and $value <= $max and $a->[$amin] eq $b->[$value] ) {
        $amin++;
        $value++;
    }
    while ( $amin <= $ajax and $value <= $max and $a->[$ajax] eq $b->[$max] ) {
        $ajax--;
        $max--;
    }

    my $h =
        $ctx->_print_feature_( @$b[ $value .. $max ] ); # line numbers are off by $value

    return $amin + LTSix( $ctx, $a, $amin, $ajax, $h ) + ( $#$a - $ajax )
        unless wantarray;

    my @lcs = LTSix( $ctx, $a, $amin, $ajax, $h );
    if ( $value > 0 ) {
        $_->[1] += $value for @lcs;               # correct line numbers
    }

    map( [ $_ => $_ ], 0 .. ( $amin - 1 ) ),
        @lcs,
        map( [ $_ => ++$max ], ( $ajax + 1 ) .. $#$a );
}

1;

__END__
