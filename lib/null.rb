class Object
	# +truthy?+ is +false+ iff we are +nil+, +false+, or an instance of NullClass.
	def truthy?
		true
	end

	# +falsy?+ is +true+ iff we are +nil+, +false+, or an instance of NullClass.
	def falsy?
		false
	end

	# This is an alias for +falsy?+.
	def !()
		falsy?
	end

	# Are we +null+?
	def null?
		false
	end

	# +null.to_nil?+ returns +nil+; everything else returns +self+.
	def to_nil?()
		self
	end

	# +obj.tap?()+ is equivalent to +obj.tap()+ unless +obj+ is an instance of
	# NullClass, in which case a block must still be given, but will not be
	# executed.
	def tap? # yield: self
		yield(self)
		self
	end
	
	def Maybe(value)
	  value.nil? ? NULL : value
	end
end

# Make falsy things tell you so.
module Falsiness
	def truthy? # :nodoc:
		false
	end

	def falsy? # :nodoc:
		true
	end

	def !() # :nodoc:
		true
	end
end

# Make boolean logic work with truthiness. Note that this makes these operators
# asymmetric in that calling boolean operators on +null+ will return +null+.

class NilClass
	include Falsiness
	def &(obj) false end
	def |(obj) !!obj end
	def ^(obj) !!obj end
end

class FalseClass
	include Falsiness
	def &(obj) false end
	def |(obj) !!obj end
	def ^(obj) !!obj end
end

class TrueClass
	def &(obj) !!obj end
	def |(obj)  true end
	def ^(obj)  !obj end
end

# An object including us will convert like +nil+.
module NillishConversions
	# +[]+
	def to_a() [] end
	alias to_ary to_a

	# +(0+0i)+
	def to_c() to_i.to_c end

	# +0.0+
	def to_f() to_i.to_f end

	# +0+
	def to_i() 0 end

	# +"null"+
	def to_json() 'null' end

	# +nil+
	def to_nil?() nil end

	# +nil+
	def to_param() nil end

	# +(0/1)+
	def to_r() to_i.to_r end
	alias rationalize to_r

	# +""+
	def to_s() '' end
	alias to_str to_s

	# +nil+
	def =~(obj) nil end
end

# Define boolean operators based on truthiness.
module TruthyBooleanOperators
	def &(obj) truthy? & obj end
	def |(obj) truthy? | obj end
	def ^(obj) truthy? ^ obj end
end

# Define +method_missing+ to return +self+.
module RecursiveMethodMissing
	# We always return +self+.
	def method_missing(meth, *args)
		self
	end
end

# We implement the Null Object Pattern, i.e. most methods called on us will
# return +self+. Also, boolean logical operators for +true+, +false+, and +nil+
# have been redefined so that they depend on the +falsy?+
class NullClass
	include Falsiness
	include TruthyBooleanOperators
	include RecursiveMethodMissing

	def     to_s()    nil end # +""+
	def     nil?()   true end # :nodoc:
	def    null?()   true end # :nodoc:
	def   empty?()   true end # :nodoc:
	def  to_nil?()    nil end # :nodoc:
	def  inspect() 'null' end # +"null"+
	def present?()  false end # :nodoc:

	# Require a block, but don't use it; then return +self+.
	def tap? # :nodoc:
		raise(LocalJumpError, 'no block given') unless block_given?
		self
	end

	# Make Numeric operations involving +null+ return +null+.
	def coerce(x)
		[null, null]
	end
end

# VoidClass instances act like NullClass instances except
class VoidClass < NullClass
	include NillishConversions

	# Become 0 in mathematical operations.
	def coerce(x) to_i.coerce(x) end
	def +(x) x end
	def -(x) -x end
	def *(x) x*self end
	def /(x) to_i/x end

	# +"void"+
	def inspect
		'void'
	end
end

NULL = NullClass.new
# This is an alias for +NULL+, which is an instance of NullObject.
def null
	NULL
end

VOID = VoidClass.new
# +void+ is an alias for +VOID+, which is like +null+, except that its +to_*+
# methods are like +nil+'s.
def void
	VOID
end
