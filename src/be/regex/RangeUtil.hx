package be.regex;

typedef RangeUtil = 
#if (interp || eval || macro)
    be.regex.eval.RangeUtil
#elseif (js || cs) 
    #if ((js && nodejs) || (js && js_es > 5))
        be.regex.js.RangeUtil
    #else
        be.regex.utf16.RangeUtil
    #end
#elseif python
    be.regex.python.RangeUtil
#elseif hl
    be.regex.hl.RangeUtil
#else
    be.regex.std.RangeUtil
#end
;