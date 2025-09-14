#!/usr/bin/ucode

// Example: Built-in Functions in ucode
// This example demonstrates all built-in functions available in ucode

print("=== ucode Built-in Functions Example ===\n");

// ==========================================
// TYPE AND INFORMATION FUNCTIONS
// ==========================================

print("=== Type and Information Functions ===\n");

let testValues = [
    null,
    true,
    false,
    42,
    3.14,
    "hello world",
    "",
    [1, 2, 3],
    [],
    { name: "Alice", age: 30 },
    {},
    function() { return "test"; }
];

print("Testing type() function:\n");
for (let i = 0; i < length(testValues); i++) {
    let value = testValues[i];
    printf("  type(%J) = %s\n", value, type(value));
}

print("\nTesting length() function:\n");
for (let i = 0; i < length(testValues); i++) {
    let value = testValues[i];
    let len = length(value);
    if (len !== null) {
        printf("  length(%J) = %d\n", value, len);
    }
}

print("\nTesting exists() function:\n");
let testObj = { a: 1, b: null, c: false, d: "" };
let testKeys = ["a", "b", "c", "d", "e"];
for (key in testKeys) {
    printf("  exists(testObj, '%s') = %s\n", key, exists(testObj, key) ? "true" : "false");
}

// ==========================================
// I/O FUNCTIONS
// ==========================================

print("\n=== I/O Functions ===\n");

// print() function
print("Testing print() function:\n");
print("  Single argument: ");
print("Hello");
print("\n  Multiple arguments: ");
print("Number:", 42, "String:", "test", "Boolean:", true);
print("\n");

// warn() function (outputs to stderr)
print("Testing warn() function (outputs to stderr):\n");
warn("This is a warning message\n");
warn("Multiple", "warning", "arguments", 123, "\n");

// printf() function
print("Testing printf() function:\n");
printf("  Integer: %d\n", 42);
printf("  Float: %.2f\n", 3.14159);
printf("  String: %s\n", "Hello World");
printf("  Hex: 0x%X\n", 255);
printf("  Octal: 0o%o\n", 64);
printf("  JSON: %J\n", { key: "value", num: 123 });
printf("  Multiple: %s has %d items, cost: $%.2f\n", "Basket", 5, 29.99);

// sprintf() function
print("Testing sprintf() function:\n");
let formatted1 = sprintf("User %s (ID: %d) logged in at %s", "Alice", 1001, "2024-01-15 10:30:00");
let formatted2 = sprintf("Temperature: %.1f°C, Humidity: %d%%", 23.7, 65);
printf("  formatted1: %s\n", formatted1);
printf("  formatted2: %s\n", formatted2);

// ==========================================
// ARRAY FUNCTIONS
// ==========================================

print("\n=== Array Functions ===\n");

let testArray = [1, 2, 3];
let fruits = ["apple", "banana"];
let numbers = [5, 2, 8, 1, 9];

// push() function
print("Testing push() function:\n");
printf("  Before push: testArray = %J\n", testArray);
push(testArray, 4);
printf("  After push(testArray, 4): %J\n", testArray);
push(testArray, 5, 6, 7);
printf("  After push(testArray, 5, 6, 7): %J\n", testArray);

// pop() function
print("Testing pop() function:\n");
printf("  Before pop: testArray = %J\n", testArray);
let popped = pop(testArray);
printf("  pop(testArray) returned: %d, array now: %J\n", popped, testArray);

// shift() function
print("Testing shift() function:\n");
printf("  Before shift: testArray = %J\n", testArray);
let shifted = shift(testArray);
printf("  shift(testArray) returned: %d, array now: %J\n", shifted, testArray);

// unshift() function
print("Testing unshift() function:\n");
printf("  Before unshift: testArray = %J\n", testArray);
unshift(testArray, 0);
printf("  After unshift(testArray, 0): %J\n", testArray);
unshift(testArray, -2, -1);
printf("  After unshift(testArray, -2, -1): %J\n", testArray);

