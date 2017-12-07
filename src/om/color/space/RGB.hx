package om.color.space;

//import om.util.ColorParser;

using om.ColorTools;
using om.StringTools;

/**
	Additive color model in which red, green, and blue light are added together in various ways to reproduce a broad array of colors.
*/
abstract RGB(Int) from Int from UInt {

	public static inline function create( r : Int, g : Int, b : Int ) : RGB
		return new RGB( ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | ((b & 0xFF) << 0) );

	public static inline function createf( r : Float, g : Float, b : Float ) : RGB
		return create( Math.round( r * 255 ), Math.round( g * 255 ), Math.round( b * 255 ) );

	@:from static inline function fromArray( a : Array<Int> ) : RGB
		return (a[0]<<16) | (a[1]<<8) | a[2];
		//return new RGB( ColorUtil.rgbToInt( a[0], a[1], a[2] ) );

	@:from static inline function fromString( s : String ) : Null<RGB>
		return new RGB( Std.parseInt( '0x' + s.substr(1) ) );

	public var r(get,never) : Int;
	inline function get_r() return this >> 16 & 0xFF;

	public var g(get,never) : Int;
	inline function get_g() return this >> 8 & 0xFF;

	public var b(get,never) : Int;
	inline function get_b() return this & 0xFF;

	@:noCompletion public inline function new( i : Int ) this = i;

	/*
	@:op(A==B) public function equals( other : RGB ) : Bool
		return r == other.r && g == other.g && b == other.b;
	*/

	@:arrayAccess public inline function get( i : Int ) : Int {
		return switch i {
			case 0: r;
			case 1: g;
			case 2: b;
			default: throw 'Out of bounds';
		}
	}

	/*
	@:arrayAccess public inline function set( i : Int, v : Int ) : Int {
		if( i >= 3 )
			throw 'Out of bounds';
		//&var a = [];
		//&for( j in 0...3 ) a[j] = (j == i) ? v : this[j];
		//&return fromArray( a );
	}
	*/

	public inline function interpolate( other : RGB, t : Float ) : RGB
    	return toRGBX().interpolate( other.toRGBX(), t ).toRGB();

	@:to public inline function toArray() : Array<Int>
		return [r,g,b];

	public inline function toCSS3() : String
		return 'rgb($r,$g,$b)';

	public inline function toHex( prefix = '#' ) : String
		return '$prefix${r.hex(2)}${g.hex(2)}${b.hex(2)}';

	@:to public inline function toHSL() : HSL
		return toRGBX().toHSL();

	@:to public inline function toHSV() : HSV
		return toRGBX().toHSV();

	@:to public inline function toRGBX() : RGBX
	    return RGBX.fromInts( [r,g,b] );

	@:to public inline function toRGBA() : RGBA
		return withAlpha( 255 );

	@:to public inline function toRGBXA() : RGBXA
		return toRGBA().toRGBXA();

	@:to public inline function toString() : String
		return toHex();

	public inline function withAlpha( v : Int ) : RGBA
		return RGBA.fromInts( [ r, g, b, v ] );

	/*
	public static function wheel( pos : Int ) : RGB {
		pos = 255 - pos;
		if( pos < 85 )
			return [255 - pos * 3, 0, pos * 3 ];
		if( pos < 170 ) {
			pos -= 85;
			return [0, pos * 3, 255 - pos * 3];
		}
		pos -= 170;
		return [pos * 3, 255 - pos * 3, 0];
	}
	*/

	/*
	public function interpolate( target : Int, ratio = 0.5 ) : RGB {
		var _target = new RGB( target );
		var _r = r;
		var _g = g;
		var _b = b;
		return ColorUtil.rgbToInt(
			Std.int( _r + (_target.r - _r) * ratio ),
			Std.int( _g + (_target.g - _g) * ratio ),
			Std.int( _b + (_target.b - _b) * ratio )
		);
	}

	@:to public function toHSL() : HSL {
		var red = r;
		var green = g;
		var blue = b;
    	var min = red.min( green ).min( blue );
        var max = red.max( green ).max( blue );
        var delta = max - min;
        var h, s;
        var l = (max + min) / 2;
		//#if php
    	//if( delta.nearZero() )
		//#else
    	if( delta == 0.0 )
		//#end
      		s = h = 0.0;
    	else {
			s = l < 0.5 ? delta / (max + min) : delta / (2 - max - min);
    		if( red == max)
        		h = (green - blue) / delta + (green < blue ? 6 : 0);
			else if (green == max)
				h = (blue - red) / delta + 2;
			else
        		h = (red - green) / delta + 4;
			h *= 60;
    	}
		return new HSL([h,s,l]);
	}

	//@:from static inline function fromInt( i : Int )
		//return new RGB(i);

	@:from static inline function fromString( s : String ) : Null<RGB> {
		/*
		var info = ColorParser.parseHex( color );
		if( info == null )
			info = ColorParser.parseColor(color);
		if( info == null )
			return null;
		trace(info);
		return null;
		* /
		return new RGB( ColorUtil.hexToInt( s ) );
	}

		*/
}
