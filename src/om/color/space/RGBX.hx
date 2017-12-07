package om.color.space;

using om.Math;

@:access(om.color.space.HSV)
@:access(om.color.space.RGBXA)
abstract RGBX(Array<Float>) {
    
    public static inline function create( r : Float, g : Float, b : Float ) : RGBX
        return new RGBX( [r,g,b] );

    @:from public static inline function fromFloats( a : Array<Float> ) : RGBX
        return RGBX.create( a[0], a[1], a[2] );

    @:from public static inline function fromInts( a : Array<Int> ) : RGBX
        return RGBX.create( a[0] / 255.0, a[1] / 255.0, a[2] / 255.0 );

    @:from public static inline function fromInt( i : Int ) : RGBX {
        var rgb : RGB = i;
        return create( rgb.r/255, rgb.g/255, rgb.b/255 );
    }

    public var r(get,never) : Float;
    inline function get_r() : Float return this[0];

    public var g(get,never) : Float;
    inline function get_g() : Float return this[1];

    public var b(get,never) : Float;
    inline function get_b() : Float return this[2];

    inline function new( a : Array<Float>) this = a;

    public inline function interpolate( other : RGBX, t : Float ) : RGBX
        return new RGBX([
            t.interpolate( r, other.r ),
            t.interpolate( g, other.g ),
            t.interpolate( b, other.b )
        ]);

    @:to public inline function toGrey() : Grey
        return new Grey( r * 0.2126 + g * 0.7152 + b * 0.0722 );

    @:to public function toHSL() : HSL {
        var min = r.min( g ).min( b );
        var max = r.max( g ).max( b );
        var delta = max - min;
        var h, s, l = (max + min) / 2;
        #if php
        if( delta.nearZero() )
        #else
        if( delta == 0.0 )
        #end
            s = h = 0.0;
        else {
            s = l < 0.5 ? delta / (max + min) : delta / (2 - max - min);
            if( r == max )
                h = (g - b) / delta + (g < b ? 6 : 0);
            else if( g == max )
                h = (b - r) / delta + 2;
            else
                h = (r - g) / delta + 4;
            h *= 60;
        }
        return new HSL( [h,s,l] );
    }

    @:to public function toHSV() : HSV {
        var min = r.min( g ).min( b );
        var max = r.max( g ).max( b );
        var delta = max - min;
        var h : Float;
        var s : Float;
        var v : Float = max;
        if( delta != 0 )
            s = delta / max;
        else {
            s = 0;
            h = -1;
            return new HSV( [h,s,v] );
        }
        if( r == max )
            h = (g - b) / delta;
        else if (g == max)
            h = 2 + (b - r) / delta;
        else
            h = 4 + (r - g) / delta;
        h *= 60;
        if( h < 0 ) h += 360;
        return new HSV( [h,s,v] );
    }

    @:to public inline function toRGB() : RGB
        return RGB.createf( r, g, b );

    @:to public inline function toRGBXA(): RGBXA
        return withAlpha( 1.0 );

    public function withAlpha( a : Float )
        return new RGBXA( this.concat( [a] ) );

}
