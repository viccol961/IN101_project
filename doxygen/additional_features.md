# Additional Features Documentation {#additional_features}

## Options parser

The `app-naive-conway` application features a standard options parser. \n
It is developped in naive_optionsparser.h and naive_optionsparser.c and used in app-naive-conway.c.

The implemented options are:

```batch
-i: DON\'T generate images for each steps
-p: print simulation steps to the console
-t: consider the universe as a torus
-?: print source textfile formatting help
```

and are stored in a \ref naive_options structure.

The options parser will analyse all command-line arguments until one without a preceding dash (`-`) is found. It will then scan all characters following the dash and apply them to their corresponding options, or crash the program if they don't match a known option. \n
This means that the option sets `-pt` and `-t -p` are equivalent.

The first positional argument (the first argument withtout a leading dash) will be considered as the `filename` argument.

### Possibility to consider the universe as a torus

The `-t` option in `app-naive-conway` makes the simulator consider the universe as a torus, meaning that the alive neighbor count for an edging cell will include alive cells on the opposite edge of the universe.

In the following examples, if the universe is considered as a torus, the cells at (0,0), marked `x`, have one neighbor:

```text
3 3     3 3     3 3     3 3
1       1       1       1
x..     x..     x.o     x..
...     ..o     ...     ...
..o     ...     ...     o..
```