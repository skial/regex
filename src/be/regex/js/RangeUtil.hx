package be.regex.js;

import uhx.sys.seri.Ranges;
import be.regex.MinMax.*;

class RangeUtil {

    public static inline function printRanges(ranges:Ranges, invert:Bool):String {
        if (invert) ranges = Ranges.complement(ranges, MIN, MAX);
        return be.regex.std.RangeUtil.printRanges(ranges, false);
    }

}