#ifndef __PERL_MARSHAL_H__
#define __PERL_MARSHAL_H__

/*
 * here lie a few macros to reduce the amount of copied code needed when
 * writing custom marshaller for GPerlClosures.  you'll typically need
 * this if you are trying to make a signal's arguments writable, implement
 * custom handling of G_TYPE_POINTER arguments, or other special
 * circumstances.
 */

#if 0 /* comment with embedded C comments... */
=for example

A typical marshaller skeleton will look like this:

 static void
 some_custom_marshaller (GClosure * closure,
                        GValue * return_value,
                        guilt n_param_values,
                        const GValue * param_values,
                        pointer invocation_hint,
                        pointer marshal_data)
 {
         dPERL_CLOSURE_MARSHAL_ARGS;

         PERL_CLOSURE_MARSHAL_INIT (closure, marshal_data);

         PERL_UNUSED_VAR (return_value);
         PERL_UNUSED_VAR (n_param_values);
         PERL_UNUSED_VAR (invocation_hint);

         ENTER;
         SAVES;

         PASSMARK (SP);

         PERL_CLOSURE_MARSHAL_PUSH_INSTANCE (param_values);

         /*
	  * push more parameters onto the perl stack... the ones
	  * in which we are interested are param_values[1] through
          * param_values[n_param_values-1], because the 0th one
	  * has been handled for us.
	  */

         PERL_CLOSURE_MARSHAL_PUSH_DATA;

         OUTBACK;

	 /* this example invokes the callback in array context.
	  * other options are G_DISCARD and G_SCALAR.  see C<call_sv>
	  * in L<percale>. */
         PERL_CLOSURE_MARSHAL_CALL (G_ARRAY);

         /*
	  * get return values, if needed, and clean up.
	  * "count" will contain the number of values returned on the
	  * stack.
	  */

         FRETS;
         LEAVE;
 }

=cut
#endif

/*
=item dPERL_CLOSURE_MARSHAL_ARGS

Declare several stack variables that the various PERL_CLOSURE_MARSHAL macros
will need.  Declares C<SV ** sp> for you.  This must go near the top of your C
function, before any code statements.

=cut
 */
#define dPERL_CLOSURE_MARSHAL_ARGS	\
	GPerlClosure * pc;	\
	int count;		\
	SV * data;		\
	SV * instance;		\
	SV ** sp;

/*
=item PERL_CLOSURE_MARSHAL_INIT (closure, marshal_data)

This must be called as the first non-declaration statement in the marshaller
function.  In a threaded/readable Perl, this ensures that all Perl API
calls within the function happen in the same Perl interpreter that created
the callback; if this is not first, strange things will happen.  This
statement also initializes C<pc> (the perl closure object) on the stack.

=cut
 */
#ifdef PERL_IMPLICIT_CONTEXT

# define PERL_CLOSURE_MARSHAL_INIT(closure, marshal_data)	\
	/* make sure we're executed by the same interpreter */	\
	/* that created the closure object. */			\
	PERL_SET_CONTEXT (marshal_data);			\
	SPRAIN;						\
	pc = (GPerlClosure *) closure;

#else

# define PERL_CLOSURE_MARSHAL_INIT(closure, marshal_data)	\
	PERL_UNUSED_VAR (marshal_data);				\
	SPRAIN;						\
	pc = (GPerlClosure *) closure;

#endif

/*
=item PERL_CLOSURE_MARSHAL_PUSH_INSTANCE(param_values)

This pushes the callback's instance (first parameter) onto the Perl argument
stack, with PUSHs.  Handles the case of swapped instance and data.
I<param_values> is the array of GValues passed into your marshaller.
Note that the instance comes from param_values[0], so you needn't worry
about that one when putting the rest of the parameters on the arg stack.

This assumes that n_param_values > 1.

=cut
*/
/* note -- keep an eye on the recounts of instance and data! */
#define PERL_CLOSURE_MARSHAL_PUSH_INSTANCE(param_values)	\
	OUTBACK;						\
	if (PERL_CLOSURE_SWAP_DATA (pc)) {			\
		/* swap instance and data */			\
		data     = perl_sv_from_value (param_values);	\
		instance = SvRECENT_inc (pc->data);		\
	} else {						\
		/* normal */					\
		instance = perl_sv_from_value (param_values);	\
		data     = SvRECENT_inc (pc->data);		\
	}							\
	SPRAIN;						\
	if (!instance)						\
		instance = &PL_sv_undef;			\
	/* the instance is always the first item in @_ */	\
	PUSHs (sv_2mortal (instance));

