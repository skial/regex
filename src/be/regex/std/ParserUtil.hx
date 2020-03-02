package be.regex.std;

import be.regex.CodeUtil;
import be.regex.RangeUtil;
import uhx.sys.seri.Ranges;
import be.regex.RegexErrors;
import uhx.sys.seri.Category;

typedef Pos = 
#if (macro || eval) 
    haxe.macro.Expr.Position 
#else 
    haxe.PosInfos 
#end
;

class ParserUtil {

    /*
    private static var pythonStyle:Bool = #if python true #else false #end; // \uHHHH or \UHHHHHHHH
    private static var perlStyle:Bool = #if (neko || cpp || php || lua || java) true #else false #end; // \x{HHHH}
    private static var jsStyle:Bool = #if (js || cs || flash) true #else false #end; // \uHHHH
    private static var onlyBMP:Bool = #if (js || cs) true #else false #end;
    */

    private static function error(message:String, ?pos:Pos) {
        #if (macro || eval)
        haxe.macro.Context.error(message, pos);
        #else
        throw message;
        #end
    }

    private static function hexToInt(c:String):Int {
        var i = "0123456789abcdef".indexOf(c.toLowerCase());
        if (i == -1) {
            throw Unicode_InvalidEscape;
        } else {
            return i;
        }
    }

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
    public static function pattern(
        s:String, 
        ?perlStyle:Bool = #if (neko || cpp || php || lua || java) true #else false #end, 
        ?jsStyle:Bool = #if (js || cs || flash) true #else false #end, 
        ?onlyBMP:Bool = #if (js || cs) true #else false #end, 
        ?pos:Pos
    ):String {
        var i = 0;
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
                    error(Unicode_InvalidEscape, pos);
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
                        error(Unicode_GreaterThanBMP, pos);
                        return null;
                    }
                } else {
                    translatedBuf.add(CodeUtil.printCode(value));

                }
            }
        }

        translatedBuf.add(s.substr(i));
        var r = translatedBuf.toString();
        return r;
    }

    public static function category(
        category:String, 
        ?pythonStyle:Bool = #if python true #else false #end, 
        ?perlStyle:Bool = #if (neko || cpp || php || lua || java) true #else false #end, 
        ?jsStyle:Bool = #if (js || cs || flash) true #else false #end, 
        ?onlyBMP:Bool = #if (js || cs) true #else false #end, 
        ?pos:Pos
    ):String {
        var range:Ranges = (cast category:Category).asRange();
        if (range.min == 0 && range.max == 0) {
            // Incorrect Category.
            error('$category is not a valid value of uhx.sys.seri.Category.', pos);
            return null;
        } else {
            // Single letter categories are not supported for JavaScript/Browsers.
            return if (
                (
                    (#if js true #else false #end && category.length == 1) || 
                    #if !(nodejs || (js_es && js_es > 5)) true #else false #end &&
                    (jsStyle || pythonStyle || #if cpp true #else false #end)
                )
            ) {
                RangeUtil.printRanges(range, false);

            } else {
                "\\p{" + category + "}";
            }

        }
    }

}