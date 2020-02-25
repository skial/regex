package be;

import uhx.sys.seri.Category;

#if (eval || macro)
import haxe.macro.Expr;
import haxe.macro.Context;
import be.regex.RegexErrors;
import uhx.sys.seri.Ranges;
import be.regex.Define;
import be.regex.CodeUtil;
import be.regex.RangeUtil;
#end

/* This class is not used at runtime */
#if !(eval || macro) extern #end
class Regex {
    /*
     * Different regexp engines have different syntax for hexadecimal Unicode
     * escape sequence.  This macro translates Unicode escape sequences of
     * the form \uHHHH or \u{HHHHH} into the form recognized by the engine.
     *
     * Input: \uHHHH or \u{HHHHH}
     * --- output ---
     * Python: \uHHHH or \UHHHHHHHH
     * Perl-like (Neko VM, C++, PHP, Lua and Java): \x{HHHHH}
     * JavaScript, C#, Flash: \uHHHH
     */
    macro public static function pattern(s:String):ExprOf<String> {
        var i = 0;
        var pos = Context.currentPos();
        var translatedBuf = new StringBuf();

        while (i < s.length) {
            var j = s.indexOf("\\u", i);
            if (j == -1) {
                break;
            }
            translatedBuf.add(s.substring(i, j));
            var m;
            if (s.charAt(j + 2) == '{') {
                var k = s.indexOf('}', j + 3);
                if (k == -1) {
                    Context.error(Unicode_InvalidEscape, pos);
                    return null;
                }
                m = s.substring(j + 3, k);
                i = k + 1;
            } else {
                m = s.substring(j + 2, j + 6);
                i = j + 6;
            }
            var value = 0;
            for (l in 0...m.length) {
                value = value * 16 + hexToInt(m.charAt(l));
            }
            if (perlStyle) {
                translatedBuf.add(CodeUtil.printCode(value));

            } else {
                if (value >= 0x10000) {
                    if (jsStyle || !onlyBMP) {
                        var hi = ((value - 0x10000) >> 10) | 0xD800;
                        var lo = ((value - 0x10000) & 0x3FF) | 0xDC00;
                        translatedBuf.add(CodeUtil.printCode(hi) + CodeUtil.printCode(lo));
                    } else {
                        Context.error(Unicode_GreaterThanBMP, pos);
                        return null;
                    }
                } else {
                    translatedBuf.add(CodeUtil.printCode(value));

                }
            }
        }

        translatedBuf.add(s.substr(i));
        var r = translatedBuf.toString();
        return macro @:pos(pos) $v{r};
    }

    public macro static function category(category:String):ExprOf<String> {
        var range:Ranges = (cast category:Category).asRange();
        if (range.min == 0 && range.max == 0) {
            // Incorrect Category.
            Context.error('$category is not a valid value of uhx.sys.seri.Category.', Context.currentPos());
            return null;
        } else {
            // Single letter categories are not supported for JavaScript/Browsers.
            var pattern = if (((JavaScript && category.length == 1) || !(NodeJS || (ES_ && ES_ > 5))) && (jsStyle || pythonStyle || Cpp)) {
                var value = RangeUtil.printRanges(range, false);
                macro @:Disjunction $v{value};

            } else {
                macro @:Atom $v{"\\p{" + category + "}"};
            }
            
            return pattern;

        }
    }

    #if (eval || macro)
    private static var pythonStyle:Bool = Python; // \uHHHH or \UHHHHHHHH
    private static var perlStyle:Bool = Neko || Cpp || Php || Lua || Java; // \x{HHHH}
    private static var jsStyle:Bool = JavaScript || CSharp || Flash; // \uHHHH
    private static var onlyBMP:Bool = JavaScript || CSharp;

    private static function hexToInt(c:String):Int {
        var i = "0123456789abcdef".indexOf(c.toLowerCase());
        if (i == -1) {
            throw Unicode_InvalidEscape;
        } else {
            return i;
        }
    }
    #end
}
