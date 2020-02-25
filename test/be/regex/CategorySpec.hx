package be.regex;

import be.Regex;

@:asserts
class CategorySpec {

    public function new() {}

    public function testCategory() {
        var pattern:String = Regex.category('No'); // Number Other
        var failure:String = Regex.category('Sc'); // Currency Symbols
        var regexp:EReg = new EReg(pattern, 'u');
        var fail:EReg = new EReg(failure, 'u');
        var value:String = "⁰¹²³⁴⁵⁶⁷⁸⁹";

        trace( pattern, failure );

        asserts.assert( pattern != null );
        asserts.assert( pattern != '' );
        asserts.assert( regexp.match(value) == true );
        asserts.assert( regexp.matched(0) != null );
        asserts.assert( regexp.matched(0) == '⁰' );
        asserts.assert( fail.match(value) == false );

        return asserts.done();
    }

}