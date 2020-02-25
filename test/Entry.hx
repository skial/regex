package ;

import tink.unit.TestBatch;
import tink.testrunner.Runner;

class Entry {

    public static function main() {
        Runner.run(TestBatch.make([
            new be.regex.PrintCodeSpec(),
            new be.regex.PrintRangeSpec(),
            new be.regex.RegexSpec(),
            new be.regex.CategorySpec(),
        ])).handle( Runner.exit );
    }

}