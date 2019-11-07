cat makefile
make run
main:start().

**spawn**
    used to create a new process and initialize it.

**spec** adds up information about the code. It indicates the arity of the function and combined with -type declarations, are helpful for documentation and bug detection tools.

Tools like Edoc use these type specifications for building documentation. Tools like Dialyzer use it for static analysis of the code.

So it is not used directly by the running code but many tools use it for better "understanding" the code.
