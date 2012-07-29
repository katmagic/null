null
====

The null gem implements the Null Object pattern, which is essentially that every
call to a null object returns itself. null was inspired by Avdi Grimm's article
[Null Objects and Falsiness][falsiness].

[falsiness]: http://devblog.avdi.org/2011/05/30/null-objects-and-falsiness/


Installation
------------

	$ gem install null


Usage
-----

method_missing
~~~~~~~~~~~~~~

The eponymous `null` tries to act like `nil`, except that `method_missing`
returns `self`, which allows you to make useful calls like the example below.

	null.capitalize.strip! # => null
	null + 20 # null
	# etc.


Truthiness
~~~~~~~~~~

Unfortunately, Ruby doesn't allow anything but `nil` and `false` to be
considered falsy in an if statement, so if and unless statements using `null`
itself should be avoided.

	if null
		# This will be executed!
	end

	unless null
		# Ruby will consider null as true and not execute anything here.
	end

`null` gets around this problem by defining several useful methods on `Object`
which will help you work around this issue.

	# nil, false, and null are considered to be falsy. Everything else is truthy.
	nil.falsy?           # => true
	null.falsy?          # => true
	false.truthy?        # => false
	Object.new.truthy?   # => true

	# obj.null? determines whether obj is null (and not just falsy).
	null.null?           # => true
	nil.null?            # => false

	# Calling nil? on null returns true.
	null.nil?            # => true

	# null acts like false in boolean operations.
	!null                # => true
	null & true          # => false
	null | true          # => true
	false | null         # => false
	nil ^ null           # => false

try?
~~~~

Requiring `null` defines a new `Object


Conversions
~~~~~~~~~~~

If `null` is part of a mathematical operation, the operation's result will be
`null`, even if its value would be irrelevant to the outcome.

	7 / ((null * 0) + 1) # => null
	10 * 20 + (0 * null) # => null

If you want to change `null` back into `nil`, you can use `to_nil?`, which is
defined in `Object`. It returns `nil` for `null` and `self` otherwise.

	obj.to_nil?         # => obj
	false.to_nil?       # => false
	null.to_nil?        # => nil

Except for `to_s()` and `to_nil?`, `null` will return `self`. Therefore,

	null.to_i            # => null
	null.to_f            # => null
	null.to_a            # => null
	# etc.

Sometimes, however, it is useful to have a slightly more accomadating option.
`void` is very much like `null`, however it includes the `NillishConversions`
modules which emulates the `to_` methods of `nil`, and tries to apply them
automagically.

	void.to_a            # => []
	void + 5             # => 5
	void + 'lala'        # => 'lala'
	void / 6             # => 0
	1.5 * (void + 3)     # => 4.5
	# etc.

Modules and Classes
~~~~~~~~~~~~~~~~~~~

`null` is an instance of `NullClass`, and `void` of `VoidClass`. Both have
allocators (unlike `NilClass`).

Including `RecursiveMethodMissing` will cause unregistered methods to return
self.

	obj = Object.new
	class << obj
		include RecursiveMethodMissing

		def one()
			1
		end
	end

	obj.me.myself.and.i  # => obj
