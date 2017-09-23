package om.color.palette;

import hsluv.Hsluv;

class HSLUV {

    //TODO return Tuple<2>
    public static function generate( numLowColors = 8, numColors = 8 ) : Array<Array<String>> {

        var colors = [[],[]];

        inline function getRandomInt( min : Int, max : Int )
            return om.Random.int( max - min ) + min;

        // 6 hues to pick from
        var h = getRandomInt( 0, 360 );
        var H : Array<Int> = ([0,60,120,180,240,300]).map( offset -> return (h + offset) % 360 );
        //var H : Array<Int> = ([0,30,60,90,120,150,180,210,240,270,300]).map( offset -> return (h + offset) % 360 );

        // 8 shades of low-saturated color
       var backS = getRandomInt( 5, 40 );
       var darkL = getRandomInt( 0, 10 );
       var rangeL = 90 - darkL;
       for( i in 0...numLowColors ) {
           colors[0].push( Hsluv.hsluvToHex( [H[0], backS, darkL + rangeL * Math.pow(i / 7, 1.5)] ) );
       }

       // 8 Random shades
        var minS = getRandomInt( 30, 70 );
        var maxS = minS + 30;
        var minL = getRandomInt( 50, 70 );
        var maxL = minL + 20;
        for( j in 0...numColors ) {
            var _h = H[ getRandomInt( 0, 5 ) ];
            var _s = getRandomInt( minS, maxS );
            var _l = getRandomInt( minL, maxL );
            colors[1].push( Hsluv.hsluvToHex( [_h,_s,_l] ) );
        }

        return colors;
    }
}
