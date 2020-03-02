package be.regex;

typedef ParserUtil =
#if (interp || eval || macro)
    be.regex.std.ParserUtil
#else
    be.regex.expr.ParserUtil
#end;