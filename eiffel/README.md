# Eiffel

Author: John Perry (john.perry@usm.edu)

## Note

This is a preliminary, naive version.
Eiffel doesn't allow one to re-assign the values of arguments to features (procedures)
so I am consulting with Eiffel folks on how to improve its performance.

## Compile

You can compile this after installing EiffelStudio.
Either create a new project from the GUI and load the files in to create a project,
or from the command line, in this directory, execute

```
ec application.e -library time -finalize
```

## Execute

You should find an executable named `application` in the same directory.
