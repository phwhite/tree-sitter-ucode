#!/usr/bin/ucode

// Example: Operators in ucode
// This example demonstrates all the operators available in ucode

print("=== ucode Operators Example ===\n");

// ==========================================
// ARITHMETIC OPERATORS
// ==========================================

print("=== Arithmetic Operators ===\n");

let a = 10;
let b = 3;
let c = 2.5;

printf("Variables: a = %d, b = %d, c = %.1f\n\n", a, b, c);

// Basic arithmetic
printf("Addition:\n");
printf("  a + b = %d + %d = %d\n", a, b, a + b);
printf("  a + c = %d + %.1f = %.1f\n", a, c, a + c);

printf("\nSubtraction:\n");
printf("  a - b = %d - %d = %d\n", a, b, a - b);
printf("  b - a = %d - %d = %d\n", b, a, b - a);

printf("\nMultiplication:\n");
printf("  a * b = %d * %d = %d\n", a, b, a * b);
printf("  a * c = %d * %.1f = %.1f\n", a, c, a * c);

printf("\nDivision:\n");
printf("  a / b = %d / %d = %d (integer division)\n", a, b, a / b);
printf("  a / c = %d / %.1f = %.2f (float division)\n", a, c, a / c);
printf("  10.0 / 3.0 = %.3f\n", 10.0 / 3.0);

printf("\nModulo:\n");
printf("  a %% b = %d %% %d = %d\n", a, b, a % b);
printf("  17 %% 5 = %d\n", 17 % 5);

// Increment and decrement
printf("\nIncrement/Decrement:\n");
let x = 5;
printf("  x = %d\n", x);
printf("  ++x = %d (pre-increment)\n", ++x);
printf("  x++ = %d (post-increment, x is now %d)\n", x++, x);
printf("  --x = %d (pre-decrement)\n", --x);
printf("  x-- = %d (post-decrement, x is now %d)\n", x--, x);

// ==========================================
// BITWISE OPERATORS
// ==========================================

print("\n=== Bitwise Operators ===\n");

let num1 = 12;  // 1100 in binary
let num2 = 10;  // 1010 in binary

printf("Variables: num1 = %d (0x%X), num2 = %d (0x%X)\n\n", num1, num1, num2, num2);

printf("Bitwise AND (&):\n");
printf("  num1 & num2 = %d & %d = %d (0x%X)\n", num1, num2, num1 & num2, num1 & num2);

printf("\nBitwise OR (|):\n");
printf("  num1 | num2 = %d | %d = %d (0x%X)\n", num1, num2, num1 | num2, num1 | num2);

printf("\nBitwise XOR (^):\n");
printf("  num1 ^ num2 = %d ^ %d = %d (0x%X)\n", num1, num2, num1 ^ num2, num1 ^ num2);

printf("\nBitwise NOT (~):\n");
printf("  ~num1 = ~%d = %d\n", num1, ~num1);
printf("  ~num2 = ~%d = %d\n", num2, ~num2);

printf("\nLeft Shift (<<):\n");
printf("  num1 << 1 = %d << 1 = %d\n", num1, num1 << 1);
printf("  num1 << 2 = %d << 2 = %d\n", num1, num1 << 2);

printf("\nRight Shift (>>):\n");
printf("  num1 >> 1 = %d >> 1 = %d\n", num1, num1 >> 1);
printf("  num1 >> 2 = %d >> 2 = %d\n", num1, num1 >> 2);

// ==========================================
// COMPARISON OPERATORS
// ==========================================

print("\n=== Comparison Operators ===\n");

let val1 = 10;
let val2 = 20;
let val3 = 10;
let str1 = "10";
let str2 = "20";

printf("Variables: val1 = %d, val2 = %d, val3 = %d, str1 = '%s', str2 = '%s'\n\n", val1, val2, val3, str1, str2);

printf("Equality (==):\n");
printf("  val1 == val3 = %d == %d = %s\n", val1, val3, (val1 == val3) ? "true" : "false");
printf("  val1 == val2 = %d == %d = %s\n", val1, val2, (val1 == val2) ? "true" : "false");
printf("  val1 == str1 = %d == '%s' = %s (type coercion)\n", val1, str1, (val1 == str1) ? "true" : "false");

printf("\nInequality (!=):\n");
printf("  val1 != val2 = %d != %d = %s\n", val1, val2, (val1 != val2) ? "true" : "false");
printf("  val1 != val3 = %d != %d = %s\n", val1, val3, (val1 != val3) ? "true" : "false");

printf("\nStrict Equality (===):\n");
printf("  val1 === val3 = %d === %d = %s\n", val1, val3, (val1 === val3) ? "true" : "false");
printf("  val1 === str1 = %d === '%s' = %s (no coercion)\n", val1, str1, (val1 === str1) ? "true" : "false");

