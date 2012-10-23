## &1. Numeric

1. Numeric
      |
   Integer    Float    Complex    BigDecimal    Rational
      |
   Fixnum    Bignum    # auto-convert
   ( <= 31bits)

2. All numeric objects are **IMMUTABLE**. (method will never change its value)

3. 0x 0X => Hexadecimal
   0b 0B => Binary
   0     => Octal

4. Float-point Literals

- <1. Integer / 0 => ZeroDivisionError
      Float   / 0 => Infinity # (1.0/0).to_s == "Infinity"
      0.0     / 0 => Nan (Not a Number)
- <2. division # __Ruby always rounds towards -INFINITY__
      7 / 3 => 2
      7 / -3 => -3 ( -2.33 -> -INFINITY )
      (-a/b) == (a/-b) != -(a/b)
