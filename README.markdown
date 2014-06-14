pushSwift
=========
A Mac desktop genetic programming system using a simple interpreted language based closely on the [PushGP system for genetic programming](http://faculty.hampshire.edu/lspector/push.html) (work by Lee Spector, Maarten Keijzer, Jon Klein, Chris Perry and Tom Helmuth, among others).

With some amendments.

## Why

To learn some TDD habits in XCode, and explore Apple's new Swift language. Which, after a week, means learning an awful lot of little places where Swift gives way to Cocoa... and that's OK.

## Status

- 6 June 2014: Just barely started.
- 14 June 2014: Push interpreter built, most trivial instructions running and tested. No I/O or UI at all, so it only runs in XCode under test. About to start building an `Answer` class, which will be the genetic programming "individuals".

## Features

- Push 3.0 types baked in: `Int`, `Bool`, `Float` (Double, in this case), `Code`, `Name`
- Off-label syntax: Unlike Push 3.0, the `(` and `)` tokens here are independent; the parser reads scripts left-to-right, and opens a new block when it encounters a `(`, closing as with normal syntax rules. But extra `)` encountered are ignored, and missing `)` after the script is fully parsed implicitly causes all open blocks to be closed immediately.
- Off-label Tozier-flavored types built in: `Range`, representing an oriented contiguous block of integers. Probably will also add the `Proportion` type (representing values confined to [0,1] and acting like probabilities), `Span` (representing segments of real number line, with Doubles as start and ending values and also oriented).
- Off-label instructions:
  - anything having to do with Ranges
  - some minor changes and improvements to inter-type conversion methods (notably `bool_from*` methods use the `sgn(x)` to determine the value of the resulting `Bool`, not whether it's 0 or 1
  - some changes and extensions to code-manipulation methods (more shortly)
  - `exec_map` and `code_map` instructions, which execute code over entire stacks full of arguments
  - more stack manipulation instructions, including `*_flip` (which reverses a stack), `*_double` (which clones the entire stack onto itself) and `*_archive` which pushes an item onto the _bottom_ of the `exec` stack
  - some interpreter state variations, like `push_nopop` which leaves arguments on the origin stacks
  - (possibly) buffered output: a stack that receives all pushed items when the interpreter is in `push_buffer` mode, then dumps them all onto the `exec` stack when it leaves `push_buffer` mode. After a running interpreter executes `push_buffer`, every `push` event is redirected to an empty `buffer` stack. When a subsequent `push_buffer` instruction toggles the state again (or any of several other commands), the buffer contents are moved to the top of the `exec` stack as a single code block.

## Goals

- ✅ build a parser that converts Push [dialect] scripts into code points 
- build an interpreter that executes [most of] the instructions defined in the [Push 3.0 Specification](http://faculty.hampshire.edu/lspector/push3-description.html) and [Clojush](https://github.com/lspector/Clojush)
- ✅ add a few simple extensions to the basic type structure from our [GPTP conferences](http://vserver1.cscs.lsa.umich.edu/gptp-workshops/) through the years
  - tag spaces
  - ✅ Range types
  - implied block structure
- build a simple desktop [?] app that loads training and test data
- let the app solve problems locally using modern [Pareto-GP](http://www.evolved-analytics.com/?q=technology/publications) approaches
- maybe some cloud things; you know, for kids
