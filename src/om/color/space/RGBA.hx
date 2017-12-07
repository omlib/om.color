package om.color.space;

using om.Math;
using om.StringTools;

abstract RGBA(Int) from Int from UInt {

    public static inline function create( r : Int, g : Int, b : Int, a : Int ) : RGBA
        return new RGBA( ((r & 0xFF) << 24) | ((g & 0xFF) << 16) | ((b & 0xFF) << 8) | ((a & 0xFF) << 0) );

    public static inline function createf( r : Float, g : Float, b : Float, a : Float ) : RGBA
        return RGBA.create( Math.round( r * 255 ), Math.round( g * 255 ), Math.round( b * 255 ), Math.round( a * 255 ) );

    @:from public static inline function fromInts( a : Array<Int> ) : RGBA
        return create( a[0], a[1], a[2], a[3] );

    @:from public static inline function fromFloats( a : Array<Float> ) : RGBA
        return create( (a[0]*255).round(), (a[1]*255).round(), (a[2]*255).round(), (a[3]*255).round() );

    @:from static inline function fromString( s : String ) : Null<RGBA>
        return new RGBA( Std.parseInt( '0x' + s.substr(1) ) );

    public var r(get,never) : Int;
    inline function get_r() return this >> 24 & 0xFF;

    public var g(get,never) : Int;
    inline function get_g() return this >> 16 & 0xFF;

    public var b(get,never) : Int;
    inline function get_b() return this >> 8 & 0xFF;

    public var a(get,never) : Int;
    inline function get_a() return this & 0xFF;

    @:noCompletion public inline function new( i : Int ) this = i;

    @:arrayAccess public inline function get( i : Int ) : Int {
		return switch i {
			case 0: r;
			case 1: g;
			case 2: b;
			case 3: a;
			default: throw 'Out of bounds';
		}
	}

    @:to public inline function toArray() : Array<Int>
    	return [r,g,b,a];

    public inline function toCSS3() : String
    	return 'rgba($r,$g,$b,${a/255})';

    public inline function toHex( prefix = '#' ) : String
    	return '$prefix${r.hex(2)}${g.hex(2)}${b.hex(2)}${a.hex(2)}';

    //@:to public inline function toInt() : Int
    //    return this;

    @:to public inline function toRGB(): RGB
        return RGB.create( r, g, b );

    @:to public inline function toRGBX() : RGBX
        return RGBX.fromInts([r,g,b]);

    @:to public inline function toRGBXA() : RGBXA
        return RGBXA.fromInts([r,g,b,a]);

    @:to public inline function toString() : String
    	return toHex();

}
