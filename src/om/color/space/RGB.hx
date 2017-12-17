package om.color.space;

import om.error.OutOfBounds;

using om.StringTools;

/**
	Additive color model.
**/
abstract RGB(Int) from Int to Int {

	public static inline function create( r : Int, g : Int, b : Int ) : RGB
		return new RGB( ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | ((b & 0xFF) << 0) );

	public static inline function createf( r : Float, g : Float, b : Float ) : RGB
		return create( Math.round( r * 255 ), Math.round( g * 255 ), Math.round( b * 255 ) );

	//@:from static inline function fromArray( a : Array<Int> ) : RGB
	//	return (a[0]<<16) | (a[1]<<8) | a[2];

	@:from public static inline function fromInts( a : Array<Int> ) : RGB
		return create( a[0], a[1], a[2] );

	@:from public static inline function fromString( s : String ) : Null<RGB> {
		var info = ColorParser.parseHex( s );
		if( info == null ) info = ColorParser.parseColor( s );
		if( info == null )
			return  null;
		return try switch info.name {
			case 'rgb': RGB.fromInts( ColorParser.getInt8Channels( info.channels, 3 ) );
			case _: null;
		} catch(e:Dynamic) null;
	}

	public var r(get,never) : Int;
	inline function get_r() return this >> 16 & 0xFF;

	public var g(get,never) : Int;
	inline function get_g() return this >> 8 & 0xFF;

	public var b(get,never) : Int;
	inline function get_b() return this & 0xFF;

	@:noCompletion public inline function new( i : Int ) this = i;

	//public inline function set( r : Int, g : Int , b : Int )
		//this = RGB.create( r, g, b ); //((r & 0xFF) << 16) | ((g & 0xFF) << 8) | ((b & 0xFF) << 0);

	/*
	@:op(A==B) public function equals( other : RGB ) : Bool
		return r == other.r && g == other.g && b == other.b;
	*/

	@:arrayAccess public inline function get( i : Int ) : Int {
		return switch i {
			case 0: r;
			case 1: g;
			case 2: b;
			default: throw new OutOfBounds( i );
		}
	}

	@:arrayAccess public inline function set( i : Int, v : Int ) : RGB {
		return RGB.fromInts( switch i {
			case 0: [v,g,b];
			case 1: [r,v,b];
			case 2: [r,g,v];
			default: throw new OutOfBounds( i );
		} );
	}

	@:arrayAccess public function getChannel( name : String ) : Int {
		return switch name.toLowerCase() {
			case 'red','r': r;
			case 'green','g': g;
			case 'blue','b': b;
			default: throw new OutOfBounds( name );
		}
	}

	@:arrayAccess public function setChannel( name : String, v : Int ) : RGB {
		return set( switch name.toLowerCase() {
			case 'red','r': 0;
			case 'green','g': 1;
			case 'blue','b': 2;
			default: throw new OutOfBounds( name );
		}, v );
	}

	public inline function darker( t : Float ) : RGB
    	return toRGBX().darker(t).toRGB();

	public inline function lighter( t : Float ) : RGB
	   	return toRGBX().lighter(t).toRGB();

	public inline function interpolate( other : RGB, t : Float ) : RGB
    	return toRGBX().interpolate( other.toRGBX(), t ).toRGB();

	@:to public inline function toArray() : Array<Int>
		return [r,g,b];

	public inline function toCSS3() : String
		return 'rgb($r,$g,$b)';

	@:to public inline function toGrey() : Grey
		return toRGBX().toGrey();

	public inline function toHex( prefix = '#' ) : String
		return '$prefix${r.hex(2)}${g.hex(2)}${b.hex(2)}';

	@:to public inline function toHSL() : HSL
		return toRGBX().toHSL();

	@:to public inline function toHSLUV() : HSLUV
		return toRGBX().toHSLUV();

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

	public inline function withRed( v : Int ) : RGB
		return RGB.fromInts( [ v, g, b ] );

	public inline function withGreen( v : Int ) : RGB
		return RGB.fromInts( [ r, v, b ] );

	public inline function withBlue( v : Int ) : RGB
		return RGB.fromInts( [ r, g, v ] );

	public inline function withAlpha( v : Int ) : RGBA
		return RGBA.fromInts( [ r, g, b, v ] );

}
