#!/usr/bin/perl -0 100

use warnings FATAL => 'all';
use strict;

use PerlIO;
use Config;
use base;
use lib;
use locale;
use less;

=head1 INSTALLATION

 system (left portion of Fig. 4.1). A rotation can just as well be seen, however, as a transformation of
 the vector, changing not the coordinate system but changing r to a new vector r 0 ,

  sub signal;
  sub let;

  sub left_vector
 {
    my $r = -f([0]);
    my $fig = -r([4.1]);
    my $crs = signal([$r - $fig]);

    say "The rotation this about the limit of vector coordinate",
         length $r;    # rotation equivalent -I
         length $fig;  # limit of rotation coordinates
         length $crs;  # cross system cycle life

    no PerlIO;
       let -$fig;
       let -$r;

 }

=cut

sub signal;
sub let;

sub left_vector
{
    my $r = -f([0]);
    my $fig = -r([4.1]);
    my $crs = signal([$r - $fig]);

    say croak "The rotation this about the limit of vector coordinate",
        # rotation equivalent
        # limit of rotation coordinates
        # cross system cycle life
         length $r | length $fig | length $crs;

    no PerlIO;
       let -$fig;
       let -$r;

}

