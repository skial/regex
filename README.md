# regex

> Helper methods to cross-compile Unicode regular expressions.

###### _Note_
> Currently, all the code in this repo has been pulled out of the [rxpattern](https://github.com/skial/rxpattern) rewrite.

> The file/library regenerate.js is created by [@mathiasbynens](https://github.com/mathiasbynens). Core functionality was ported to Haxe, see [`utf16/RangeUtil.hx`](https://github.com/skial/regex/blob/master/src/be/regex/utf16/RangeUtil.hx).

### Install

`lix install gh:skial/regex`

#### Dependencies

- [seri](https://github.com/skial/seri) - _Unicode blocks, scripts, classes & range information_.
- [unifill](https://github.com/skial/unifill) - _Haxe library for Unicode UTF{8/16/32} support_

#### Tested Platforms
- Tested ✅
- Untested ➖

| Php | Python | Java | C# | Js/Node | Interp | Neko | HashLink | Lua | CPP | Flash
| - | -| - | - | - | -| - | - | - | - | - |
| ✅ | ✅ | ✅  | ✅ | ✅ | ✅ | ✅  | ✅ | ➖ | ➖ | ➖ |

### Usage

```Haxe
package ;

import be.Regex;

class Main {

    public static function main() {
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
            The `u` Unicode flag is required. If you skip it, you can
            get an exception on some targets.
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

        trace( regexp.match("a⁴ + b³+c²") ); // true

        // a⁴ +
        trace( regexp.matched(0) );
    }

}
```