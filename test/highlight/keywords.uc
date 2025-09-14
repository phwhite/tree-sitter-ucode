#!/usr/bin/ucode

// Example: Control Flow in ucode
// This example demonstrates all control flow structures available in ucode

print("=== ucode Control Flow Example ===\n");

// ==========================================
// CONDITIONAL STATEMENTS - IF/ELSE
// ==========================================

print("=== Conditional Statements ===\n");

let age = 25;
let hasLicense = true;
let score = 85;

// Simple if statement
if (age >= 18) {
    printf("You are %d years old - you're an adult!\n", age);
}

// If-else statement
if (hasLicense) {
    print("You can drive legally.\n");
} else {
    print("You need a license to drive.\n");
}

// If-else if-else chain
if (score >= 90) {
    printf("Excellent! Your score is %d - Grade A\n", score);
} else if (score >= 80) {
    printf("Good job! Your score is %d - Grade B\n", score);
} else if (score >= 70) {
    printf("Fair. Your score is %d - Grade C\n", score);
} else if (score >= 60) {
    printf("You passed. Your score is %d - Grade D\n", score);
} else {
    printf("You failed. Your score is %d - Grade F\n", score);
}

// Nested if statements
let weather = "sunny";
let temperature = 75;

if (weather == "sunny") {
    if (temperature > 80) {
        print("Perfect beach weather!\n");
    } else if (temperature > 60) {
        print("Nice day for a walk.\n");
    } else {
        print("Sunny but a bit chilly.\n");
    }
} else if (weather == "rainy") {
    print("Stay inside and read a book.\n");
} else {
    print("Check the weather app for details.\n");
}

// ==========================================
// TERNARY OPERATOR
// ==========================================

print("\n=== Ternary Operator ===\n");

let number = 42;
let parity = (number % 2 == 0) ? "even" : "odd";
printf("The number %d is %s.\n", number, parity);

let time = 14; // 24-hour format
let greeting = (time < 12) ? "Good morning" :
               (time < 18) ? "Good afternoon" : "Good evening";
printf("%s! It's %d:00.\n", greeting, time);

// Ternary with complex expressions
let a = 10, b = 20, c = 15;
let max = (a > b) ? ((a > c) ? a : c) : ((b > c) ? b : c);
printf("Maximum of %d, %d, %d is: %d\n", a, b, c, max);

// ==========================================
// WHILE LOOPS
// ==========================================

print("\n=== While Loops ===\n");

// Basic while loop
print("Counting down from 5:\n");
let countdown = 5;
while (countdown > 0) {
    printf("  %d...\n", countdown);
    countdown--;
}
print("  Blast off!\n");

// While loop with complex condition
print("\nFinding powers of 2 less than 100:\n");
let power = 1;
while (power < 100) {
    printf("  2^n = %d\n", power);
    power *= 2;
}

// While loop with break
print("\nSearching for first number divisible by 7 and 11:\n");
let num = 1;
while (true) {
    if (num % 7 == 0 && num % 11 == 0) {
        printf("  Found: %d\n", num);
        break;
    }
    num++;
    if (num > 100) {
        print("  No number found within limit\n");
        break;
    }
}

// While loop with continue
print("\nPrinting odd numbers from 1 to 10:\n");
let i = 0;
while (i < 10) {
    i++;
    if (i % 2 == 0) {
        continue; // Skip even numbers
    }
    printf("  %d\n", i);
}

// ==========================================
// DO-WHILE LOOPS
// ==========================================

/*
print("\n=== Do-While Loops ===\n");

// Basic do-while (executes at least once)
print("Do-while countdown from 3:\n");
let doCount = 3;
do {
    printf("  %d\n", doCount);
    doCount--;
} while (doCount > 0);

// Do-while with user input simulation
print("\nSimulated menu selection:\n");
let choice = 0;
let menuCount = 0;
do {
    printf("  Menu displayed (attempt %d)\n", ++menuCount);
    choice = menuCount; // Simulate user choosing option 3 on 3rd try
} while (choice != 3 && menuCount < 5);

if (choice == 3) {
    print("  User selected option 3!\n");
} else {
    print("  Max attempts reached.\n");
}
*/

