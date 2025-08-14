/**
 * @file Parser for the ucode language
 * @author Jo-Philipp Wich <jo@mein.io>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

/*
 * Updated for Zed Editor Usage, by phwhite@gmail.com
 *
 * - Template strings with ${ ... } without lookahead
 * - property_identifier & shorthand_property_identifier via alias()
 * - No external scanner / libc dependencies
 */

const PREC = {
  sequence: 1,
  conditional: 3,
  assign: 2,
  logical_or: 4,
  logical_and: 5,
  bitwise_or: 6,
  bitwise_xor: 7,
  bitwise_and: 8,
  equality: 9,
  relational: 10,
  shift: 11,
  additive: 12,
  multiplicative: 13,
  unary: 14,
  update: 15,
  call: 16,
  member: 17,
  primary: 18,
};

module.exports = grammar({
  name: 'ucode',

  extras: $ => [/\s/, $.comment],

  supertypes: $ => [
    $._statement,
    $._declaration,
    $._expression,
    $.literal,
  ],

  word: $ => $.identifier,

  rules: {
    // ===== Program =====
    program: $ => seq(
      optional($.hash_bang_line),
      repeat($._statement)
    ),

    // ===== Comments =====
    // line: //...
    // block: /* ... */ (pattern avoids '*/' inside)
    comment: _ => token(choice(
      seq('//', /[^\n]*/),
      seq('/*', /([^*]|\*+[^*/])*/, '*/')
    )),

    // ===== Statements & Declarations =====
    _statement: $ => choice(
      $.import_statement,
      $._declaration,
      $.if_statement,
      $.while_statement,
      $.for_in_statement,
      $.return_statement,
      $.break_statement,
      $.continue_statement,
      $.block,
      $.expression_statement,
      ';' // empty statement
    ),

    _declaration: $ => choice(
      $.function_declaration,
      $.lexical_declaration,
      $.variable_declaration
    ),

    // Prefer "{}" as a block over "{}" as an object expression
    block: $ => prec.right(2, seq(
      '{',
      repeat($._statement),
      '}'
    )),

    // Expression statements are semicolon-terminated (no ASI)
    expression_statement: $ => seq($._expression, ';'),

    // if / else (dangling-else resolved: else binds to nearest if)
    if_statement: $ => choice(
      seq('if', '(', $._expression, ')', $._statement, 'else', $._statement),
      prec.right(seq('if', '(', $._expression, ')', $._statement))
    ),

    while_statement: $ => seq(
      'while', '(', $._expression, ')', $._statement
    ),

    // for (let x in expr) statement
    for_in_statement: $ => seq(
      'for', '(',
      choice(
        seq('let', $.identifier),
        seq('const', $.identifier),
        seq('var', $.identifier),
        $.identifier
      ),
      'in',
      $._expression,
      ')',
      $._statement
    ),

    // return/break/continue (strict semicolons)
    return_statement: $ => choice(
      seq('return', $._expression, ';'),
      seq('return', ';')
    ),
    break_statement:    $ => seq('break', ';'),
    continue_statement: $ => seq('continue', ';'),

    // ===== Declarations =====
    function_declaration: $ => seq(
      'function',
      field('name', $.identifier),
      $.formal_parameters,
      $.block
    ),

    formal_parameters: $ => seq(
      '(', optional(commaSep($.identifier)), ')'
    ),

    lexical_declaration:  $ => seq(choice('let', 'const'), commaSep1($.variable_declarator), ';'),
    variable_declaration: $ => seq('var', commaSep1($.variable_declarator), ';'),

    variable_declarator: $ => seq(
      field('name', $.identifier),
      optional(seq('=', field('value', $._expression)))
    ),

    // ===== Expressions =====
    _expression: $ => choice(
      $.assignment_expression,
      $.conditional_expression
    ),

    // Ternary
    conditional_expression: $ => prec.right(PREC.conditional, seq(
      $.logical_or_expression,
      optional(seq('?', $._expression, ':', $._expression))
    )),

    // Assignment
    assignment_expression: $ => prec.right(PREC.assign, seq(
      field('left', $.lhs_expression),
      field('operator', choice('=', '+=', '-=', '*=', '/=', '%=', '**=')),
      field('right', $._expression)
    )),

    lhs_expression: $ => choice(
      $.identifier,
      $.member_expression
    ),

    logical_or_expression: $ => prec.left(PREC.logical_or, seq(
      $.logical_and_expression,
      repeat(seq('||', $.logical_and_expression))
    )),

    logical_and_expression: $ => prec.left(PREC.logical_and, seq(
      $.bitwise_or_expression,
      repeat(seq('&&', $.bitwise_or_expression))
    )),

    bitwise_or_expression: $ => prec.left(PREC.bitwise_or, seq(
      $.bitwise_xor_expression,
      repeat(seq('|', $.bitwise_xor_expression))
    )),

    bitwise_xor_expression: $ => prec.left(PREC.bitwise_xor, seq(
      $.bitwise_and_expression,
      repeat(seq('^', $.bitwise_and_expression))
    )),

    bitwise_and_expression: $ => prec.left(PREC.bitwise_and, seq(
      $.equality_expression,
      repeat(seq('&', $.equality_expression))
    )),

    equality_expression: $ => prec.left(PREC.equality, seq(
      $.relational_expression,
      repeat(seq(choice('==', '===', '!=', '!=='), $.relational_expression))
    )),

    relational_expression: $ => prec.left(PREC.relational, seq(
      $.shift_expression,
      repeat(seq(choice('<', '<=', '>', '>='), $.shift_expression))
    )),

    shift_expression: $ => prec.left(PREC.shift, seq(
      $.additive_expression,
      repeat(seq(choice('<<', '>>', '>>>'), $.additive_expression))
    )),

    additive_expression: $ => prec.left(PREC.additive, choice(
      seq($.additive_expression, '+', $.multiplicative_expression),
      seq($.additive_expression, '-', $.multiplicative_expression),
      $.multiplicative_expression
    )),

    multiplicative_expression: $ => prec.left(PREC.multiplicative, choice(
      seq($.multiplicative_expression, '*', $.unary_expression),
      seq($.multiplicative_expression, '/', $.unary_expression),
      seq($.multiplicative_expression, '%', $.unary_expression),
      seq($.multiplicative_expression, '**', $.unary_expression),
      $.unary_expression
    )),

    unary_expression: $ => prec.right(PREC.unary, choice(
      seq(choice('+', '-', '!', 'typeof', 'void', 'delete'), $.unary_expression),
      $.update_expression
    )),

    update_expression: $ => prec.left(PREC.update, choice(
      seq(choice('++', '--'), $.member_expression),
      seq($.member_expression, choice('++', '--')),
      $.call_expression,
      $.primary_expression
    )),

    call_expression: $ => prec.left(PREC.call, seq(
      field('function', choice($.member_expression, $.identifier)),
      $.arguments
    )),

    arguments: $ => seq('(', optional(commaSep($._expression)), ')'),

    member_expression: $ => prec.left(PREC.member, choice(
      seq($.primary_expression, '.', field('property', $.identifier)),
      seq($.primary_expression, '[', $._expression, ']')
    )),

    primary_expression: $ => choice(
      $.identifier,
      $.literal,
      $.parenthesized_expression,
      $.array,
      $.object
    ),

    parenthesized_expression: $ => seq('(', $._expression, ')'),

    hash_bang_line: $ => token(seq('#!', /.*/)),

    import_statement: $ => prec.left(1, seq(
      'import',
      choice(
        field('source', $.string), // import 'mod'
        seq(field('clause', $.import_clause), 'from', field('source', $.string))
      )
    )),

    import_clause: $ => choice(
      field('default', $.identifier),
      $.import_namespace,
      $.import_named
    ),

    import_namespace: $ => seq('*', 'as', field('name', $.identifier)),

    import_named: $ => seq(
      '{', commaSep1($.import_specifier), optional(','), '}'
    ),

    import_specifier: $ => seq(
      field('name', $.identifier),
      optional(seq('as', field('alias', $.identifier)))
    ),

    // ===== Literals =====
    literal: $ => choice(
        $.number,
        $.string,
        $.true,
        $.false,
        $.null,
        $.template_string,
    ),

    number: _ => token(choice(
      /-?\d+\.\d+([eE][+-]?\d+)?/,
      /-?\d+([eE][+-]?\d+)?/
    )),

    string: $ => choice(
      seq('"', repeat(choice($.escape_sequence, token.immediate(/[^"\\]+/))), '"'),
      seq("'", repeat(choice($.escape_sequence, token.immediate(/[^'\\]+/))), "'"),
    ),

    true:  _ => 'true',
    false: _ => 'false',
    null:  _ => 'null',

    template_string: $ => seq(
      '`',
      repeat(choice(
        $.template_substitution,
        $.escape_sequence,
        // raw chunk (stop on backtick, $, or \)
        token.immediate(/[^`$\\]+/),
        // plain '$' that does NOT start a substitution (no look‑ahead needed)
        token.immediate(/\$/)
      )),
      '`'
    ),

    template_substitution: $ => seq(
      alias(token.immediate('${'), 'interpolation_start'),
      $._expression,               // or whatever your expression rule is named
      alias('}', 'interpolation_end')
    ),

    escape_sequence: _ => token.immediate(/\\./),


    // ===== Arrays & Objects =====
    array: $ => seq(
      '[', optional(commaSep($._expression)), ']'
    ),

    // Lower precedence than block to avoid "{};" ambiguity
    object: $ => prec(1, seq(
      '{',
      optional(commaSep(choice($.pair, $.property_shorthand))),
      '}'
    )),

    pair: $ => seq(
      field('key', choice(
        alias($.identifier, $.property_identifier),
        $.string,
        $.number
      )),
      ':',
      field('value', $._expression)
    ),

    property_shorthand: $ => field('name',
      alias($.identifier, $.shorthand_property_identifier)
    ),

    // ===== Identifiers =====
    identifier: _ => token(seq(
      /[A-Za-z_\$]/,
      /[A-Za-z0-9_\$]*/
    )),
  },
});

// ----- Helpers -----
function commaSep(rule)  { return seq(rule, repeat(seq(',', rule)), optional(',')); }
function commaSep1(rule) { return seq(rule, repeat(seq(',', rule)), optional(',')); }

