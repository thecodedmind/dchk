# dchk
CLI app for file content searching.

Either compile from source with Nim compiler, `nim c dchk.nim`, or drop the pre-compiled linux amd64 binary in a PATH directory.

```sh
[kaiz0r@playground~]$ dchk -h
dchk [search] [-c] [-r]/[-r:2]

-c : if found, search is not case-sensative
-v : if found, print more messages
-r : if found, recursive search through subdirectories
   ^ takes optional arguement of recursion depth, in the format of -r:<depth value>
```