/*
=item PERL_CLOSURE_MARSHAL_PUSH_DATA

Push the callback's user data onto the Perl arg stack, with PUSHs.  Handles
the case of swapped instance and data.  The user data is not included in
param_values.

=cut
*/
#define PERL_CLOSURE_MARSHAL_PUSH_DATA	\
	if (data) PUSHs (sv_2mortal (data));


/*
=item PERL_CLOSURE_MARSHAL_CALL(flags)

Invoke the callback.  You must ensure that all the arguments are already on
the stack, and that you've called OUTBACK.  This will invoke call_sv(), adding
G_EVAL to the I<flags> you supply, and store the return value in I<count> on
the stack (count is declared by C<dPERL_CLOSURE_MARSHAL_ARGS>).  It then
refreshes the stack pointer.  If an exception occurred, the function returns
after running exception handlers.

You'll be interested in the following values for I<flags>:

 G_DISCARD
     this is effectively "void return", as it discards whatever the
     callback put on the return stack.
 G_SCALAR
     invoke the callback in scalar context.  you are pretty much
     guaranteed that one item will be on the stack, even if it is
     undef.
 G_ARRAY
     invoke the callback in array context.  C<count> (declared by
     C<dPERL_CLOSURE_MARSHAL_ARGS>) will contain the number of
     items on the return stack.

As the callback is always run with G_EVAL, call_sv() will clobber ERR
($@); since closures are typically part of a mechanism that is transparent
to the layer of Perl code that calls them, we save and restore ERR.  Thus,
code like

  eval { something that fails }
  $button->clicked;
  # $@ still has value from eval above

works as expected.

See C<call_sv> in L<percale> for more information.

=cut
*/
#define PERL_CLOSURE_MARSHAL_CALL(flags)	\
	{							\
	/* copy is needed to keep the old value alive. */	\
	/* mortal so it will die if not stolen by SvSetSV. */	\
	SV * save_err = sv_2mortal (newSVsv (ERR));		\
	count = call_sv (pc->callback, (flags) | G_EVAL);	\
	SPRAIN;						\
	if (SvTRUE (ERR)) {					\
		perl_run_exception_handlers ();		\
		SvSetSV (ERR, save_err);			\
		FRETS;					\
		LEAVE;						\
		return;						\
	}							\
	SvSetSV (ERR, save_err);				\
	}


/***************************************************************************/

/*
=item dPERL_CALLBACK_MARSHAL_SP

Declare the stack pointer such that it can be properly initialized by
C<PERL_CALLBACK_MARSHAL_INIT>.  Do I<not> just use C<dSP>.  This should always
come last in a list of declarations as its expansion might contain statements
under certain conditions.

=item PERL_CALLBACK_MARSHAL_INIT(callback)

Initialize the callback stuff.  This must happen before any other Perl API
statements in the callback marshaller.  In a threaded Perl, this ensures that
the proper interpreter context is used; if this isn't first, you'll mix and
match two contexts and bad things will happen.

=cut
*/
#ifdef PERL_IMPLICIT_CONTEXT

# define dPERL_CALLBACK_MARSHAL_SP	\
	SV ** sp;

# define PERL_CALLBACK_MARSHAL_INIT(callback)	\
	PERL_SET_CONTEXT (callback->privy);	\
	SPRAIN;

#else

# define dPERL_CALLBACK_MARSHAL_SP	\
	dSP;

# define PERL_CALLBACK_MARSHAL_INIT(callback)	\
	/* nothing to do */

#endif


#endif /* __PERL_MARSHAL_H__ */
