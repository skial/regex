package be.regex;

#if (eval || macro)
import be.regex.Define;
#end

class MinMax {

    public static var MIN:Int = 
    #if (interp || eval || macro) 
        if (Interp || Neko || HashLink || Php) {
            1;
        } else {
            unifill.Unicode.minCodePoint;
        }
    #elseif (neko || hl || php)
        1
    #else
        unifill.Unicode.minCodePoint
    #end
    ;

    public static var MAX:Int = unifill.Unicode.maxCodePoint;

}