printf("\nStrict Inequality (!==):\n");
printf("  val1 !== str1 = %d !== '%s' = %s\n", val1, str1, (val1 !== str1) ? "true" : "false");

printf("\nLess Than (<):\n");
printf("  val1 < val2 = %d < %d = %s\n", val1, val2, (val1 < val2) ? "true" : "false");
printf("  val2 < val1 = %d < %d = %s\n", val2, val1, (val2 < val1) ? "true" : "false");

printf("\nLess Than or Equal (<=):\n");
printf("  val1 <= val3 = %d <= %d = %s\n", val1, val3, (val1 <= val3) ? "true" : "false");
printf("  val1 <= val2 = %d <= %d = %s\n", val1, val2, (val1 <= val2) ? "true" : "false");

printf("\nGreater Than (>):\n");
printf("  val2 > val1 = %d > %d = %s\n", val2, val1, (val2 > val1) ? "true" : "false");
printf("  val1 > val2 = %d > %d = %s\n", val1, val2, (val1 > val2) ? "true" : "false");

printf("\nGreater Than or Equal (>=):\n");
printf("  val2 >= val1 = %d >= %d = %s\n", val2, val1, (val2 >= val1) ? "true" : "false");
printf("  val1 >= val3 = %d >= %d = %s\n", val1, val3, (val1 >= val3) ? "true" : "false");

// String comparisons
printf("\nString Comparisons:\n");
printf("  'apple' < 'banana' = %s\n", ('apple' < 'banana') ? "true" : "false");
printf("  'zebra' > 'apple' = %s\n", ('zebra' > 'apple') ? "true" : "false");
printf("  'hello' == 'hello' = %s\n", ('hello' == 'hello') ? "true" : "false");

// ==========================================
// LOGICAL OPERATORS
// ==========================================

print("\n=== Logical Operators ===\n");

let t = true;
let f = false;
let truthy = "non-empty string";
let falsy = "";
let nullVal = null;

printf("Variables: t = %s, f = %s, truthy = '%s', falsy = '%s', nullVal = %J\n\n",
       t ? "true" : "false", f ? "true" : "false", truthy, falsy, nullVal);

printf("Logical AND (&&):\n");
printf("  t && t = %s && %s = %s\n", t ? "true" : "false", t ? "true" : "false", (t && t) ? "true" : "false");
printf("  t && f = %s && %s = %s\n", t ? "true" : "false", f ? "true" : "false", (t && f) ? "true" : "false");
printf("  f && t = %s && %s = %s\n", f ? "true" : "false", t ? "true" : "false", (f && t) ? "true" : "false");

printf("\nLogical OR (||):\n");
printf("  t || f = %s || %s = %s\n", t ? "true" : "false", f ? "true" : "false", (t || f) ? "true" : "false");
printf("  f || f = %s || %s = %s\n", f ? "true" : "false", f ? "true" : "false", (f || f) ? "true" : "false");
printf("  t || t = %s || %s = %s\n", t ? "true" : "false", t ? "true" : "false", (t || t) ? "true" : "false");

printf("\nLogical NOT (!):\n");
printf("  !t = !%s = %s\n", t ? "true" : "false", !t ? "true" : "false");
printf("  !f = !%s = %s\n", f ? "true" : "false", !f ? "true" : "false");
printf("  !truthy = !'%s' = %s\n", truthy, !truthy ? "true" : "false");
printf("  !falsy = !'%s' = %s\n", falsy, !falsy ? "true" : "false");
printf("  !nullVal = !%J = %s\n", nullVal, !nullVal ? "true" : "false");

printf("\nNullish Coalescing (??):\n");
printf("  nullVal ?? 'default' = %J ?? 'default' = %s\n", nullVal, nullVal ?? "default");
printf("  falsy ?? 'default' = '%s' ?? 'default' = %s\n", falsy, falsy ?? "default");
printf("  truthy ?? 'default' = '%s' ?? 'default' = %s\n", truthy, truthy ?? "default");

// ==========================================
// ASSIGNMENT OPERATORS
// ==========================================

print("\n=== Assignment Operators ===\n");

let assignVar = 10;
printf("Initial value: assignVar = %d\n", assignVar);

assignVar += 5;
printf("After += 5: assignVar = %d\n", assignVar);

assignVar -= 3;
printf("After -= 3: assignVar = %d\n", assignVar);

assignVar *= 2;
printf("After *= 2: assignVar = %d\n", assignVar);

assignVar /= 4;
printf("After /= 4: assignVar = %d\n", assignVar);

assignVar %= 5;
printf("After %%= 5: assignVar = %d\n", assignVar);

// Bitwise assignment operators
let bitwiseVar = 12;  // 1100 in binary
printf("\nBitwise assignment (starting with %d):\n", bitwiseVar);

