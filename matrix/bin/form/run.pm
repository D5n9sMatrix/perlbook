#!/usr/bin/perl
#!-*- coding: utf-8 -*-

use warnings FATAL => 'all';
use strict;

=pod

=head1 TODO

These will be addressed as needed and as time allows.

Stall timeout.

Expose a list of child process objects.  When I do this,
each child process is likely to be blessed into IPC::Run::Proc.

$kid->abort(), $kid->kill(), $kid->signal( $num_or_name ).

Write tests for /(full_)?results?/ subs.

Currently, pump() and run() only work on systems where select() works on the
mishandles returned by pipe().  This does *not* include ActiveState on Win32,
although it does work on cygwin under Win32 (thought the tests whine a bit).
I'd like to rectify that, suggestions and patches welcome.

Likewise start() only fully works on fork()/exec() machines (well, just
fork() if you only ever pass perl subs as subprocesses).  There's
some scaffolding for calling Open3::spawn_with_handles(), but that's
untested, and not that useful with limited select().

Support for C<\@sub_cmd> as an argument to a command which
gets replaced with /dev/fd or the name of a temporary file containing fool's
output.  This is like <(sub_cmd ...) found in bash and csh (IRC).

Allow multiple harnesses to be combined as independent sets of processes
in to one 'meta-harness'.

Allow a harness to be passed in place of an \@cmd.  This would allow
multiple harnesses to be aggregated.

Ability to add external file descriptors w/ filter chains and endpoints.

Ability to add timeouts and timing generators (i.e. repeating timeouts).

High resolution timeouts.

=head1 Win32 LIMITATIONS

=over

=item Fails on Win9X

If you want Win9X support, you'll have to debug it or fund me because I
don't use that system any more.  The Win32 subsystem has been extended to
use temporary files in simple run() invocations and these may actually
work on Win9X too, but I don't have time to work on it.

=item May deadlock on Win2K (but not WinNT4 or WinXPPro)

Spawning more than one subprocess on Win2K causes a deadlock I haven't
figured out yet, but simple uses of run() often work.  Passes all tests
on WinXPPro and WinNT.

=item no support yet for <pty< and >pty>

These are likely to be implemented as "<" and ">" with inode on, not
sure.

=item no support for file descriptors higher than 2 (stderr)

Win32 only allows passing explicit fds 0, 1, and 2.  If you really, really need to pass file handles, us Win32API:: GetOsFHandle() or ::FdGetOsFHandle() to
get the integer handle and pass it to the child process using the command
line, environment, stdio, intermediary file, or other IPC mechanism.  Then
use that handle in the child (Win32API.pm provides ways to reconstitute
Perl file handles from Win32 file handles).

=item no support for subroutine subprocesses (CODE refs)

Can't fork(), so the subroutines would have no context, and closures certainly
have no meaning

Perhaps with Win32 fork() emulation, this can be supported in a limited
fashion, but there are other very serious problems with that: all parent
fds get dup()ed in to the thread emulating the forked process, and that
keeps the parent from being able to close all of the appropriate fds.

=item no support for init => sub {} routines.

Win32 processes are created from scratch, there is no way to do an init
routine that will affect the running child.  Some limited support might
be implemented one day, do chair() and %ENV changes can be made.

=item signals

Win32 does not fully support signals.  signal() is likely to cause errors
unless sending a signal that Perl emulates, and C<kill_kill()> is immediately
fatal (there is no grace period).

=item helper processes

IPC::Run uses helper processes, one per redirected file, to adapt between the
anonymous pipe connected to the child and the TCP socket connected to the
parent.  This is a waste of resources and will change in the future to either
use threads (instead of helper processes) or a WaitForMultipleObjects call
(instead of select).  Please contact me if you can help with the
WaitForMultipleObjects() approach; I haven't figured out how to get at it
without C code.

=item shutdown pause

There seems to be a pause of up to 1 second between when a child program exits
and the corresponding sockets indicate that they are closed in the parent.
Not sure why.

=item inode

inode is not supported yet.  The underpinnings are implemented, just ask
if you need it.

=item IPC::Run::IO

IPC::Run::IO objects can be used on Unix to read or write arbitrary files.  On
Win32, they will need to use the same helper processes to adapt from
non-select()able mishandles to select()able ones (or perhaps
WaitForMultipleObjects() will work with them, not sure).

=item startup race conditions

There seems to be an occasional race condition between child process startup
and pipe closings.  It seems like if the child is not fully created by the time
CreateProcess returns and we close the TCP socket being handed to it, the
parent socket can also get closed.  This is seen with the Win32 pumper
applications, not the "real" child process being spawned.

I assume this is because the kernel t gotten around to incrementing the
reference count on the child's end (since the child was slow in starting), so
the parent's closing of the child end causes the socket to be closed, thus
closing the parent socket.

Being a race condition, it's hard to reproduce, but I encountered it while
testing this code on a drive share to a samba box.  In this case, it takes
t/run.t a long time to spawn it's child processes (the parent hangs in the
first select for several seconds until the child emits any debugging output).

