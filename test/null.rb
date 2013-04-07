#!/usr/bin/env ruby
require_relative '../lib/null'
require 'test/unit'

class NullTest < Test::Unit::TestCase
	TRUTHY_TEST_OBJECTS = [1024, 4.20, 4, :twenty, Class.new, Object.new, true,
	                       method(:method), Array.new, {}, 0, 0.0]
	NULL_TEST_OBJECTS = [null, void, NullClass.instance, VoidClass.instance]

	TRUTHY_BOOLEAN_OBJECTS = [true]
	GENERATED_FALSIES = [false, nil]
	RECURSOR_TEST_OBJECTS = []

	[
		[TruthyBooleanOperators, TRUTHY_BOOLEAN_OBJECTS],
		[Falsiness, GENERATED_FALSIES],
		[RecursiveMethodMissing, RECURSOR_TEST_OBJECTS]
	].each do |mod, array|
		array << Object.new.extend(mod)
	end

	ALL_FALSIES = GENERATED_FALSIES + NULL_TEST_OBJECTS
	NON_NULL = TRUTHY_TEST_OBJECTS + TRUTHY_BOOLEAN_OBJECTS + GENERATED_FALSIES +
	           RECURSOR_TEST_OBJECTS + [false, nil]

	def test_truthiness
		TRUTHY_TEST_OBJECTS.each do |truthy|
			msg = "#{truthy} is false"
			assert truthy.truthy?, msg
			assert !truthy.falsy?, msg
			assert !!truthy, msg
		end

		ALL_FALSIES.each do |falsy|
			msg = "#{falsy} is false"
			assert !falsy.truthy?, msg
			assert falsy.falsy?, msg
			assert !falsy, msg
		end
	end

	def test_boolean_logic
		TRUTHY_BOOLEAN_OBJECTS.product(ALL_FALSIES).each do |truthy, falsy|
			if truthy.singleton_class.include?(TruthyBooleanOperators)
				assert_equal(true, truthy ^ falsy, "#{truthy} ^ #{falsy} is true")
				assert_equal(true, truthy | falsy, "#{truthy} | #{falsy} is false")
				assert_equal(false, truthy & falsy, "#{truthy} & #{falsy} is false")
			end

			if falsy.singleton_class.include?(TruthyBooleanOperators)
				assert_equal(true, falsy ^ truthy, "#{falsy} ^ #{truthy} is true")
				assert_equal(true, falsy | truthy, "#{falsy} | #{truthy} is true")
				assert_equal(false, falsy & truthy, "#{falsy} & #{truthy} is false")
			end
		end
	end

	def test_nil_checks
		assert !nil.null?
		assert nil.nil?
		assert_equal nil, nil.to_nil?()

		NON_NULL.each do |truthy|
			assert !truthy.null?

			tap_ran = false
			truthy.tap? do |t|
				tap_ran = true
				assert_equal(truthy, t)
			end
			assert tap_ran

			assert_equal truthy, truthy.to_nil?()
		end

		NULL_TEST_OBJECTS.each do |nto|
			assert nto.nil?
			assert nto.null?
			nto.tap? { flunk }
			assert_equal nil, nto.to_nil?()
		end
	end

	def test_sink
		NULL_TEST_OBJECTS.each do |nto|
			%w{ijfdn edfksliwsauli rdwjsnxs vdsjkg_njdc3ese objectifd kill! doom? fcs
				 noki i n self}.each do |func|
				[[5], [1,2], [], Array.new(50, :o), {a: null}].each do |msg|
					assert_equal(nto, nto.send(func, *msg))
					assert_equal(nto, nto.send(func, *msg){flunk})
				end
			end
		end

		assert_equal null, (5*8+1/1.7)**null
		assert_equal null, null + 5
		assert_equal null, null/0
		assert_equal null, (0 * null) + 5
	end

	def test_voidness
		assert_equal 48, (void+8)*6
		assert_equal 0, void + 0

		{
			void.to_a => [],
			void.to_ary => [],
			Array.new(void) => [],
			void.to_c => 0,
			void.to_param => nil,
			void.to_nil? => nil,
			(void =~ '') => nil,
			"#{void}" => '',
			void.rationalize => Rational(0, 1)
		}.each do |real, expected|
			assert_equal(expected, real)
		end
	end

	def test_to_null
		[nil, null, void].each do |obj|
			assert_equal(null, obj.to_null?)
		end

		TRUTHY_TEST_OBJECTS.each do |obj|
			assert_equal(obj, obj.to_null?)
		end

		assert_equal(false, false.to_null?)
	end
end
