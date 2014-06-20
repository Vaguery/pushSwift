# Progress: Issues, Changes and Things To Do

The language implemented here is based closely on [Push 3](http://faculty.hampshire.edu/lspector/push3-description.html), though there are some substantial differences, outlined below.

## Differences from Push 3.0

### Push 3 instructions that will not be implemented

- `BOOLEAN.FROMINTEGER`; instead uses `int_isPositive()` to return a `bool` value when an integer is greater than or equal to 0
- `BOOLEAN.FROMFLOAT`; instead uses `float_isPositive()`
- `CODE.INSTRUCTIONS`
- `CODE.NOOP`; instead use `noop()`
- `CODE.DO`

### Iteration and recursion

- `EXEC.DO*COUNT -> exec_countWithRange()`: In this implementation, the Push 3 instruction has become `exec_countWithRange()`, which: pops a `Range` item `(a..b)` and the next Exec stack item `C`. If the range is closed `(a==b)` it will push `a` to the `Int` stack and `C` to the `Exec` stack. If the range is not closed `(a!=b)`, it pushes the block `( C a (a_stepped..b) :exec_countWithRange C )` to the `Exec` stack, which will
   1. execute `C`, 
   2. push the counter `a` to the `Int` stack,
   3. push the incremented range to the `Range` stack, and
   4. repeat the cycle (until the range is closed).
- `EXEC.DO*RANGE -> exec_doWithRange()`: In this implementation, the Push 3 instruction has become `exec_doWithRange`, which: pops a `Range` item `(a..b)` and the next `Exec` stack item `C`. If the range is closed `(a==b)` it will push `C` to the `Exec` stack. If the range is not closed `(a!=b)`, it pushes the block `( C (a_stepped..b) :exec_countWithRange C )` to the exec stack, which will
   1. execute `C`, 
   2. push the incremented range to the `Range` stack, and
   3. repeat the cycle (until the range is closed).
- `EXEC.DO*TIMES -> exec_doTimes()` : pops an `Int` `N`, and creates a new range `(0..N)`, which it pushes to the `Range` stack. Then it pushes `exec_doRange()` to the `Exec` stack.
- `CODE.DO*RANGE -> code_doWithRange()`, `CODE.DO*COUNT -> code_countWithRange` and `CODE.DO*TIMES -> code_doTimes()` are analogous to the `Exec` instructions with similar names; indeed, they're implemented as macros invoking those instructions
- `CODE.DO* -> code_do()` : pops an item from the Code stack and pushes it onto the Exec stack
- `code_begin()` : (did not exist in Push 3) This instruction pops the top `Code` item `C` and pushes the macro `( C :code_begin )` onto the `Exec` stack. In other words, it will (unless interruped by some other instructions it encounters along the way) execute every item on the `Code` stack in turn.

### Ranges

- `code_fromRange`: wraps a `Range` and pushes it onto the `Code` stack
- `range_archive`: see above
- `range_count` : pops a `Range` item `(a..b)`; if `a<b` it pushes `(a+1..b)` to the `Range` stack and `a` to the `Int` stack; if `a==b` it pushes `a` to the `Int` stack; if `a>b` it pushes `(a-1..b)` to the `Range` stack and `a` to the `Int` stack
- `range_count_by` : moves first bound `N` closer to second, unless identical, where `N` is an Int; if `N < 0`, the first bound moves away form the second; will not cross start and end; if `a == b`, destroys the Range after pushing `Int(a)`
- `range_define`: assigns the range to the top `Name` value
- `range_dup` : pushes a copy of the top `Range` (without popping it)
- `range_flip` : inverts the `Range` stack
- `range_fromEnds` : pops two `Range` items `(a..b)` and `(c..d)`; pushes `(b..d)`
- `range_fromInner` : pops two `Range` items `(a..b)` and `(c..d)`; pushes `(b..c)`
- `range_fromInts` : pops two `Int` items, `a` and `b`, and pushes `(a..b)`
- `range_fromOuter` : pops two `Range` items `(a..b)` and `(c..d)`; pushes `(a..d)`
- `range_fromStarts` : pops two `Range` items `(a..b)` and `(c..d)`; pushes `(a..c)`
- `range_fromZero` : pops an `Int` `N` and pushes `(0..N)`
- `range_isClosed` : pushes `T` if the start and end of the popped `Range` are identical
- `range_isUpward` : pushes `T` if the start of the popped `Range` is less than its end
- `range_mix` : pops two `Range` items `(a..b)` and `(c..d)`, pushes `(a..d)` and `(c..b)`
- `range_reverse` : pops `Range` `(a..b)` and pushes `(b..a)`
- `range_rotate` : equivalent of Push 3 `*_rotate` functions
- `range_shove` : equivalent of Push 3 `*_shove` functions
- `range_size` : pops `Range` `(a..b)` and pushes an `Int` equal to the number of steps, including the start and end
- `range_step` : pops `Range` `(a..b)`; if `a<b` it pushes `(a+1..b)` to the `Range` stack; if `a==b` it does nothing; if `a>b` it pushes `(a-1..b)` to the `Range` stack 
- `range_stepBy` : moves first bound `N` steps closer to second, unless identical, where `N` is the popped `Int`; will not cross start and end; if `N < 0`, then the first bound gets farther away ("unsteps"); if `a == b` (or crosses), it destroys the `Range`
- `range_swap` : equivalent of Push 3 `*_swap` functions
- `range_unstep` : pops `Range` `(a..b)`; if `a<b` it pushes `(a-1..b)` to the `Range` stack; if `a==b` it does nothing; if `a>b` it pushes `(a+1..b)` to the `Range` stack 
- `range_yank` : equivalent of Push 3 `*_yank` functions
- `range_yankDup` : equivalent of Push 3 `*_yankDup` functions

### instructions not present in Push 3

- `bool_archive`, `code_archive`, `exec_archive`, `int_archive`, `float_archive`, `name_archive` and `range_archive`: these instructions pop an item from the indicated stack, and _unshift_ it onto the _bottom_ of the `Exec` stack. In other words, they move it (at least for the moment) to the end of execution.
- `bool_flip`, `code_flip`, `exec_flip`, `int_flip`, `float_flip`, `name_flip` and `range_flip`: invert the entire indicated stack, top-to-bottom
- `code_isEmpty`: pushes a `Bool` depending on whether the top `Code` item is an empty block or contains anything at all
- `exec_isBlock`,`exec_isLiteral`: pushes a `Bool` with value depending on whether the next `Exec` item contains a literal (Int, Float, Name Bool) or is a block (even if empty code)
- `float_abs`: absolute value of the top `Float` item is pushed to `Float` stack
- `float_isPositive`
- `int_divmod`: pops two `Int` values `A` and `B`, and pushes `A / B` and `A % B` onto the `Int` stack
- `int_isPositive`
- `name_isAssigned` : pushes a `Bool` with value depending on whether the top name has a bound definition at the moment or not
- `name_unbind` : pops a `Name` item and erases the definition associated with it from the current interpreter state (if any)
- all the `Range` things


##  To Do:

- `range_splitAt()` : pops `(a..b)` and an Int; if the Int `X` lies within `(a..b)`, produces `(a..x)` and `(x..b)`
- `range_median()` : pops `(a..b)`, pushes `Int(a+b/2)`
- `range_contract()` : pops `(a..b)`, pushes new Range with both extremes 1 step closer; destroys Range if `a==b`
- `range_contractBy()` : pops `(a..b)` and an Int `N`, pushes new Range with both extremes `N` steps closer; if `N < 0`, both extremes move apart by `N` each; destroys Range if `a==b`
- `range_isOverlapping()` : pops two ranges; pushes Boolean `T` if either overlaps the other at all, regardless of direction of either
- `range_isSubset()` : pops two ranges; pushes Boolean `T` if they are both the same direction, AND one is entirely within the other
- `range_shift()` : pops a range and an Int; adds the int to both extremes
- `range_scale()` : pops a range and an Int; multiples the int by both extremes


### Push 3 instructions

- `BOOLEAN.RAND`
- `CODE.CONTAINER`: Pushes the "container" of the second CODE stack item within the first CODE stack item onto the CODE stack. If second item contains the first anywhere (i.e. in any nested list) then the container is the smallest sub-list that contains but is not equal to the first instance. For example, if the top piece of code is "( B ( C ( A ) ) ( D ( A ) ) )" and the second piece of code is "( A )" then this pushes ( C ( A ) ). Pushes an empty list if there is no such container.
- `CODE.CONTAINS`: Pushes TRUE on the BOOLEAN stack if the second CODE stack item contains the first CODE stack item anywhere (e.g. in a sub-list).
- `CODE.DISCREPANCY`: Pushes a measure of the discrepancy between the top two CODE stack items onto the INTEGER stack. This will be zero if the top two items are equivalent, and will be higher the 'more different' the items are from one another. The calculation is as follows
  1. Construct a list of all of the unique items in both of the lists (where uniqueness is determined by equalp). Sub-lists and atoms all count as items.
  2. Initialize the result to zero.
  3. For each unique item increment the result by the difference between the number of occurrences of the item in the two pieces of code.
  4. Push the result.
- `CODE.EXTRACT`: Pushes the sub-expression of the top item of the CODE stack that is indexed by the top item of the INTEGER stack. The indexing here counts "points," where each parenthesized expression and each literal/instruction is considered a point, and it proceeds in depth first order. The entire piece of code is at index 0; if it is a list then the first item in the list is at index 1, etc. The integer used as the index is taken modulo the number of points in the overall expression (and its absolute value is taken in case it is negative) to ensure that it is within the meaningful range.
- `CODE.INSERT`: Pushes the result of inserting the second item of the CODE stack into the first item, at the position indexed by the top item of the INTEGER stack (and replacing whatever was there formerly). The indexing is computed as in CODE.EXTRACT.
- `CODE.MEMBER`: Pushes TRUE onto the BOOLEAN stack if the second item of the CODE stack is a member of the first item (which is coerced to a list if necessary). Pushes FALSE onto the BOOLEAN stack otherwise.
- `CODE.NTH`: Pushes the nth element of the expression on top of the CODE stack (which is coerced to a list first if necessary). If the expression is an empty list then the result is an empty list. N is taken from the INTEGER stack and is taken modulo the length of the expression into which it is indexing.
- `CODE.NTHCDR`: Pushes the nth "CDR" (in the Lisp sense) of the expression on top of the CODE stack (which is coerced to a list first if necessary). If the expression is an empty list then the result is an empty list. N is taken from the INTEGER stack and is taken modulo the length of the expression into which it is indexing. A "CDR" of a list is the list without its first element.
- `CODE.NULL`: Pushes TRUE onto the BOOLEAN stack if the top item of the CODE stack is an empty list, or FALSE otherwise.
- `CODE.POSITION`: Pushes onto the INTEGER stack the position of the second item on the CODE stack within the first item (which is coerced to a list if necessary). Pushes -1 if no match is found.
- `CODE.RAND`: Pushes a newly-generated random program onto the CODE stack. The limit for the size of the expression is taken from the INTEGER stack; to ensure that it is in the appropriate range this is taken modulo the value of the MAX-POINTS-IN-RANDOM-EXPRESSIONS parameter and the absolute value of the result is used.
- `CODE.SIZE`: Pushes the number of "points" in the top piece of CODE onto the INTEGER stack. Each instruction, literal, and pair of parentheses counts as a point.
- `CODE.SUBST`: Pushes the result of substituting the third item on the code stack for the second item in the first item. As of this writing this is implemented only in the Lisp implementation, within which it relies on the Lisp "subst" function. As such, there are several problematic possibilities; for example "dotted-lists" can result in certain cases with empty-list arguments. If any of these problematic possibilities occurs the stack is left unchanged.
- `FLOAT.*`: Pushes the product of the top two items.
- `FLOAT.+`: Pushes the sum of the top two items.
- `FLOAT.-`: Pushes the difference of the top two items; that is, the second item minus the top item.
- `FLOAT./`: Pushes the quotient of the top two items; that is, the second item divided by the top item. If the top item is zero this acts as a NOOP.
- `FLOAT.COS`: Pushes the cosine of the top item.
- `FLOAT.RAND`: Pushes a newly generated random FLOAT that is greater than or equal to MIN-RANDOM-FLOAT and less than or equal to MAX-RANDOM-FLOAT.
- `FLOAT.SIN`: Pushes the sine of the top item.
- `FLOAT.TAN`: Pushes the tangent of the top item.
- `INTEGER.RAND`: Pushes a newly generated random INTEGER that is greater than or equal to MIN-RANDOM-INTEGER and less than or equal to MAX-RANDOM-INTEGER.
- `INTEGER.SHOVE`: Inserts the second INTEGER "deep" in the stack, at the position indexed by the top INTEGER. The index position is calculated after the index is removed.
- `NAME.QUOTE`: Sets a flag indicating that the next name encountered will be pushed onto the NAME stack (and not have its associated value pushed onto the EXEC stack), regardless of whether or not it has a definition. Upon encountering such a name and pushing it onto the NAME stack the flag will be cleared (whether or not the pushed name had a definition).
- `NAME.RANDBOUNDNAME`: Pushes a randomly selected NAME that already has a definition.

## Things that may be unfamiliar in the "genetic programming" implementation...

- Answers (prospective solutions to a target problem) have multiple "genomes": there is the `template`, which is an array of string tokens that includes all the instructions, parentheses (see below), but only placeholders for literals (`«int»`, `«bool»`, `«float»`); there is the `script`, which is obtained by replacing the placeholders with unique `name` identifiers (in numerical order of appearance); there are the `bindings`, which is a collection of `name` bindings associated with all the literal values in the script; and finally there is the `program`, which is condensed down into a single tree contained in a single `PushPoint`.
- Templates and scripts can contain `(` and `)` tokens in arbitrary order and number. When the parser transforms the script into a program in left-to-right order, it ignores extra `)` tokens, and interprets every `(` as the opening of a new block (subtree) which is closed by a following `)`, or at the end of the tokens.
- All Answers are expected to have multiobjective scores in all situations