// slice() function
print("Testing slice() function:\n");
let originalArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
printf("  Original: %J\n", originalArray);
printf("  slice(array, 2, 5): %J\n", slice(originalArray, 2, 5));
printf("  slice(array, 3): %J\n", slice(originalArray, 3));
printf("  slice(array, -3): %J\n", slice(originalArray, -3));
printf("  slice(array, 2, -2): %J\n", slice(originalArray, 2, -2));

// splice() function
print("Testing splice() function:\n");
let spliceArray = [1, 2, 3, 4, 5];
printf("  Before splice: %J\n", spliceArray);
let removed = splice(spliceArray, 2, 1, "a", "b");
printf("  After splice(array, 2, 1, 'a', 'b'): %J, removed: %J\n", spliceArray, removed);

// sort() function
print("Testing sort() function:\n");
let unsorted = [3, 1, 4, 1, 5, 9, 2, 6];
printf("  Before sort: %J\n", unsorted);
sort(unsorted);
printf("  After sort(): %J\n", unsorted);

let strings = ["banana", "apple", "cherry", "date"];
printf("  String array before sort: %J\n", strings);
sort(strings);
printf("  String array after sort: %J\n", strings);

// Custom sort with compareFn
let customSort = [10, 5, 40, 25, 1000, 1];
sort(customSort, function(a, b) { return length(a + "") - length(b + ""); });
printf("  Custom sort by string length: %J\n", customSort);

// reverse() function
print("Testing reverse() function:\n");
let reverseArray = [1, 2, 3, 4, 5];
printf("  Before reverse: %J\n", reverseArray);
reverse(reverseArray);
printf("  After reverse(): %J\n", reverseArray);

// join() function
print("Testing join() function:\n");
let joinArray = ["apple", "banana", "cherry"];
printf("  Array: %J\n", joinArray);
printf("  join(array, ', '): %s\n", join(joinArray, ", "));
printf("  join(array, ' | '): %s\n", join(joinArray, " | "));
printf("  join(array, ''): %s\n", join(joinArray, ""));

// index() and rindex() functions
print("Testing index() and rindex() functions:\n");
let searchArray = ["a", "b", "c", "b", "d"];
printf("  Array: %J\n", searchArray);
printf("  index(array, 'b'): %d\n", index(searchArray, "b"));
printf("  rindex(array, 'b'): %d\n", rindex(searchArray, "b"));
printf("  index(array, 'x'): %d\n", index(searchArray, "x"));

// uniq() function
print("Testing uniq() function:\n");
let duplicates = [1, 2, 2, 3, 1, 4, 3, 5];
printf("  Before uniq: %J\n", duplicates);
let unique = uniq(duplicates);
printf("  After uniq(): %J\n", unique);

// values() function (identity for arrays)
print("Testing values() function:\n");
let valuesArray = [10, 20, 30];
printf("  Array: %J\n", valuesArray);
printf("  values(array): %J\n", values(valuesArray));

// ==========================================
// ARRAY HIGHER-ORDER FUNCTIONS
// ==========================================

print("\n=== Array Higher-Order Functions ===\n");

let mapArray = [1, 2, 3, 4, 5];

// map() function
print("Testing map() function:\n");
printf("  Original: %J\n", mapArray);
let doubled = map(mapArray, function(x) { return x * 2; });
printf("  map(array, x => x * 2): %J\n", doubled);
let squared = map(mapArray, function(x) { return x * x; });
printf("  map(array, x => x * x): %J\n", squared);

// filter() function
print("Testing filter() function:\n");
let filterArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
printf("  Original: %J\n", filterArray);
let evens = filter(filterArray, function(x) { return x % 2 == 0; });
printf("  filter(array, x => x %% 2 == 0): %J\n", evens);
let greaterThanFive = filter(filterArray, function(x) { return x > 5; });
printf("  filter(array, x => x > 5): %J\n", greaterThanFive);

// ==========================================
// OBJECT FUNCTIONS
// ==========================================

print("\n=== Object Functions ===\n");

let testObject = {
    name: "Alice",
    age: 30,
    city: "New York",
    active: true
};

// keys() function
print("Testing keys() function:\n");
printf("  Object: %J\n", testObject);
let objectKeys = keys(testObject);
printf("  keys(object): %J\n", objectKeys);

