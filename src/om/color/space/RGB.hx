package om.color.space;

//import om.util.ColorParser;
import om.util.ColorUtil;

using om.util.FloatUtil;
using om.util.HexUtil;

/**
	Additive color model in which red, green, and blue light are added together in various ways to reproduce a broad array of colors.
*/
abstract RGB(Int) from Int to Int {

	//public var numchannels(get,never) = 3;

	public var r(get,never) : Int;
	public var g(get,never) : Int;
	public var b(get,never) : Int;

	@:noCompletion public inline function new( i : Int ) this = i;

	inline function get_r() return this >> 16 & 0xFF;
	inline function get_g() return this >> 8 & 0xFF;
	inline function get_b() return this & 0xFF;

	@:op(A==B) public function equals( other : RGB ) : Bool
		return r == other.r && g == other.g && b == other.b;

	@:to public inline function toArray() : Array<Int>
		return [r,g,b];

	@:to public inline function toString() : String {
		/*
		#if js
		return '#'+untyped this.toString(16);
		#else
		#end
		*/
		return toHex();
	}

	public function toHex( prefix = "#" ) : String {
		return '$prefix${r.hex(2)}${g.hex(2)}${b.hex(2)}';
	}

	/*
	public inline function toCSS3() : String
		return 'rgb($r,$g,$b)';
	*/

	public function toCSS3( formatWhitespace = false ) : String {
		return if( formatWhitespace ) {
			var s = 'rgb(';
			var f = function(v:Int) : String {
				var s = Std.string( v );
				for( i in 0...(3-s.length) ) s = ' '+s;
				return s;
			}
			return s + [f(r),f(g),f(b)].join(',') + ')';
		} else 'rgb($r,$g,$b)';
	}

	@:arrayAccess
	public inline function getPart( i : Int ) : Int {
		return switch i {
			case 0: r;
			case 1: g;
			case 2: b;
			default: throw 'Out of bounds';
		}
	}

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

	@:from static inline function fromInt( i : Int )
		return new RGB(i);

	@:from static inline function fromString( s : String ) : Null<RGB> {
		/*
		var info = ColorParser.parseHex( color );
		if( info == null )
			info = ColorParser.parseColor(color);
		if( info == null )
			return null;
		trace(info);
		return null;
		*/
		return new RGB( ColorUtil.hexToInt( s ) );
	}

	@:from static inline function fromArray( a : Array<Int> ) : RGB
		return new RGB( ColorUtil.rgbToInt( a[0], a[1], a[2] ) );

	public static inline function create( r : Int, g : Int, b : Int ) : RGB
		return new RGB(((r & 0xFF) << 16) | ((g & 0xFF) << 8) | ((b & 0xFF) << 0));

}
