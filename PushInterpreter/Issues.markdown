# Issues, Changes and Things To Do

## Differences from Push 3.0

- did not implement `BOOLEAN.FROMINTEGER`; instead uses `int_isPositive()` to return a `bool` value when an integer is greater than or equal to 0
- did not implement `BOOLEAN.FROMFLOAT`; instead uses `float_isPositive()`
- did not implement `CODE.INSTRUCTIONS`
- did not implement `CODE.NOOP`
- Ranges
- `EXEC.DO*RANGE`
  - Was in Push 3.0: An iteration instruction that executes the top item on the EXEC stack a number of times that depends on the top two integers, while also pushing the loop counter onto the INTEGER stack for possible access during the execution of the body of the loop. This is similar to CODE.DO*COUNT except that it takes its code argument from the EXEC stack. The top integer is the "destination index" and the second integer is the "current index." First the code and the integer arguments are saved locally and popped. Then the integers are compared. If the integers are equal then the current index is pushed onto the INTEGER stack and the code (which is the "body" of the loop) is pushed onto the EXEC stack for subsequent execution. If the integers are not equal then the current index will still be pushed onto the INTEGER stack but two items will be pushed onto the EXEC stack -- first a recursive call to EXEC.DO*RANGE (with the same code and destination index, but with a current index that has been either incremented or decremented by 1 to be closer to the destination index) and then the body code. Note that the range is inclusive of both endpoints; a call with integer arguments 3 and 5 will cause its body to be executed 3 times, with the loop counter having the values 3, 4, and 5. Note also that one can specify a loop that "counts down" by providing a destination index that is less than the specified current index.
  - Now, that's `exec_countWithRange`, which pops a Range item (a..b) and the next Exec stack item `C`. If the range is closed `(a==b)` it will push a to the Int stack and `C` to the exec stack. If the range is not closed `(a!=b)`, it pushes the block `( C a (a_stepped..b) :exec_countWithRange C )` to the exec stack, which will (1) execute `C`, (2) push the counter `a` to the Int stack, (3) push the incremented range to the Range stack, and (4) repeat the cycle (until the range is closed).
- `CODE.DO*RANGE`
  - Was in Push 3.0: An iteration instruction that executes the top item on the CODE stack a number of times that depends on the top two integers, while also pushing the loop counter onto the INTEGER stack for possible access during the execution of the body of the loop. The top integer is the "destination index" and the second integer is the "current index." First the code and the integer arguments are saved locally and popped. Then the integers are compared. If the integers are equal then the current index is pushed onto the INTEGER stack and the code (which is the "body" of the loop) is pushed onto the EXEC stack for subsequent execution. If the integers are not equal then the current index will still be pushed onto the INTEGER stack but two items will be pushed onto the EXEC stack -- first a recursive call to CODE.DO*RANGE (with the same code and destination index, but with a current index that has been either incremented or decremented by 1 to be closer to the destination index) and then the body code. Note that the range is inclusive of both endpoints; a call with integer arguments 3 and 5 will cause its body to be executed 3 times, with the loop counter having the values 3, 4, and 5. Note also that one can specify a loop that "counts down" by providing a destination index that is less than the specified current index.
  - That is now `code_countWithRange()`, which pops a Range (a..b), and a code item C. If the Range is closed (a==b) it pushes the code item onto the exec stack; otherwise, it pushes `( C a (a_stepped..b) :exec_countWithRange C )`.



## New functionality

### To Do:

- `range_stepBy()`: moves first bound N closer to second, unless identical, where N is an Int; will not cross start and end; if `N < 0`, the first bound gets farther away; if a == b, destroys the Range
- `range_count_by()` : moves first bound `N` closer to second, unless identical, where `N` is an Int; if `N < 0`, the first bound moves away form the second; will not cross start and end; if a == b, destroys the Range after pushing `Int(a)`
- `range_split()` : pops `(a..b)` and an Int; if the Int `X` lies within `(a..b)`, produces `(a..x)` and `(x..b)`
- `range_median()` : pops `(a..b)`, pushes `Int(a+b/2)`
- `range_contract()` : pops `(a..b)`, pushes new Range with both extremes 1 step closer; destroys Range if `a==b`
- `range_contractBy()` : pops `(a..b)` and an Int `N`, pushes new Range with both extremes `N` steps closer; if `N < 0`, both extremes move apart by `N` each; destroys Range if `a==b`
- `range_isOverlapping()` : pops two ranges; pushes Boolean `T` if either overlaps the other at all, regardless of direction of either
- `range_isSubset()` : pops two ranges; pushes Boolean `T` if they are both the same direction, AND one is entirely within the other
- `range_shift()` : pops a range and an Int; adds the int to both extremes
- `range_scale()` : pops a range and an Int; multiples the int by both extremes