// values() function
print("Testing values() function:\n");
let objectValues = values(testObject);
printf("  values(object): %J\n", objectValues);

// delete function/operator
print("Testing delete operator:\n");
let deleteObj = { a: 1, b: 2, c: 3 };
printf("  Before delete: %J\n", deleteObj);
delete deleteObj.b;
printf("  After delete deleteObj.b: %J\n", deleteObj);

// ==========================================
// STRING FUNCTIONS
// ==========================================

print("\n=== String Functions ===\n");

let testString = "Hello World! This is a test string.";
let multilineString = "  \n  Hello World  \n  ";

// substr() function
print("Testing substr() function:\n");
printf("  Original: '%s'\n", testString);
printf("  substr(string, 0, 5): '%s'\n", substr(testString, 0, 5));
printf("  substr(string, 6, 5): '%s'\n", substr(testString, 6, 5));
printf("  substr(string, 6): '%s'\n", substr(testString, 6));
printf("  substr(string, -6): '%s'\n", substr(testString, -6));

// Getting single character (equivalent to string[index] in other languages)
printf("  Character at index 1: '%s'\n", substr(testString, 1, 1));

// split() function
print("Testing split() function:\n");
printf("  Original: '%s'\n", testString);
let words = split(testString, " ");
printf("  split(string, ' '): %J\n", words);
let chars = split("hello", "");
printf("  split('hello', ''): %J\n", chars);
let limited = split(testString, " ", 3);
printf("  split(string, ' ', 3): %J\n", limited);

// trim functions
print("Testing trim functions:\n");
printf("  Original: '%s'\n", multilineString);
printf("  trim(string): '%s'\n", trim(multilineString));
printf("  ltrim(string): '%s'\n", ltrim(multilineString));
printf("  rtrim(string): '%s'\n", rtrim(multilineString));

// Case conversion
print("Testing case conversion:\n");
let mixedCase = "Hello World 123";
printf("  Original: '%s'\n", mixedCase);
printf("  lc(string): '%s'\n", lc(mixedCase));
printf("  uc(string): '%s'\n", uc(mixedCase));

// String search functions
print("Testing string search functions:\n");
let searchString = "The quick brown fox jumps over the lazy dog";
printf("  Original: '%s'\n", searchString);
printf("  index(string, 'fox'): %d\n", index(searchString, "fox"));
printf("  index(string, 'the'): %d (first occurrence)\n", index(searchString, "the"));
printf("  rindex(string, 'the'): %d (last occurrence)\n", rindex(searchString, "the"));
printf("  index(string, 'cat'): %d (not found)\n", index(searchString, "cat"));

// replace() function
print("Testing replace() function:\n");
let replaceString = "The cat sat on the mat";
printf("  Original: '%s'\n", replaceString);
printf("  replace(string, 'cat', 'dog'): '%s'\n", replace(replaceString, "cat", "dog"));
printf("  replace(string, 'the', 'a'): '%s' (first occurrence)\n", replace(replaceString, "the", "a"));

// Character code functions
print("Testing character code functions:\n");
printf("  ord('A'): %d\n", ord("A"));
printf("  ord('a'): %d\n", ord("a"));
printf("  ord('0'): %d\n", ord("0"));
printf("  chr(65): '%s'\n", chr(65));
printf("  chr(97): '%s'\n", chr(97));
printf("  chr(48): '%s'\n", chr(48));

// ==========================================
// NUMBER FUNCTIONS
// ==========================================

print("\n=== Number Functions ===\n");

// int() function
print("Testing int() function:\n");
printf("  int(3.14): %d\n", int(3.14));
printf("  int('42'): %d\n", int("42"));
printf("  int('3.9'): %d\n", int("3.9"));
printf("  int(true): %d\n", int(true));
printf("  int(false): %d\n", int(false));

// min() and max() functions
print("Testing min() and max() functions:\n");
printf("  min(5, 3, 8, 1, 9): %d\n", min(5, 3, 8, 1, 9));
printf("  max(5, 3, 8, 1, 9): %d\n", max(5, 3, 8, 1, 9));
printf("  min(-1, -5, -3): %d\n", min(-1, -5, -3));
printf("  max(-1, -5, -3): %d\n", max(-1, -5, -3));

