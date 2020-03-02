package be.regex.expr;

import uhx.sys.seri.Category;

#if (interp || eval || macro)
import be.regex.Define;
import haxe.macro.Expr;
import haxe.macro.Context;
#end

import be.regex.RegexErrors;
import uhx.sys.seri.Ranges;
import be.regex.CodeUtil;
import be.regex.RangeUtil;

class ParserUtil {

    #if (interp || eval || macro)
    private static var pythonStyle:Bool = Python; // \uHHHH or \UHHHHHHHH
    private static var perlStyle:Bool = Neko || Cpp || Php || Lua || Java; // \x{HHHH}
    private static var jsStyle:Bool = JavaScript || CSharp || Flash; // \uHHHH
    private static var onlyBMP:Bool = JavaScript || CSharp;
    #end

    public macro static function pattern(s:String):ExprOf<String> {
        var pos = Context.currentPos();
        return macro @:pos(pos) $v{be.regex.std.ParserUtil.pattern(s, perlStyle, jsStyle, onlyBMP, pos)};
    }

    public macro static function category(category:String):ExprOf<String> {
        var pos = Context.currentPos();
        return if (((JavaScript && category.length == 1) || !(NodeJS || (ES_ && ES_ > 5))) && (jsStyle || pythonStyle || Cpp)) {
            macro @:Disjunction $v{be.regex.std.ParserUtil.category(category, pythonStyle, perlStyle, jsStyle, onlyBMP, pos)};

        } else {
            macro @:Atom $v{be.regex.std.ParserUtil.category(category, pythonStyle, perlStyle, jsStyle, onlyBMP, pos)};
        }
    }

}