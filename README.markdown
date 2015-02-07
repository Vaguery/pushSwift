pushSwift
=========
A Mac desktop genetic programming system using a simple interpreted language based closely on the [PushGP system for genetic programming](http://faculty.hampshire.edu/lspector/push.html) (work by Lee Spector, Maarten Keijzer, Jon Klein, Chris Perry and Tom Helmuth, among others).

With several amendments.

## Why

To learn some TDD habits in XCode, and explore Apple's ~~new~~ Swift language.

## Status

- 6 June 2014: Just barely started.
- 14 June 2014: Push interpreter built, most trivial instructions running and tested. No I/O or UI at all, so it only runs in XCode under test. About to start building an `Answer` class, which will be the genetic programming "individuals".
- 20 June 2014: Most of Push 3 instructions and `Range` type are done; considering how to handle arithmetic overflow
- 7 February 2015: Finally rolled up my sleeves and repaired a whole slew of compile errors that arose when Swift 1.x was released: these involved access control (which didn't exist when I started), various new bridges to Objective C (ditto), loads of syntax quirks and minor changes (like the `..` operator is now the `...` operator), and so on. Also deleted many little dumb stubs that arose in the process of working with XCode 6 beta before Yosemite was available to me.
  
  _Tabula rasa_ for setting up an actual search process, and building this out as a library proper.

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

## Goals

- ✅ build a parser that converts Push [dialect] scripts into code points 
- build an interpreter that executes [most of] the instructions defined in the [Push 3.0 Specification](http://faculty.hampshire.edu/lspector/push3-description.html) and [Clojush](https://github.com/lspector/Clojush)
- ✅ add a few simple extensions to the basic type structure from our [GPTP conferences](http://vserver1.cscs.lsa.umich.edu/gptp-workshops/) through the years
  - tag spaces?
  - ✅ Range types
  - Set and/or collection types
  - implied block structure
- build a simple desktop [?] app that loads training and test data, and runs interactively to produce data logs and results in realtime
- let the app solve problems locally using modern [Pareto-GP](http://www.evolved-analytics.com/?q=technology/publications) approaches, lexicase selection, and so on
- maybe some cloud things; you know, for kids
