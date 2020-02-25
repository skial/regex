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

    public function testReadme() {
        /**
            Prints either a regular expression category `\p{Ll}` or
            the range of codepoints.
        **/
        var Ll = Regex.category('Ll');
        /**
            Why `²-¹⁰-⁹`?
            `²-¹` are `\u00B2-\u00B9` and `⁰-⁹` are `\u2080-\u2089`, so if you 
            used `⁰-⁹` you would include far more codepoints than you intended.
            Regex wont stop you from making these type of errors.
            ---
            See https://codepoints.net/search?gc=No for more info.
        **/
        var term = '(' + Ll + Regex.pattern('[²-¹⁰-⁹]?') + ')';
        /**
            The `u` Unicode flag is required. If you don't, you will
            get an exception thrown on certain targets.
        **/
        var repeat = Regex.pattern('(?:[ +]*)');

        var regexp = new EReg(term + repeat, 'u');

        /**
            For regexp engines that support categories:
            - (\p{Ll}[²-¹⁰-⁹]), (?:[ +]*)
            
            For those that don't:
            - For those that don't, _skipping afew so not to show 1900+ codepoints_:
            - [a-z\\xB5\\xDF-\\xF6\\xF8-\\xFF\\u0101\\u0103\\u0105...|\\uD83A[\\uDD22-\\uDD43]
            
        **/
        trace( term, repeat ); 

        asserts.assert( regexp.match("a⁴ + b³+c²") == true );

        // a⁴ +
        trace( regexp.matched(0) );

        return asserts.done();
    }

}