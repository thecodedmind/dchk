import os
import parseopt
import strutils, sequtils, strformat
import macros
var
    p = initOptParser()
    recursive = false
    recursionDepth = 1
    caseSensative = true
    verbose = false
    search = ""
    cwd = getCurrentDir()
    dirs = newSeq[string]()
    files = newSeq[string]()
    help = false
    
proc btree(dir: string): seq[string] =
    if verbose:
        echo "Entering "&dir
     
    for kind, path in walkDir(dir):
        if kind == pcDir:
            #dirs.add(path)
            result.add(path)
            
        elif kind == pcFile:
            files.add(path)
            
while true:
  p.next()
  case p.kind
      of cmdEnd: break
      of cmdShortOption, cmdLongOption:
          if p.val == "":
              if p.key == "r":
                  recursive = true
              if p.key == "v":
                  verbose = true
              if p.key == "c":
                  caseSensative = false
              if p.key == "h":
                  help = true
              
          else:
              if p.key == "r":
                  recursive = true
                  recursionDepth = p.val.parseInt
      of cmdArgument:
          search = p.key
      
if help:
    echo "==== DCHK ===="
    echo "By Kaiser - http://github.com/kaiz0r"
    echo ""
    echo "dchk [search] [-c] [-r]/[-r:2]"
    echo ""
    echo "-c : if found, search is not case-sensative"
    echo "-v : if found, print more messages"
    echo "-r : if found, recursive search through subdirectories"
    echo "   ^ takes optional arguement of recursion depth, in the format of -r:<depth value>"
else:
    if search == "":
        echo "A search term is needed."
        quit(QuitFailure)
    if verbose:
        echo "Recursive:         "& $recursive
        echo "Recursion Depth:   "& $recursionDepth
        echo "Case-Sensative:    "& $caseSensative
        echo "Searching for:     "& search

    dirs = btree(cwd)
    
    if recursive:
        var td = deepCopy(dirs)
        while recursionDepth > 0:
            recursionDepth -= 1
            
            for dir in deepCopy(td):
                td.add(btree(dir))
    
            dirs = dirs.deduplicate()
            
    files = files.deduplicate()        
    #echo dirs
    #echo files
    #found = newSeq[string]()
    for file in files:
        let f = readFile(file)
        var index = 0
        for line in f.split("\n"):
            if search in line:
                echo(fmt"{file} -> line {index}")
                if verbose and line.len < 200:
                    echo fmt"-> {line}"
            index += 1
                
