package om.color.space;

using om.Math;

@:access(om.color.space.HSV)
@:access(om.color.space.RGBXA)
@:access(om.color.space.XYZ)
abstract RGBX(Array<Float>) {

    public static inline function create( r : Float, g : Float, b : Float ) : RGBX
        return new RGBX( [r,g,b] );

    @:from public static inline function fromFloats( a : Array<Float> ) : RGBX
        return RGBX.create( a[0], a[1], a[2] );

    @:from public static inline function fromInts( a : Array<Int> ) : RGBX
        return RGBX.create( a[0] / 255.0, a[1] / 255.0, a[2] / 255.0 );

    @:from public static function fromInt( i : Int ) : RGBX {
        var c : RGB = i;
        return create( c.r/255, c.g/255, c.b/255 );
    }

    @:from public static inline function fromString( s : String ) : Null<RGBX> {
        var info = ColorParser.parseHex( s );
        if( info == null ) info = ColorParser.parseColor( s );
        if( info == null )
            return  null;
        return try switch info.name {
            case 'rgb': RGBX.fromFloats( ColorParser.getFloatChannels( info.channels, 3, [HexMode,HexMode,HexMode] ) );
            case _: null;
        } catch(e:Dynamic) null;
    }

    public var r(get,never) : Float;
    inline function get_r() : Float return this[0];

    public var g(get,never) : Float;
    inline function get_g() : Float return this[1];

    public var b(get,never) : Float;
    inline function get_b() : Float return this[2];

    inline function new( a : Array<Float> ) this = a;

    public function inSpace() : Bool
        return r >= 0 && r <= 1 && g >= 0 && g <= 1 && b >= 0 && b <= 1;

    public function darker( t : Float ) : RGBX
        return new RGBX([
            t.interpolate( r, 0 ),
            t.interpolate( g, 0 ),
            t.interpolate( b, 0 ),
        ]);

    public function lighter( t : Float ) : RGBX
        return new RGBX([
            t.interpolate( r, 1 ),
            t.interpolate( g, 1 ),
            t.interpolate( b, 1 ),
        ]);

    public inline function interpolate( other : RGBX, t : Float ) : RGBX
        return new RGBX([
            t.interpolate( r, other.r ),
            t.interpolate( g, other.g ),
            t.interpolate( b, other.b )
        ]);

    public inline function min( other : RGBX ) : RGBX
        return create( r.min( other.r ), g.min( other.g ), b.min( other.b ) );

    public inline function max( other : RGBX ) : RGBX
        return create( r.max( other.r ), g.max( other.g ), b.max( other.b ) );

    //public inline function normalize() : RGBX
    //    return new RGBX([r.normalize(),g.normalize(),b.normalize()]);

    @:to public inline function toGrey() : Grey
        return new Grey( r * 0.2126 + g * 0.7152 + b * 0.0722 );

    public inline function toPerceivedGrey() : Grey
        return new Grey( r * .299 + g * .587 + b * .114 );

    public inline function toPerceivedAccurateGrey() : Grey
        return new Grey( Math.pow( r, 2 ) * .241 + Math.pow( g, 2 ) * .691 + Math.pow( b, 2 ) * .068 );

    //public inline function toHex( prefix = "#" ) : String
    //    return '$prefix${r.hex(2)}${g.hex(2)}${b.hex(2)}';

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

    @:to public function toHSLUV() : HSLUV
        return new HSLUV( [0,0,0] );

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
        if( r == max ) h = (g - b) / delta;
        else if( g == max ) h = 2 + (b - r) / delta;
        else h = 4 + (r - g) / delta;
        h *= 60;
        if( h < 0 ) h += 360;
        return new HSV( [h,s,v] );
    }

    @:to public inline function toRGB() : RGB
        return RGB.createf( r, g, b );

    @:to public inline function toRGBXA(): RGBXA
        return withAlpha( 1.0 );

    @:to public function toXYZ() : XYZ {
        var vr = r, vg = g, vb = b;
        vr = vr > 0.04045 ? Math.pow( ( ( vr + 0.055 ) / 1.055 ), 2.4 ) : vr / 12.92;
        vg = vg > 0.04045 ? Math.pow( ( ( vg + 0.055 ) / 1.055 ), 2.4 ) : vg / 12.92;
        vb = vb > 0.04045 ? Math.pow( ( ( vb + 0.055 ) / 1.055 ), 2.4 ) : vb / 12.92;
        return new XYZ([
            vr * 0.4124564 + vg * 0.3575761 + vb * 0.1804375,
            vr * 0.2126729 + vg * 0.7151522 + vb * 0.0721750,
            vr * 0.0193339 + vg * 0.1191920 + vb * 0.9503041
        ]);
    }

    @:to public inline function toString() : String
        return 'rgb(${(r*100)}%,${(g*100)}%,${(b*100)}%)';

    public function withAlpha( a : Float )
        return new RGBXA( this.concat( [a] ) );

}
