/**
 * @file ucode grammar for tree-sitter
 * @author Max Brunsfeld <maxbrunsfeld@gmail.com>
 * @author Amaan Qureshi <amaanq12@gmail.com>
 * @author Paul White <phwhite@gmail.com>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: 'ucode',

  externals: ($) => [
    $._automatic_semicolon,
    $._template_chars,
    $._ternary_qmark,
    $.html_comment,
    '||',
    // We use escape sequence to tell the scanner if we're currently inside a string or template string, in which case
    // it should NOT parse html comments.
    $.escape_sequence,
    $.jsx_text,
  ],

  extras: ($) => [
    $.comment,
    $.html_comment,
    /[\s\p{Zs}\uFEFF\u2028\u2029\u2060\u200B]/,
  ],

  reserved: {
    // Reserved words based on JavaScript grammar, adapted for ucode
    global: ($) => [
      'break',
      'case',
      'catch',
      'const',
      'continue',
      'debugger',
      'default',
      'delete',
      'do',
      'else',
      'export',
      'false',
      'finally',
      'for',
      'function',
      'if',
      'import',
      'in',
      'null',
      'return',
      'switch',
      'throw',
      'true',
      'try',
      'typeof',
      'var',
      'void',
      'while',
      'with',
    ],
    properties: ($) => [],
  },

  supertypes: ($) => [
    $.statement,
    $.declaration,
    $.expression,
    $.primary_expression,
    $.pattern,
  ],

  inline: ($) => [
    $._call_signature,
    $._formal_parameter,
    $._expressions,
    $._semicolon,
    $._identifier,
    $._reserved_identifier,
    $._jsx_attribute,
    $._jsx_element_name,
    $._jsx_child,
    $._jsx_element,
    $._jsx_attribute_name,
    $._jsx_attribute_value,
    $._jsx_identifier,
    $._lhs_expression,
  ],

  precedences: ($) => [
    [
      'member',
      'template_call',
      'call',
      $.update_expression,
      'unary_void',
      'binary_exp',
      'binary_times',
      'binary_plus',
      'binary_shift',
      'binary_compare',
      'binary_relation',
      'binary_equality',
      'bitwise_and',
      'bitwise_xor',
      'bitwise_or',
      'logical_and',
      'logical_or',
      'ternary',
      'arrow',
      $.sequence_expression,
    ],
    ['assign', $.primary_expression],
    ['member', 'template_call', 'call', $.expression],
    ['declaration', 'literal'],
    [$.primary_expression, $.statement_block, 'object'],
    [$.meta_property, $.import],
    [$.import_statement, $.import],
    [$.export_statement, $.primary_expression],
    [$.lexical_declaration, $.primary_expression],
  ],

  conflicts: ($) => [
    [$.primary_expression, $._property_name],
    [$.primary_expression, $.method_definition],
    [$.primary_expression, $.rest_pattern],
    [$.primary_expression, $.pattern],
    [$.primary_expression, $._for_header],
    [$.variable_declarator, $._for_header],
    [$.assignment_expression, $.pattern],
    [$.assignment_expression, $._for_header],
    [$.assignment_expression, $._destructuring_pattern],
    [$.array, $.array_pattern],
    [$.object, $.object_pattern],
    [$.assignment_expression, $.object_assignment_pattern],
    [$.labeled_statement, $._property_name],
    [$.computed_property_name, $.array],
    [$.binary_expression, $._initializer],
  ],

  word: ($) => $.identifier,

  rules: {
    program: ($) => seq(optional($.hash_bang_line), repeat($.statement)),

    hash_bang_line: (_) => /#!.*/,

    //
    // Export declarations
    //

    export_statement: ($) =>
      choice(
        seq(
          'export',
          choice(
            seq('*', $._from_clause),
            seq($.namespace_export, $._from_clause),
            seq($.export_clause, $._from_clause),
            $.export_clause,
          ),
          $._semicolon,
        ),
        seq(
          'export',
          choice(
            field('declaration', $.declaration),
            seq(
              'default',
              choice(
                field('declaration', $.declaration),
                seq(field('value', $.expression), $._semicolon),
              ),
            ),
          ),
        ),
      ),

    namespace_export: ($) => seq('*', 'as', $._module_export_name),

    export_clause: ($) =>
      seq('{', commaSep($.export_specifier), optional(','), '}'),

    export_specifier: ($) =>
      seq(
        field('name', $._module_export_name),
        optional(seq('as', field('alias', $._module_export_name))),
      ),

    _module_export_name: ($) => choice($.identifier, $.string, 'default'),

    declaration: ($) =>
      choice(
        $.function_declaration,
        $.lexical_declaration,
        $.variable_declaration,
        $.using_declaration,
      ),

    //
    // Import declarations
    //

    import: (_) => token('import'),

    import_statement: ($) =>
      seq(
        'import',
        choice(seq($.import_clause, $._from_clause), field('source', $.string)),
        optional($.import_attribute),
        $._semicolon,
      ),

    import_clause: ($) =>
      choice(
        $.namespace_import,
        $.named_imports,
        seq(
          $.identifier,
          optional(seq(',', choice($.namespace_import, $.named_imports))),
        ),
      ),

    _from_clause: ($) => seq('from', field('source', $.string)),

    namespace_import: ($) => seq('*', 'as', $.identifier),

    named_imports: ($) =>
      seq('{', commaSep($.import_specifier), optional(','), '}'),

    import_specifier: ($) =>
      choice(
        field('name', $.identifier),
        seq(
          field('name', $._module_export_name),
          'as',
          field('alias', $.identifier),
        ),
      ),

    import_attribute: ($) => seq('with', $.object),

    //
    // Statements
    //

    statement: ($) =>
      choice(
        $.export_statement,
        $.import_statement,
        $.debugger_statement,
        $.expression_statement,
        $.declaration,
        $.statement_block,

        $.if_statement,
        $.switch_statement,
        $.for_statement,
        $.for_in_statement,
        $.while_statement,
        $.do_statement,
        $.try_statement,
        $.with_statement,

        $.break_statement,
        $.continue_statement,
        $.return_statement,
        $.throw_statement,
        $.empty_statement,
        $.labeled_statement,
      ),

    expression_statement: ($) => seq($._expressions, $._semicolon),

    variable_declaration: ($) =>
      seq('var', commaSep1($.variable_declarator), $._semicolon),

    lexical_declaration: ($) =>
      seq(
        field('kind', choice('let', 'const')),
        commaSep1($.variable_declarator),
        $._semicolon,
      ),

    using_declaration: ($) =>
      seq(
        field('kind', 'using'),
        commaSep1($.variable_declarator),
        $._semicolon,
      ),

    variable_declarator: ($) =>
      seq(
        field(
          'name',
          choice(
            $.identifier,
            alias('of', $.identifier),
            $._destructuring_pattern,
          ),
        ),
        optional($._initializer),
      ),

    statement_block: ($) =>
      prec.right(
        seq('{', repeat($.statement), '}', optional($._automatic_semicolon)),
      ),

    else_clause: ($) => seq('else', $.statement),

    if_statement: ($) =>
      prec.right(
        seq(
          'if',
          field('condition', $.parenthesized_expression),
          field('consequence', $.statement),
          optional(field('alternative', $.else_clause)),
        ),
      ),

    switch_statement: ($) =>
      seq(
        'switch',
        field('value', $.parenthesized_expression),
        field('body', $.switch_body),
      ),

    for_statement: ($) =>
      seq(
        'for',
        '(',
        choice(
          field(
            'initializer',
            choice($.lexical_declaration, $.variable_declaration),
          ),
          seq(field('initializer', $._expressions), ';'),
          field('initializer', $.empty_statement),
        ),
        field('condition', choice(seq($._expressions, ';'), $.empty_statement)),
        field('increment', optional($._expressions)),
        ')',
        field('body', $.statement),
      ),

    for_in_statement: ($) =>
      seq('for', $._for_header, field('body', $.statement)),

    _for_header: ($) =>
      seq(
        '(',
        choice(
          field('left', choice($._lhs_expression, $.parenthesized_expression)),
          seq(
            field('kind', 'var'),
            field(
              'left',
              choice(
                $.identifier,
                alias('of', $.identifier),
                $._destructuring_pattern,
              ),
            ),
            optional($._initializer),
          ),
          seq(
            field('kind', choice('let', 'const')),
            field(
              'left',
              choice(
                $.identifier,
                alias('of', $.identifier),
                $._destructuring_pattern,
              ),
            ),
            optional($._automatic_semicolon),
          ),
          seq(
            field('kind', 'using'),
            field(
              'left',
              choice(
                $.identifier,
                alias('of', $.identifier),
                $._destructuring_pattern,
              ),
            ),
            optional($._automatic_semicolon),
          ),
          // Support for ucode's for (key, value in obj) destructuring syntax
          seq(field('left', $.identifier), ',', field('value', $.identifier)),
          seq(
            field('kind', 'let'),
            field('left', $.identifier),
            ',',
            field('value', $.identifier),
          ),
        ),
        field('operator', choice('in', 'of')),
        field('right', $._expressions),
        ')',
      ),

    while_statement: ($) =>
      seq(
        'while',
        field('condition', $.parenthesized_expression),
        field('body', $.statement),
      ),

    do_statement: ($) =>
      prec.right(
        seq(
          'do',
          field('body', $.statement),
          'while',
          field('condition', $.parenthesized_expression),
          optional($._semicolon),
        ),
      ),

    try_statement: ($) =>
      seq(
        'try',
        field('body', $.statement_block),
        optional(field('handler', $.catch_clause)),
        optional(field('finalizer', $.finally_clause)),
      ),

    with_statement: ($) =>
      seq(
        'with',
        field('object', $.parenthesized_expression),
        field('body', $.statement),
      ),

    break_statement: ($) =>
      seq(
        'break',
        field('label', optional(alias($.identifier, $.statement_identifier))),
        $._semicolon,
      ),

    continue_statement: ($) =>
      seq(
        'continue',
        field('label', optional(alias($.identifier, $.statement_identifier))),
        $._semicolon,
      ),

    debugger_statement: ($) => seq('debugger', $._semicolon),

    return_statement: ($) =>
      seq('return', optional($._expressions), $._semicolon),

    throw_statement: ($) => seq('throw', $._expressions, $._semicolon),

    empty_statement: (_) => ';',

    labeled_statement: ($) =>
      prec.dynamic(
        -1,
        seq(
          field(
            'label',
            alias(
              choice($.identifier, $._reserved_identifier),
              $.statement_identifier,
            ),
          ),
          ':',
          field('body', $.statement),
        ),
      ),

    //
    // Statement components
    //

    switch_body: ($) =>
      seq('{', repeat(choice($.switch_case, $.switch_default)), '}'),

    switch_case: ($) =>
      seq(
        'case',
        field('value', $._expressions),
        ':',
        field('body', repeat($.statement)),
      ),

    switch_default: ($) =>
      seq('default', ':', field('body', repeat($.statement))),

    catch_clause: ($) =>
      seq(
        'catch',
        optional(
          seq(
            '(',
            field('parameter', choice($.identifier, $._destructuring_pattern)),
            ')',
          ),
        ),
        field('body', $.statement_block),
      ),

    finally_clause: ($) => seq('finally', field('body', $.statement_block)),

    parenthesized_expression: ($) => seq('(', $._expressions, ')'),

    //
    // Expressions
    //
    _expressions: ($) => choice($.expression, $.sequence_expression),

    expression: ($) =>
      choice(
        $.primary_expression,
        $._jsx_element,
        $.assignment_expression,
        $.augmented_assignment_expression,
        $.arrow_function,
        $.unary_expression,
        $.binary_expression,
        $.ternary_expression,
        $.update_expression,
      ),

    primary_expression: ($) =>
      choice(
        $.subscript_expression,
        $.member_expression,
        $.parenthesized_expression,
        $._identifier,
        alias($._reserved_identifier, $.identifier),
        $.number,
        $.string,
        $.template_string,
        $.true,
        $.false,
        $.null,
        $.undefined,
        $.this,
        $.object,
        $.array,
        $.function_expression,
        $.meta_property,
        $.call_expression,
      ),

    object: ($) =>
      prec(
        'object',
        seq(
          '{',
          commaSep(
            optional(
              choice(
                $.pair,
                $.spread_element,
                $.method_definition,
                alias(
                  choice($.identifier, $._reserved_identifier),
                  $.shorthand_property_identifier,
                ),
              ),
            ),
          ),
          '}',
        ),
      ),

    object_pattern: ($) =>
      prec(
        'object',
        seq(
          '{',
          commaSep(
            optional(
              choice(
                $.pair_pattern,
                $.rest_pattern,
                $.object_assignment_pattern,
                alias(
                  choice($.identifier, $._reserved_identifier),
                  $.shorthand_property_identifier_pattern,
                ),
              ),
            ),
          ),
          '}',
        ),
      ),

    assignment_pattern: ($) =>
      seq(field('left', $.pattern), '=', field('right', $.expression)),

    object_assignment_pattern: ($) =>
      seq(
        field(
          'left',
          choice(
            alias(
              choice($._reserved_identifier, $.identifier),
              $.shorthand_property_identifier_pattern,
            ),
            $._destructuring_pattern,
          ),
        ),
        '=',
        field('right', $.expression),
      ),

    array: ($) =>
      seq('[', commaSep(optional(choice($.expression, $.spread_element))), ']'),

    array_pattern: ($) =>
      seq(
        '[',
        commaSep(optional(choice($.pattern, $.assignment_pattern))),
        ']',
      ),

    _jsx_element: ($) => choice($.jsx_element, $.jsx_self_closing_element),

    jsx_element: ($) =>
      seq(
        field('open_tag', $.jsx_opening_element),
        repeat($._jsx_child),
        field('close_tag', $.jsx_closing_element),
      ),

    // An entity can be named, numeric (decimal), or numeric (hexadecimal). The
    // longest entity name is 29 characters long, and the HTML spec says that
    // no more will ever be added.
    html_character_reference: (_) =>
      /&(#([xX][0-9a-fA-F]{1,6}|[0-9]{1,5})|[A-Za-z]{1,30});/,

    jsx_expression: ($) =>
      seq(
        '{',
        optional(choice($.expression, $.sequence_expression, $.spread_element)),
        '}',
      ),

    _jsx_child: ($) =>
      choice(
        $.jsx_text,
        $.html_character_reference,
        $._jsx_element,
        $.jsx_expression,
      ),

    jsx_opening_element: ($) =>
      prec.dynamic(
        -1,
        seq(
          '<',
          optional(
            seq(
              field('name', $._jsx_element_name),
              repeat(field('attribute', $._jsx_attribute)),
            ),
          ),
          '>',
        ),
      ),

    jsx_identifier: (_) => /[a-zA-Z_$][a-zA-Z\d_$]*-[a-zA-Z\d_$\-]*/,

    _jsx_identifier: ($) =>
      choice(alias($.jsx_identifier, $.identifier), $.identifier),

    nested_identifier: ($) =>
      prec(
        'member',
        seq(
          field(
            'object',
            choice(
              $.identifier,
              alias($.nested_identifier, $.member_expression),
            ),
          ),
          '.',
          field('property', alias($.identifier, $.property_identifier)),
        ),
      ),

    jsx_namespace_name: ($) => seq($._jsx_identifier, ':', $._jsx_identifier),

    _jsx_element_name: ($) =>
      choice(
        $._jsx_identifier,
        alias($.nested_identifier, $.member_expression),
        $.jsx_namespace_name,
      ),

    jsx_closing_element: ($) =>
      seq('</', optional(field('name', $._jsx_element_name)), '>'),

    jsx_self_closing_element: ($) =>
      seq(
        '<',
        field('name', $._jsx_element_name),
        repeat(field('attribute', $._jsx_attribute)),
        '/>',
      ),

    _jsx_attribute: ($) => choice($.jsx_attribute, $.jsx_expression),

    _jsx_attribute_name: ($) =>
      choice(
        alias($._jsx_identifier, $.property_identifier),
        $.jsx_namespace_name,
      ),

    jsx_attribute: ($) =>
      seq($._jsx_attribute_name, optional(seq('=', $._jsx_attribute_value))),

    _jsx_string: ($) =>
      choice(
        seq(
          '"',
          repeat(
            choice(
              alias($.unescaped_double_jsx_string_fragment, $.string_fragment),
              $.html_character_reference,
            ),
          ),
          '"',
        ),
        seq(
          '\'',
          repeat(
            choice(
              alias($.unescaped_single_jsx_string_fragment, $.string_fragment),
              $.html_character_reference,
            ),
          ),
          '\'',
        ),
      ),

    // Workaround to https://github.com/tree-sitter/tree-sitter/issues/1156
    // We give names to the token() constructs containing a regexp
    // so as to obtain a node in the CST.
    //
    unescaped_double_jsx_string_fragment: (_) =>
      token.immediate(prec(1, /([^"&]|&[^#A-Za-z])+/)),

    // same here
    unescaped_single_jsx_string_fragment: (_) =>
      token.immediate(prec(1, /([^'&]|&[^#A-Za-z])+/)),

    _jsx_attribute_value: ($) =>
      choice(alias($._jsx_string, $.string), $.jsx_expression, $._jsx_element),

    function_expression: ($) =>
      prec(
        'literal',
        seq(
          'function',
          field('name', optional($.identifier)),
          $._call_signature,
          field('body', $.statement_block),
        ),
      ),

    function_declaration: ($) =>
      prec.right(
        'declaration',
        seq(
          'function',
          field('name', $.identifier),
          $._call_signature,
          field('body', $.statement_block),
          optional($._automatic_semicolon),
        ),
      ),

    arrow_function: ($) =>
      prec(
        'arrow',
        seq(
          choice(
            field('parameter', $.identifier),
            field('parameters', $.formal_parameters),
          ),
          '=>',
          field('body', choice($.expression, $.statement_block)),
        ),
      ),

    // Override
    _call_signature: ($) => field('parameters', $.formal_parameters),
    _formal_parameter: ($) => choice($.pattern, $.assignment_pattern),

    optional_chain: (_) => '?.',

    call_expression: ($) =>
      choice(
        prec(
          'call',
          seq(
            field('function', choice($.expression, $.import)),
            field('arguments', $.arguments),
          ),
        ),
        prec(
          'template_call',
          seq(
            field('function', $.primary_expression),
            field('arguments', $.template_string),
          ),
        ),
        prec(
          'member',
          seq(
            field('function', $.primary_expression),
            field('optional_chain', $.optional_chain),
            field('arguments', $.arguments),
          ),
        ),
      ),

    member_expression: ($) =>
      prec(
        'member',
        seq(
          field('object', choice($.expression, $.primary_expression, $.import)),
          choice('.', field('optional_chain', $.optional_chain)),
          field(
            'property',
            reserved('properties', alias($.identifier, $.property_identifier)),
          ),
        ),
      ),

    subscript_expression: ($) =>
      prec.right(
        'member',
        seq(
          field('object', choice($.expression, $.primary_expression)),
          optional(field('optional_chain', $.optional_chain)),
          '[',
          field('index', $._expressions),
          ']',
        ),
      ),

    _lhs_expression: ($) =>
      choice(
        $.member_expression,
        $.subscript_expression,
        $._identifier,
        alias($._reserved_identifier, $.identifier),
        $._destructuring_pattern,
      ),

    assignment_expression: ($) =>
      prec.right(
        'assign',
        seq(
          field('left', choice($.parenthesized_expression, $._lhs_expression)),
          '=',
          field('right', $.expression),
        ),
      ),

    _augmented_assignment_lhs: ($) =>
      choice(
        $.member_expression,
        $.subscript_expression,
        alias($._reserved_identifier, $.identifier),
        $.identifier,
        $.parenthesized_expression,
      ),

    augmented_assignment_expression: ($) =>
      prec.right(
        'assign',
        seq(
          field('left', $._augmented_assignment_lhs),
          field(
            'operator',
            choice(
              '+=',
              '-=',
              '*=',
              '/=',
              '%=',
              '^=',
              '&=',
              '|=',
              '>>=',
              '>>>=',
              '<<=',
              '**=',
              '&&=',
              '||=',
              '??=',
            ),
          ),
          field('right', $.expression),
        ),
      ),

    _initializer: ($) => seq('=', field('value', $.expression)),

    _destructuring_pattern: ($) => choice($.object_pattern, $.array_pattern),

    spread_element: ($) => seq('...', $.expression),

    ternary_expression: ($) =>
      prec.right(
        'ternary',
        seq(
          field('condition', $.expression),
          alias($._ternary_qmark, '?'),
          field('consequence', $.expression),
          ':',
          field('alternative', $.expression),
        ),
      ),

    binary_expression: ($) =>
      choice(
        ...[
          ['&&', 'logical_and'],
          ['||', 'logical_or'],
          ['>>', 'binary_shift'],
          ['>>>', 'binary_shift'],
          ['<<', 'binary_shift'],
          ['&', 'bitwise_and'],
          ['^', 'bitwise_xor'],
          ['|', 'bitwise_or'],
          ['+', 'binary_plus'],
          ['-', 'binary_plus'],
          ['*', 'binary_times'],
          ['/', 'binary_times'],
          ['%', 'binary_times'],
          ['**', 'binary_exp', 'right'],
          ['<', 'binary_relation'],
          ['<=', 'binary_relation'],
          ['==', 'binary_equality'],
          ['===', 'binary_equality'],
          ['!=', 'binary_equality'],
          ['!==', 'binary_equality'],
          ['>=', 'binary_relation'],
          ['>', 'binary_relation'],
          ['??', 'ternary'],

          ['in', 'binary_relation'],
        ].map(([operator, precedence, associativity]) =>
          (associativity === 'right' ? prec.right : prec.left)(
            precedence,
            seq(
              field('left', $.expression),
              field('operator', operator),
              field('right', $.expression),
            ),
          ),
        ),
      ),

    unary_expression: ($) =>
      prec.left(
        'unary_void',
        seq(
          field(
            'operator',
            choice('!', '~', '-', '+', 'typeof', 'void', 'delete'),
          ),
          field('argument', $.expression),
        ),
      ),

    update_expression: ($) =>
      prec.left(
        choice(
          seq(
            field('argument', $.expression),
            field('operator', choice('++', '--')),
          ),
          seq(
            field('operator', choice('++', '--')),
            field('argument', $.expression),
          ),
        ),
      ),

    sequence_expression: ($) => prec.right(commaSep1($.expression)),

    //
    // Primitives
    //

    string: ($) =>
      choice(
        seq(
          '"',
          repeat(
            choice(
              alias($.unescaped_double_string_fragment, $.string_fragment),
              $.escape_sequence,
            ),
          ),
          '"',
        ),
        seq(
          '\'',
          repeat(
            choice(
              alias($.unescaped_single_string_fragment, $.string_fragment),
              $.escape_sequence,
            ),
          ),
          '\'',
        ),
      ),

    // Workaround to https://github.com/tree-sitter/tree-sitter/issues/1156
    // We give names to the token() constructs containing a regexp
    // so as to obtain a node in the CST.
    //
    unescaped_double_string_fragment: (_) =>
      token.immediate(prec(1, /[^"\\\r\n]+/)),

    // same here
    unescaped_single_string_fragment: (_) =>
      token.immediate(prec(1, /[^'\\\r\n]+/)),

    escape_sequence: (_) =>
      token.immediate(
        seq(
          '\\',
          choice(
            /[^xu0-7]/,
            /[0-7]{1,3}/,
            /x[0-9a-fA-F]{2}/,
            /u[0-9a-fA-F]{4}/,
            /u\{[0-9a-fA-F]+\}/,
            /[\r?][\n\u2028\u2029]/,
          ),
        ),
      ),

    // http://stackoverflow.com/questions/13014947/regex-to-match-a-c-style-multiline-comment/36328890#36328890
    comment: (_) =>
      token(
        choice(
          seq('//', /[^\r\n\u2028\u2029]*/),
          seq('/*', /[^*]*\*+([^/*][^*]*\*+)*/, '/'),
        ),
      ),

    template_string: ($) =>
      seq(
        '`',
        repeat(
          choice(
            alias($._template_chars, $.string_fragment),
            $.escape_sequence,
            $.template_substitution,
          ),
        ),
        '`',
      ),

    template_substitution: ($) => seq('${', $._expressions, '}'),

    number: (_) => {
      const hexLiteral = seq(choice('0x', '0X'), /[\da-fA-F](_?[\da-fA-F])*/);

      const decimalDigits = /\d(_?\d)*/;
      const signedInteger = seq(optional(choice('-', '+')), decimalDigits);
      const exponentPart = seq(choice('e', 'E'), signedInteger);

      const binaryLiteral = seq(choice('0b', '0B'), /[0-1](_?[0-1])*/);

      const octalLiteral = seq(choice('0o', '0O'), /[0-7](_?[0-7])*/);

      const bigintLiteral = seq(
        choice(hexLiteral, binaryLiteral, octalLiteral, decimalDigits),
        'n',
      );

      const decimalIntegerLiteral = choice(
        '0',
        seq(
          optional('0'),
          /[1-9]/,
          optional(seq(optional('_'), decimalDigits)),
        ),
      );

      const decimalLiteral = choice(
        seq(
          decimalIntegerLiteral,
          '.',
          optional(decimalDigits),
          optional(exponentPart),
        ),
        seq('.', decimalDigits, optional(exponentPart)),
        seq(decimalIntegerLiteral, exponentPart),
        decimalDigits,
      );

      return token(
        choice(
          hexLiteral,
          decimalLiteral,
          binaryLiteral,
          octalLiteral,
          bigintLiteral,
        ),
      );
    },

    // 'undefined' is syntactically a regular identifier in ucode.
    // However, its main use is as the read-only global variable whose
    // value is [undefined], for which there's no literal representation
    // unlike 'null'. We gave it its own rule so it's easy to
    // highlight in text editors and other applications.
    _identifier: ($) => choice($.undefined, $.identifier),

    identifier: (_) => {
      const alpha =
        /[^\x00-\x1F\s\p{Zs}0-9:;`"'@#.,|^&<=>+\-*/\\%?!~()\[\]{}\uFEFF\u2060\u200B\u2028\u2029]|\\u[0-9a-fA-F]{4}|\\u\{[0-9a-fA-F]+\}/;

      const alphanumeric =
        /[^\x00-\x1F\s\p{Zs}:;`"'@#.,|^&<=>+\-*/\\%?!~()\[\]{}\uFEFF\u2060\u200B\u2028\u2029]|\\u[0-9a-fA-F]{4}|\\u\{[0-9a-fA-F]+\}/;
      return token(seq(alpha, repeat(alphanumeric)));
    },

    meta_property: (_) => seq('import', '.', 'meta'),
    true: (_) => 'true',
    false: (_) => 'false',
    null: (_) => 'null',
    undefined: (_) => 'undefined',
    this: (_) => 'this',

    //
    // Expression components
    //

    arguments: ($) =>
      seq('(', commaSep(optional(choice($.expression, $.spread_element))), ')'),

    formal_parameters: ($) =>
      seq(
        '(',
        optional(seq(commaSep1($._formal_parameter), optional(','))),
        ')',
      ),

    // This negative dynamic precedence ensures that during error recovery,
    // unfinished constructs are generally treated as literal expressions,
    // not patterns.
    pattern: ($) => prec.dynamic(-1, choice($._lhs_expression, $.rest_pattern)),

    rest_pattern: ($) => prec.right(seq('...', $._lhs_expression)),

    method_definition: ($) =>
      seq(
        optional(choice('get', 'set')),
        field('name', $._property_name),
        field('parameters', $.formal_parameters),
        field('body', $.statement_block),
      ),

    pair: ($) =>
      seq(field('key', $._property_name), ':', field('value', $.expression)),

    pair_pattern: ($) =>
      seq(
        field('key', $._property_name),
        ':',
        field('value', choice($.pattern, $.assignment_pattern)),
      ),

    _property_name: ($) =>
      reserved(
        'properties',
        choice(
          alias(
            choice($.identifier, $._reserved_identifier),
            $.property_identifier,
          ),
          $.string,
          $.number,
          $.computed_property_name,
        ),
      ),

    computed_property_name: ($) => seq('[', $.expression, ']'),

    _reserved_identifier: (_) =>
      choice('get', 'set', 'static', 'export', 'let'),

    _semicolon: ($) => choice($._automatic_semicolon, ';'),
  },
});

/**
 * Creates a rule to match one or more of the rules separated by a comma
 *
 * @param {Rule} rule
 *
 * @returns {SeqRule}
 */
function commaSep1(rule) {
  return seq(rule, repeat(seq(',', rule)));
}

/**
 * Creates a rule to optionally match one or more of the rules separated by a comma
 *
 * @param {Rule} rule
 *
 * @returns {ChoiceRule}
 */
function commaSep(rule) {
  return optional(commaSep1(rule));
}