bitwiseVar &= 10;  // 1010 in binary
printf("After &= 10: bitwiseVar = %d\n", bitwiseVar);

bitwiseVar |= 5;   // 0101 in binary
printf("After |= 5: bitwiseVar = %d\n", bitwiseVar);

bitwiseVar ^= 3;   // 0011 in binary
printf("After ^= 3: bitwiseVar = %d\n", bitwiseVar);

bitwiseVar <<= 1;
printf("After <<= 1: bitwiseVar = %d\n", bitwiseVar);

bitwiseVar >>= 2;
printf("After >>= 2: bitwiseVar = %d\n", bitwiseVar);

// ==========================================
// SPECIAL OPERATORS
// ==========================================

print("\n=== Special Operators ===\n");

// in operator
let testArray = [10, 20, 30];
let testObject = { name: "Alice", age: 30, city: "New York" };

printf("'in' operator with arrays:\n");
printf("  0 in testArray = %s\n", (0 in testArray) ? "true" : "false");
printf("  2 in testArray = %s\n", (2 in testArray) ? "true" : "false");
printf("  5 in testArray = %s\n", (5 in testArray) ? "true" : "false");

printf("\n'in' operator with objects:\n");
printf("  'name' in testObject = %s\n", ("name" in testObject) ? "true" : "false");
printf("  'age' in testObject = %s\n", ("age" in testObject) ? "true" : "false");
printf("  'email' in testObject = %s\n", ("email" in testObject) ? "true" : "false");

// delete operator
printf("\n'delete' operator:\n");
printf("  Before delete: testObject = %J\n", testObject);
delete testObject.city;
printf("  After delete testObject.city: testObject = %J\n", testObject);

// type() function
printf("\n'type()' function:\n");
let typeTestValues = [42, "string", true, null, [1,2,3], {key: "value"}];
for (let i = 0; i < length(typeTestValues); i++) {
    let val = typeTestValues[i];
    printf("  type(%J) = %s\n", val, type(val));
}

// Spread operator
printf("\nSpread operator (...):\n");
let arr1 = [1, 2, 3];
let arr2 = [4, 5, 6];
let combined = [...arr1, ...arr2];
printf("  arr1 = %J\n", arr1);
printf("  arr2 = %J\n", arr2);
printf("  [...arr1, ...arr2] = %J\n", combined);

let obj1 = { a: 1, b: 2 };
let obj2 = { c: 3, d: 4 };
let mergedObj = { ...obj1, ...obj2 };
printf("  obj1 = %J\n", obj1);
printf("  obj2 = %J\n", obj2);
printf("  {...obj1, ...obj2} = %J\n", mergedObj);

// ==========================================
// TERNARY OPERATOR
// ==========================================

print("\n=== Ternary Operator ===\n");

let score = 85;
let grade = (score >= 90) ? "A" :
            (score >= 80) ? "B" :
            (score >= 70) ? "C" :
            (score >= 60) ? "D" : "F";

printf("Score: %d, Grade: %s\n", score, grade);

let status = (score >= 60) ? "Pass" : "Fail";
printf("Status: %s\n", status);

// Nested ternary
let weather = "sunny";
let activity = (weather == "sunny") ? "go to beach" :
               (weather == "rainy") ? "stay inside" :
               (weather == "cloudy") ? "go for a walk" : "stay home";
printf("Weather is %s, so let's %s\n", weather, activity);

// ==========================================
// OPERATOR PRECEDENCE EXAMPLES
// ==========================================

print("\n=== Operator Precedence Examples ===\n");

printf("Arithmetic precedence:\n");
printf("  2 + 3 * 4 = %d (multiplication first)\n", 2 + 3 * 4);
printf("  (2 + 3) * 4 = %d (parentheses override)\n", (2 + 3) * 4);
printf("  10 - 6 / 2 = %d (division first)\n", 10 - 6 / 2);
printf("  (10 - 6) / 2 = %d (parentheses override)\n", (10 - 6) / 2);

printf("\nComparison and logical precedence:\n");
printf("  true || false && false = %s (AND before OR)\n", (true || false && false) ? "true" : "false");
printf("  (true || false) && false = %s (parentheses override)\n", ((true || false) && false) ? "true" : "false");
printf("  !true && false = %s (NOT has highest precedence)\n", (!true && false) ? "true" : "false");

printf("\nMixed precedence:\n");
printf("  5 > 3 && 2 < 4 = %s (comparisons before AND)\n", (5 > 3 && 2 < 4) ? "true" : "false");
printf("  1 + 2 > 2 * 1 = %s (arithmetic before comparison)\n", (1 + 2 > 2 * 1) ? "true" : "false");

print("\n=== End of Operators Example ===\n");
