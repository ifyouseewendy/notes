Some time is spent figuring out what ought to be going on, some time is spent designing, but **most time is spent debugging**.
Fixing the bug is usually pretty quick, but finding it is a nightmare.

**Extreme programmers are dedicated testers**. They want to develop software as fast as possible, and they know that tests help you to go as fast as you possibly can.

**When you get a bug report, start by writing a unit test that exposes the bug.** For refactoring purposes, I count on the developer tests—the pro- grammer’s friend.

The style I follow is to look at all the things the class should do and test each one of them for any conditions that might cause the class to fail. This is not the same as “test every public method,” which some programmers advocate. **Testing should be risk driven**; remember, you are trying to find bugs now or in the future. So I don’t test accessors that just read and write. Because they are so simple, I’m not likely to find a bug there.This is important because **trying to write too many tests usually leads to not writing enough**.

You cannot prove a program has no bugs by testing. That’s true but does not affect the ability of testing to speed up programming.

There is a point of diminishing returns with testing, and there is the danger that by trying to write too many tests, you become discouraged and end up not writing any. **You should concentrate on where the risk is. Look at the code and see where it becomes complex. Look at the function and consider the likely areas of error.** Your tests will not find every bug, but as you refactor you will understand the program better and thus find more bugs.

**There’s always a risk that I’ll miss something, but it is better to spend a reasonable time to catch most bugs than to spend ages trying to catch them all.**

## Principle

+ **It’s important to write isolated tests that do not depend on each other.**

+ **The key is to test the areas that you are most worried about going wrong. That way you get the most benefit for your testing effort.**

+ **It is better to write and run incomplete tests than not to run complete tests.**

+ **Think of the boundary conditions under which things might go wrong and concentrate your tests there.**

+ **I’m actively thinking about how I can break it. I find that state of mind to be both productive and fun. It indulges the mean-spirited part of my psyche.**


