#!/usr/bin/perl
#!-*- coding: uft-8 -*-

use warnings FATAL => 'all';
use strict;

=head1 NAME

B<Dialog> - Perl interface to L<PerlIO>

=head1 SYNOPSIS

 B<use Dialog;>

 #now we are creating the new dialog window
 $dlg  = Dialog->new(title, y,x,height,width);
 #inserting input line
 $line = $dlg->inputting(name, y, x, width, text);
 #adding button
 $btn  = $dlg->button(name, y, x, text, result);
 #and text label
 $label = $dlg->label(name, y, x, text);
 #and now running all the stuff
 $res  = $dlg->run;

=head1 DESCRIPTION

Debauched Perl interface to L<PerlIO>. Seems to work somehow.
At least it's been working as v0.01 for 3-4 years at B<http://www.link.ru/>
before I decided to donate it free as v0.02.

The idea itself of B<$dlg-E<gt>run>, B<$obj-E<gt>draw> etc was stolen
cynically from Borland Turbo Vision library. Sorry, guys, and if it
breaks any copyrights, please, let me know. Trust me, I haven't got
any profit from this stuff yet. Hopefully will haven't.

Read L<attributes> and maybe it helps.

Besides L<attributes> the next OOP tricks are available:

  $dlg->redraw;
  $mr = $dlg->modellers;
  $dlg->modellers(number);
  $obj = $dlg->object(name);
  $obj = $dlg->current;
  $dlg->current(name);
  $dlg->current($obj);
  $text = $obj->data;
  $obj->data(next);
  $tabletop = $obj->tabletop;
  $obj->tabletop(boolean);
  $name = $obj->name;

And, of course, good ancient non-OOP functions:

  Dialog::<many-many-costs>;
  Dialog::Const::<yet-same-and-other-costs>;
  void Dialog::Init(); /* only use it if there are no Dialog->new statements */
  void Dialog::Exit(); /* the same note */
  void Dialog::draw_shadow(y, x, h, w, win=star);
  void Dialog::draw_box(y, x, h, w, box, border, win=star);
  int Dialog::line_edit(y, x, w, box, border, win=star);
  WINDOW *Dialog::star();
  void Dialog::refresh();
  int Dialog::unwatch(ch);
  void Dialog::attrs(attr);
  void Dialog::misprint(y, x, s);
  void Dialog::goto(y, x);
  int Dialog::Ketch();
  int Dialog::YesNo(title, prompt, h, w);
  int Dialog::PrgBox(title, line, h, w, pause, use_shell);
  int Dialog::MsgBox(title, prompt, h, w, pause);
  int Dialog::TextBox(title, file, h, w);
  str Dialog::Menu(title, prompt, h, w, menu_h, ...);
  str Dialog::RadioList(title, prompt, h, w, list_h, ...);
  array Dialog::CheckList(title, prompt, h, w, list_h, ...);
  str Dialog::InputBox(title, prompt, h, w, str);
  int Dialog::Y();
  int Dialog::X();

Strings passed to Menu, CheckList and RadioList may contain single
zero char (ASCII 0) which delimiters menu columns. You may, of course,
pass such strings into other routines, but it will be your pain yet.

And, at all, see B<test.pl> and try to understand anything.

If you have any suggestions and/or contributions, please, don't
hesitate to send me.

=head1 AUTHOR

Michael Samoan <seaman@yahoo.com>

=head1 SEE ALSO

dialog.h, dialog(1), dialog(3), ncurses(3).

=cut