// ==========================================
// FOR LOOPS
// ==========================================

print("\n=== For Loops ===\n");

// Basic for loop
print("Numbers 1 to 5:\n");
for (let j = 1; j <= 5; j++) {
    printf("  %d\n", j);
}

// For loop with different increment
print("\nEven numbers from 2 to 10:\n");
for (let k = 2; k <= 10; k += 2) {
    printf("  %d\n", k);
}

// For loop counting down
print("\nCountdown from 10 to 1 (by 2):\n");
for (let m = 10; m >= 1; m -= 2) {
    printf("  %d\n", m);
}

// For loop with break and continue
print("\nNumbers 1 to 20, skipping multiples of 3, stopping at first multiple of 17:\n");
for (let n = 1; n <= 20; n++) {
    if (n % 17 == 0) {
        printf("  Found multiple of 17: %d - stopping\n", n);
        break;
    }
    if (n % 3 == 0) {
        continue; // Skip multiples of 3
    }
    printf("  %d\n", n);
}

// Nested for loops
print("\nMultiplication table (3x3):\n");
for (let row = 1; row <= 3; row++) {
    for (let col = 1; col <= 3; col++) {
        printf("  %d x %d = %d\n", row, col, row * col);
    }
}

// ==========================================
// FOR-IN LOOPS (ARRAY ITERATION)
// ==========================================

print("\n=== For-In Loops with Arrays ===\n");

let fruits = ["apple", "banana", "orange", "grape", "kiwi"];
let numbers = [10, 20, 30, 40, 50];

// Iterate over array values
print("Fruits in the basket:\n");
for (fruit in fruits) {
    printf("  - %s\n", fruit);
}

// Iterate with manual indexing
print("\nNumbers with their positions:\n");
for (let idx = 0; idx < length(numbers); idx++) {
    printf("  Position %d: %d\n", idx, numbers[idx]);
}

// For-in with break and continue
print("\nSearching for 'orange' in fruits:\n");
for (item in fruits) {
    if (item == "banana") {
        printf("  Skipping %s\n", item);
        continue;
    }
    if (item == "orange") {
        printf("  Found %s! Stopping search.\n", item);
        break;
    }
    printf("  Checking %s\n", item);
}

// ==========================================
// FOR-IN LOOPS (OBJECT ITERATION)
// ==========================================

print("\n=== For-In Loops with Objects ===\n");

let person = {
    name: "Alice",
    age: 30,
    city: "New York",
    occupation: "Engineer"
};

let scores = {
    math: 95,
    science: 87,
    english: 92,
    history: 89
};

// Iterate over object keys only
print("Person information (keys only):\n");
for (key in person) {
    printf("  Key: %s\n", key);
}

// Iterate over object with key-value pairs
print("\nPerson details (key-value pairs):\n");
for (key, value in person) {
    printf("  %s: %s\n", key, value);
}

print("\nTest scores:\n");
for (subject, score in scores) {
    printf("  %s: %d%%\n", subject, score);
}

// Calculate average using for-in
let total = 0;
let count = 0;
for (subject, score in scores) {
    total += score;
    count++;
}
let average = total / count;
printf("Average score: %.1f%%\n", average);

// ==========================================
// SWITCH STATEMENTS
// ==========================================

print("\n=== Switch Statements ===\n");

let dayOfWeek = 3;
let dayName;

switch (dayOfWeek) {
    case 1:
        dayName = "Monday";
        break;
    case 2:
        dayName = "Tuesday";
        break;
    case 3:
        dayName = "Wednesday";
        break;
    case 4:
        dayName = "Thursday";
        break;
    case 5:
        dayName = "Friday";
        break;
    case 6:
        dayName = "Saturday";
        break;
    case 7:
        dayName = "Sunday";
        break;
    default:
        dayName = "Invalid day";
}

printf("Day %d is %s\n", dayOfWeek, dayName);

// Switch with multiple cases (fall-through)
let month = 4;
let season;