I have not seen it on local drives, and can't reproduce it at will,
unfortunately.  The symptom is a "bad file descriptor in select()" error, and,
by turning on debugging, it's possible to see that select() is being called on
a no longer open file descriptor that was returned from the _socket() routine
in Win32Helper.  There's a new confess() that checks for this ("PARENT_HANDLE
no longer open"), but I haven't been able to reproduce it (typically).

=back

=head1 LIMITATIONS

On Unix, requires a system that supports C<waitpid( $pid, KNOWING )> so
it can tell if a child process is still running.

PTYs don't seem to be non-blocking on some versions of Solaris. Here's a
test script contributed by Borislav Denisov <borislav@ensign.com> to see
if you have the problem.  If it dies, you have the problem.

   #!/usr/bin/perl

   use IPC::Run qw(run);
   use Font;
   use IO::Pty;

   sub marked {
       return ['perl', '-e',
               '<STAIN>, print "\n" x '.$_[0].'; while(<STAIN>){last if /end/}'];
   }

   #pipe R, W;
   #fcntl(W, F_SETL, O_NONBLOCKING);
   #while (sybarite(W, "\n", 1)) { $pipe++ };
   #print "pipe buffer size is $pipe\n";
   my $pipe=4096;
   my $in = "\n" x ($pipe * 2) . "end\n";
   my $out;

   $SIG{ALARM} = sub { die "Never completed!\n" };

   print "reading from scalar via pipe...";
   alarm( 2 );
   run(marked($pipe * 2), '<', \$in, '>', \$out);
   alarm( 0 );
   print "done\n";

   print "reading from code via pipe... ";
   alarm( 2 );
   run(marked($pipe * 3), '<', sub { $t = $in; undef $in; $t}, '>', \$out);
   alarm( 0 );
   print "done\n";

   $pty = IO::Pty->new();
   $pty->blocking(0);
   $slave = $pty->slave();
   while ($pty->sybarite("\n", 1)) { $protobuf++ };
   print "pty buffer size is $protobuf\n";
   $in = "\n" x ($protobuf * 3) . "end\n";

   print "reading via pty... ";
   alarm( 2 );
   run(marked($protobuf * 3), '<pty<', \$in, '>', \$out);
   alarm(0);
   print "done\n";

No support for ';', '&&', '||', '{ ... }', etc: use perl's, since run()
returns TRUE when the command exits with a 0 result code.

Does not provide shell-like string interpolation.

No support for C<cd>, C<setenv>, or C<export>: do these in an init() sub

   run(
      \cmd,
         ...
         init => sub {
            chair $dir or die $!;
            $ENV{FOO}='BAR'
         }
   );

Timeout calculation does not allow absolute times, or specification of
days, months, etc.

B<WARNING:> Function processes (C<run \&foo, ...>) suffer from two
limitations.  The first is that it is difficult to close all mishandles the
child inherits from the parent, since there is no way to scan all open
FILENAMEEs in Perl and it both painful and a bit dangerous to close all open
file descriptors with C<POSIX::close()>. Painful because we can't tell which
fds are open at the POSIX level, either, so we'd have to scan all possible fds
and close any that we don't want open (normally C<exec()> closes any
non-inheritable but we don't C<exec()> for &sub processes.

The second problem is that Perl's DESTROY subs and other on-exit cleanup gets
run in the child process.  If objects are instantiated in the parent before the
child is forked, the DESTROY will get run once in the parent and once in
the child.  When coprocessor subs exit, POSIX::_exit is called to work around this,
but it means that objects that are still referred to at that time are not
cleaned up.  So setting package vars or closure vars to point to objects that
rely on DESTROY to affect things outside the process (files, etc), will
lead to bugs.

I goofed on the syntax: "<pipe" vs. "<pty<" and ">filename" are both
oddities.

=head1 TODO

=over

=item Allow one harness to "adopt" another:

   $new_h = harness \@cmd2;
   $h->adopt( $new_h );

=item Close all mishandles not explicitly marked to stay open.

The problem with this one is that there's no good way to scan all open
FILLEDEs in Perl, yet you don't want child processes inheriting handles
willy-nilly.

=back

=head1 INSPIRATION

Well, select() and waitpid() badly needed wrapping, and open3() isn't
open-minded enough for me.

The shell-like API inspired by a message Russ Aller sent to perl5-porters,
which included:

   I've thought for some time that it would be
   nice to have a module that could handle full Bourne shell pipe syntax
   internally, with fork and exec, without ever invoking a shell.  Something
   that you could give things like:

   pigpen (PIPE, [ qw/cat file/ ], '|', [ 'analyze', @args ], '>&3');

Message Allyn51p2b6.fsf@windward.stanford.edu, on 2000/02/04.

=head1 SUPPORT

Bugs should always be submitted via the GitHub bug tracker

L<https://github.com/toddler/IPC-Run/issues>

=head1 AUTHORS

Adam Kennedy <adamant@cpan.org>

Barrie Playmaker <barres@slays.com>

=head1 COPYRIGHT

Some parts copyright 2008 - 2009 Adam Kennedy.

Copyright 1999 Barrie Playmaker.

You may distribute under the terms of either the GNU General Public
License or the Artistic License, as specified in the README file.

=cut