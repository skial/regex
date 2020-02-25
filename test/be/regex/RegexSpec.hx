package be.regex;

import be.Regex;
/**
    Only the JavaScript implementation is
    overriden, making sure Unicode support is allowed.
**/
import be.regex.EReg;

@:asserts
class RegexSpec {

    public function new() {}

    @:include public function testReadme() {
        /**
            Print either a regular expression category `\p{Ll}` or
            the range of codepoints.
        **/
        var Ll = Regex.category('Ll');
        /**
            Why `²-¹⁰-⁹`?
            `²-¹` are `\u00B2-\u00B9` and `⁰-⁹` are `\u2080-\u2089`, so if you 
            typed `⁰-⁹` you would include far more codepoints than you intended.
            Regex wont stop you from making these type of errors.
            ---
            See https://codepoints.net/search?gc=No for more info.
        **/
        var term = '(' + Ll + Regex.pattern('[²-¹⁰-⁹]') + ')';
        /**
            The `u` Unicode flag is required. If you don't, you will
            get an exception thrown on certain targets.
        **/
        var repeat = Regex.pattern('(?:[ ]*\\+[ ]*)');

        var regexp = new EReg(term + repeat, 'u');

        trace( term, repeat );

        asserts.assert( regexp.match("a + b³+c²") == true );

        return asserts.done();
    }

}