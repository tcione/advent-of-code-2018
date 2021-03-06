# My solutions for the Advent of Code 2018

Hi, welcome to the solutions I have writter for 2018's advent days. Since I am doing all this light heartedly (and so I may come across problems I do not usually see in my routine).

Proceed with caution, since most code written will:

1. Be of questionable elegance;
2. Usually perform poorly at scale (O(n**2), etc);

As you can see, my sole focus right now is to get the right answers ;p. (and also share this so people can have access to it :))

That being said, there is some documentation that might be useful.

## Documentation that might be useful if you decide to use this repo or read it

### CLI helper

From this project's root run:

- `./bin/run DAY_NUMBER` => Runs code to solve the day's puzzle
- `./bin/test DAY_NUMBER` => Runs tests related to the day's puzzle
- `./bin/createday DAY_NUMBER` => Creates a new day from ./template

### About the puzzles

- There is a template folder inside this project's root path. You can copy it to create a new day. Example: `cp -r template/ days/08`;
- Every template contains:
    - `code.rb` => File where you insert the code to solve the puzzle
    - `test.rb` => File in which you can test your code. The exercises usually have an example, which can be used;
    - `test-input.txt` => Data input for tests;
    - `input.txt` => Input for the puzzle;
    - `your_module_or_class.rb` => Ideally you should encapsulate your code in a module or class, so you can easily switch between solving the puzzle and testing with example data;
- The recomended Ruby version is 2.5.3. I did not test it in other versions. It usually should be OK on version 2.x.x, but it might not;
- Still about Ruby version, if you use RVM there are the `.ruby-version` and `.ruby-gemset` files to assist you :D;
- I am avoiding dependencies, so I decided to create a simple test method;
- This repo tooling will probably evolve as days go by, so older days tend to be less structured;

## Things I plan to do eventually:

- [ ] Brief overview for each day;
- [ ] Review this text, the English here is passable, at best;

