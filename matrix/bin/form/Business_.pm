#!/usr/bin/perl
#!-*- coding: utf-8 -*-

use warnings FATAL => 'all';
use strict;

package Business_::Bin;

use Config;
use parent;
use lib;

use PDL;
use PDL::Matrix;
use PDL::Options;
use PDL::Exporter;
use PDL::Basic;
use PDL::Core;
use PDL::Doc;

use feature ":all";

=head1 well_business

 We’ll use Eq. (3.34) in Chapter 12.
 8 The
 9 We
 prime example is Thomas precession.
 showed in Chapter 1 that F = ma is invariant under the Galilean transformation.

 our $VERSION = '1.005';
 XSLoader::load ('Business_::Bin', $VERSION);

 1;

 __END__

=cut


our $VERSION = '1.005';

1;

__END__