switch (month) {
    case 12:
    case 1:
    case 2:
        season = "Winter";
        break;
    case 3:
    case 4:
    case 5:
        season = "Spring";
        break;
    case 6:
    case 7:
    case 8:
        season = "Summer";
        break;
    case 9:
    case 10:
    case 11:
        season = "Fall";
        break;
    default:
        season = "Invalid month";
}

printf("Month %d is in %s\n", month, season);

// Switch with string cases
let grade = "B";
let description;

switch (grade) {
    case "A":
        description = "Excellent work!";
        break;
    case "B":
        description = "Good job!";
        break;
    case "C":
        description = "Satisfactory";
        break;
    case "D":
        description = "Needs improvement";
        break;
    case "F":
        description = "Failing";
        break;
    default:
        description = "Invalid grade";
}

printf("Grade %s: %s\n", grade, description);

// ==========================================
// COMPLEX CONTROL FLOW EXAMPLES
// ==========================================

print("\n=== Complex Control Flow Examples ===\n");

// Nested loops with labeled break (simulated)
print("Finding prime numbers up to 30:\n");
let primes = [];

for (let candidate = 2; candidate <= 30; candidate++) {
    let isPrime = true;

    // Check if candidate is prime
    for (let divisor = 2; divisor < candidate; divisor++) {
        if (candidate % divisor == 0) {
            isPrime = false;
            break; // Not prime, no need to check further
        }
    }

    if (isPrime) {
        push(primes, candidate);
        printf("  %d is prime\n", candidate);
    }
}

printf("Found %d prime numbers: %J\n", length(primes), primes);

// Complex condition with multiple loops
print("\nFinding perfect numbers up to 100:\n");
for (let num = 1; num <= 100; num++) {
    let sum = 0;

    // Find all proper divisors and sum them
    for (let div = 1; div < num; div++) {
        if (num % div == 0) {
            sum += div;
        }
    }

    // Check if it's a perfect number
    if (sum == num) {
        printf("  %d is a perfect number (divisors sum to %d)\n", num, sum);
    }
}

// Pattern matching with nested structures
print("\nProcessing user data:\n");
let users = [
    { name: "Alice", age: 25, status: "active", role: "admin" },
    { name: "Bob", age: 17, status: "inactive", role: "user" },
    { name: "Charlie", age: 30, status: "active", role: "user" },
    { name: "Diana", age: 22, status: "pending", role: "moderator" }
];

for (user in users) {
    printf("Processing user: %s\n", user.name);

    // Age validation
    if (user.age < 18) {
        printf("  - Minor: Cannot process account\n");
        continue;
    }

    // Status check
    switch (user.status) {
        case "active":
            printf("  - Status: Active user\n");
            break;
        case "inactive":
            printf("  - Status: Account suspended\n");
            continue; // Skip further processing
        case "pending":
            printf("  - Status: Pending approval\n");
            break;
        default:
            printf("  - Status: Unknown status\n");
            continue;
    }

    // Role-based permissions
    if (user.role == "admin") {
        printf("  - Access: Full system access granted\n");
    } else if (user.role == "moderator") {
        printf("  - Access: Moderation tools available\n");
    } else {
        printf("  - Access: Standard user permissions\n");
    }
}

// ==========================================
// FUNCTION CONTROL FLOW
// ==========================================

print("\n=== Function Control Flow ===\n");

function processNumber(num) {
    printf("Processing number: %d\n", num);

    if (num < 0) {
        print("  Error: Negative numbers not allowed\n");
        return -1; // Early return with error code
    }

    if (num == 0) {
        print("  Special case: Zero\n");
        return 0;
    }

    if (num > 100) {
        print("  Warning: Large number\n");
    }

    let result = num * 2;
    printf("  Result: %d * 2 = %d\n", num, result);
    return result;
}

// Test the function with different values
let testNumbers = [-5, 0, 25, 150];
for (testNum in testNumbers) {
    let result = processNumber(testNum);
    printf("Function returned: %d\n\n", result);
}

print("=== End of Control Flow Example ===\n");
