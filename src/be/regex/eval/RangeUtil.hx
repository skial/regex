package be.regex.eval;

import be.regex.Define;
import uhx.sys.seri.Ranges;

class RangeUtil {

    public static function printRanges(ranges:Ranges, invert:Bool):String {
        return if (JavaScript || CSharp) {
            if ((JavaScript && NodeJS) || (ES_ && ES_ > 5)) {
                be.regex.js.RangeUtil.printRanges(ranges, invert);

            } else {
                be.regex.utf16.RangeUtil.printRanges(ranges, invert);

            }

        } else if (Python) {
            be.regex.python.RangeUtil.printRanges(ranges, invert);

        } else if (HashLink) {
            be.regex.hl.RangeUtil.printRanges(ranges, invert);

        } else {
            be.regex.std.RangeUtil.printRanges(ranges, invert);

        }
    }

}