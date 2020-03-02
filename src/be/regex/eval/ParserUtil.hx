package be.regex.eval;

import be.regex.Define;
import haxe.macro.Expr;
import haxe.macro.Context;

class ParserUtil {

    private static var pythonStyle:Bool = Python; // \uHHHH or \UHHHHHHHH
    private static var perlStyle:Bool = Neko || Cpp || Php || Lua || Java; // \x{HHHH}
    private static var jsStyle:Bool = JavaScript || CSharp || Flash; // \uHHHH
    private static var onlyBMP:Bool = JavaScript || CSharp;

    public static function pattern(s:String):String {
        return be.regex.std.ParserUtil.pattern(s, perlStyle, jsStyle, onlyBMP);
    }

    public static function category(c:String):String {
        return be.regex.std.ParserUtil.category(c, pythonStyle, perlStyle, jsStyle, onlyBMP);
    }

}