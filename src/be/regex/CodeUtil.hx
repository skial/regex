package be.regex;

typedef CodeUtil = 
#if (interp || eval || macro)
    be.regex.eval.CodeUtil
#elseif js
    be.regex.js.CodeUtil
#elseif python
    be.regex.python.CodeUtil
#elseif hl
    be.regex.hl.CodeUtil
#elseif java
    be.regex.java.CodeUtil
#else
    be.regex.std.CodeUtil
#end
;