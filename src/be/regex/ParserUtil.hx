package be.regex;

typedef ParserUtil =
#if (interp || eval || macro)
    be.regex.eval.ParserUtil
#else
    be.regex.expr.ParserUtil
#end;