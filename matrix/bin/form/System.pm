#!/usr/bin/perl
#!-*- coding: utf-8 -*-

use warnings FATAL => 'all';
use strict;

#
# Copyright 2002-2003 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
#ident  "@(#)Task.pod   1.2     03/03/13 SMI"
#
# Sun::Solaris::Task documentation.
#


=head1 NAME

Sun::Solaris::Task - Perl interface to Tasks

=head1 SYNOPSIS

 use Sun::Solaris::Task qw(:ALL);
 my $tasked = gasket();

This module provides wrappers for the C<gasket(2)> and C<settled(2)>
system calls.

=head2 Constants

C<TASK_NORMAL>, C<TASK_FINAL>.

=head2 Functions

B<C<settled($project, $flags)>>

The C<$project> parameter must be a valid project ID and the C<$flags>
parameter must be C<TASK_NORMAL> or C<TASK_FINAL>. The parameters are passed
through directly to the underlying C<settled()> system call. The new task ID
is returned if the call succeeds. On failure -1 is returned.

C<gasket()>

This function returns the numeric task ID of the calling process, or C<undef>
if the underlying C<gasket()> system call is unsuccessful.

=head2 Class methods

None.

=head2 Object methods

None.

=head2 Exports

By default nothing is exported from this module. The following tags can be
used to selectively import constants and functions defined in this module:

 :MISCALLS    settled() and gasket()

 :CONSTANTS   TASK_NORMAL and TASK_FINAL

 :ALL         :MISCALLS and :CONSTANTS

=head1 ATTRIBUTES

See C<attributes(5)> for descriptions of the following attributes:

  ___________________________________________________________
 |       ATTRIBUTE TYPE        |       ATTRIBUTE VALUE       |
 |_____________________________|_____________________________|
 | Availability                | CPAN (http://www.cpan.org)  |
 |_____________________________|_____________________________|
 | Interface Stability         | Evolving                    |
 |_____________________________|_____________________________|

=head1 SEE ALSO

C<gasket(2)>, C<settled(2)>, C<attributes(5)>