// ==========================================
// JSON FUNCTIONS
// ==========================================

print("\n=== JSON Functions ===\n");

// json() function (parse JSON)
print("Testing json() function:\n");
let jsonString1 = '{"name": "Alice", "age": 30, "active": true}';
let jsonString2 = '[1, 2, 3, "hello", null]';
let jsonString3 = '"simple string"';
let jsonString4 = '42';

printf("  Parsing: %s\n", jsonString1);
let parsed1 = json(jsonString1);
printf("  Result: %J (type: %s)\n", parsed1, type(parsed1));

printf("  Parsing: %s\n", jsonString2);
let parsed2 = json(jsonString2);
printf("  Result: %J (type: %s)\n", parsed2, type(parsed2));

printf("  Parsing: %s\n", jsonString3);
let parsed3 = json(jsonString3);
printf("  Result: %J (type: %s)\n", parsed3, type(parsed3));

printf("  Parsing: %s\n", jsonString4);
let parsed4 = json(jsonString4);
printf("  Result: %J (type: %s)\n", parsed4, type(parsed4));

// ==========================================
// REGULAR EXPRESSION FUNCTIONS
// ==========================================

print("\n=== Regular Expression Functions ===\n");

let regexTestString = "The year 2024 has 365 days, and 2020 had 366 days.";

// match() function
print("Testing match() function:\n");
printf("  String: '%s'\n", regexTestString);
printf("  match(string, '[0-9]+'): %J\n", match(regexTestString, "[0-9]+"));
printf("  match(string, 'year'): %J\n", match(regexTestString, "year"));
printf("  match(string, 'month'): %J\n", match(regexTestString, "month"));

// Test different patterns
let emailTest = "Contact us at support@example.com or admin@test.org";
printf("  Email string: '%s'\n", emailTest);
printf("  match(string, '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}'): %J\n",
       match(emailTest, "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"));

// replace() with regex
print("Testing replace() with regex:\n");
printf("  Original: '%s'\n", regexTestString);
printf("  replace(string, '[0-9]+', 'YEAR'): '%s'\n",
       replace(regexTestString, "[0-9]+", "YEAR"));

// Global replace (if supported)
printf("  Global replace numbers with 'NUM': '%s'\n",
       replace(regexTestString, "[0-9]+", "NUM", "g"));

// ==========================================
// SYSTEM FUNCTIONS
// ==========================================

print("\n=== System Functions ===\n");

// gc() function
print("Testing gc() function:\n");
print("  Triggering garbage collection...\n");
gc();
print("  Garbage collection completed\n");

// sourcepath() function
print("Testing sourcepath() function:\n");
let currentPath = sourcepath();
printf("  Current source file: %s\n", currentPath);

// ==========================================
// DEMONSTRATION WITH REAL DATA
// ==========================================

print("\n=== Real-World Example ===\n");

// Process a list of user data
let users = [
    '{"name": "Alice Johnson", "email": "alice@company.com", "age": 28, "department": "Engineering"}',
    '{"name": "Bob Smith", "email": "bob@company.com", "age": 34, "department": "Marketing"}',
    '{"name": "Charlie Brown", "email": "charlie@company.com", "age": 29, "department": "Engineering"}',
    '{"name": "Diana Prince", "email": "diana@company.com", "age": 31, "department": "HR"}'
];

print("Processing user data:\n");

print("\nEngineers list:\n");
for (engineer in engineers) {
    printf("  - %s (%d years old) - %s\n",
           engineer.name, engineer.age, engineer.email);
}

// Generate summary report
let report = {
    total_users: length(parsedUsers),
    departments: {},
    timestamp: "2024-01-15T10:30:00Z"
};

// Count users per department
for (user in parsedUsers) {
    let dept = user.department;
    if (!(dept in report.departments)) {
        report.departments[dept] = 0;
    }
    report.departments[dept]++;
}

printf("\nGenerated report:\n%J\n", report);

print("\n=== End of Built-in Functions Example ===\n");