## Push 3.0 instruction coverage

### To Do:

(comments are quotes from http://faculty.hampshire.edu/lspector/push3-description.html where available)


- `BOOLEAN.RAND`
- `CODE.CONTAINER`: Pushes the "container" of the second CODE stack item within the first CODE stack item onto the CODE stack. If second item contains the first anywhere (i.e. in any nested list) then the container is the smallest sub-list that contains but is not equal to the first instance. For example, if the top piece of code is "( B ( C ( A ) ) ( D ( A ) ) )" and the second piece of code is "( A )" then this pushes ( C ( A ) ). Pushes an empty list if there is no such container.
- `CODE.CONTAINS`: Pushes TRUE on the BOOLEAN stack if the second CODE stack item contains the first CODE stack item anywhere (e.g. in a sub-list).
- `CODE.DISCREPANCY`: Pushes a measure of the discrepancy between the top two CODE stack items onto the INTEGER stack. This will be zero if the top two items are equivalent, and will be higher the 'more different' the items are from one another. The calculation is as follows
  1. Construct a list of all of the unique items in both of the lists (where uniqueness is determined by equalp). Sub-lists and atoms all count as items.
  2. Initialize the result to zero.
  3. For each unique item increment the result by the difference between the number of occurrences of the item in the two pieces of code.
  4. Push the result.
- `CODE.DO`: Recursively invokes the interpreter on the program on top of the CODE stack. After evaluation the CODE stack is popped; normally this pops the program that was just executed, but if the expression itself manipulates the stack then this final pop may end up popping something else.
- `CODE.DO*`: Like CODE.DO but pops the stack before, rather than after, the recursive execution.
- `CODE.DO*COUNT`: An iteration instruction that performs a loop (the body of which is taken from the CODE stack) the number of times indicated by the INTEGER argument, pushing an index (which runs from zero to one less than the number of iterations) onto the INTEGER stack prior to each execution of the loop body. This should be implemented as a macro that expands into a call to CODE.DO*RANGE. CODE.DO*COUNT takes a single INTEGER argument (the number of times that the loop will be executed) and a single CODE argument (the body of the loop). If the provided INTEGER argument is negative or zero then this becomes a NOOP. Otherwise it expands into:
  ( 0 <1 - IntegerArg> CODE.QUOTE <CodeArg> CODE.DO*RANGE )
- `CODE.DO*TIMES`: Like CODE.DO*COUNT but does not push the loop counter. This should be implemented as a macro that expands into CODE.DO*RANGE, similarly to the implementation of CODE.DO*COUNT, except that a call to INTEGER.POP should be tacked on to the front of the loop body code in the call to CODE.DO*RANGE. This call to INTEGER.POP will remove the loop counter, which will have been pushed by CODE.DO*RANGE, prior to the execution of the loop body.
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
- `EXEC.DO*COUNT`: An iteration instruction that performs a loop (the body of which is taken from the EXEC stack) the number of times indicated by the INTEGER argument, pushing an index (which runs from zero to one less than the number of iterations) onto the INTEGER stack prior to each execution of the loop body. This is similar to CODE.DO*COUNT except that it takes its code argument from the EXEC stack. This should be implemented as a macro that expands into a call to EXEC.DO*RANGE. EXEC.DO*COUNT takes a single INTEGER argument (the number of times that the loop will be executed) and a single EXEC argument (the body of the loop). If the provided INTEGER argument is negative or zero then this becomes a NOOP. Otherwise it expands into: `( 0 <1 - IntegerArg> EXEC.DO*RANGE <ExecArg> )`
- `EXEC.DO*TIMES`: Like EXEC.DO*COUNT but does not push the loop counter. This should be implemented as a macro that expands into EXEC.DO*RANGE, similarly to the implementation of EXEC.DO*COUNT, except that a call to INTEGER.POP should be tacked on to the front of the loop body code in the call to EXEC.DO*RANGE. This call to INTEGER.POP will remove the loop counter, which will have been pushed by EXEC.DO*RANGE, prior to the execution of the loop body.
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
