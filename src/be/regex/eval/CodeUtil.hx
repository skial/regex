package be.regex.eval;

import be.regex.Define;

class CodeUtil {

    public static function printCode(v:Int):String {
        return if (JavaScript) {
            be.regex.js.CodeUtil.printCode(v);

        } else if (Python) {
            be.regex.python.CodeUtil.printCode(v);

        } else if (HashLink) {
            be.regex.hl.CodeUtil.printCode(v);

        } else if (Java) {
            be.regex.java.CodeUtil.printCode(v);

        } else {
            be.regex.std.CodeUtil.printCode(v);

        }
    }

}