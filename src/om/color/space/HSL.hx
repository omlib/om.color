package om.color.space;

using om.Math;

/**
	Most common cylindrical-coordinate representations of points in an RGB color model.
**/
@:access(om.color.space.HSLA)
@:access(om.color.space.RGBX)
abstract HSL(Array<Float>) {

	public static inline function create( h : Float, s : Float, l : Float ) : HSL
		return new HSL( [h,s,l] );

	@:from public static inline function fromFloats( a : Array<Float> ) : HSL
		return create( a[0], a[1], a[2] );

	//TODO @:from public static inline function fromString( s : String ) : HSL

	static function _c( d : Float, s : Float, l : Float ) : Float {
		var m2 = l <= 0.5 ? l * (1 + s) : l + s - l * s;
		var m1 = 2 * l - m2;
		d = d.wrapCircular( 360 );
		if( d < 60 )
			return m1 + (m2 - m1) * d / 60;
		else if( d < 180 )
			return m2;
		else if( d < 240 )
			return m1 + (m2 - m1) * (240 - d) / 60;
		else
			return m1;
	}

	public var h(get,never) : Float;
	inline function get_h() : Float return this[0];

    public var s(get,never) : Float;
	inline function get_s() : Float return this[1];

    public var l(get,never) : Float;
	inline function get_l() : Float return this[2];

	@:noCompletion public inline function new( a : Array<Float> ) this = a;

	public inline function analogous( spread = 30.0 ) : Array<HSL>
	    //return new Tuple2(
	    return [
	    	rotate( -spread ),
	    	rotate( spread )
	    ];

	public inline function complement() : HSL
    	return rotate( 180 );

	public inline function darker( f : Float ) : HSL
	    return new HSL( [ h, s, f.interpolate( l, 0 ) ] );

	public function interpolate( other : HSL, t : Float )
		return new HSL([
			t.interpolateAngle( h, other.h, 360 ),
			t.interpolate( s, other.s ),
			t.interpolate( l, other.l )
	]);

	public inline function lighter( f : Float ) : HSL
	    return new HSL( [ h, s, f.interpolate( l, 1 ) ] );

	public inline function rotate( angle : Float ) : HSL
		return withHue( h + angle );

	public inline function toCSS3() : String
		return toString();

	@:to public inline function toGrey(): Grey
		return toRGBX().toGrey();

	@:to public inline function toHSV(): HSV
		return toRGBX().toHSV();

	@:to public inline function toRGB(): RGB
		return toRGBXA().toRGBA();

	@:to public inline function toRGBA(): RGBA
		return toRGBX().toRGB();

	@:to public function toRGBX() : RGBX
		return new RGBX([
        	_c( h + 120, s, l ),
        	_c( h, s, l),
        	_c( h - 120, s, l )
       ]);

	@:to public inline function toRGBXA() : RGBXA
		return toRGBX().toRGBXA();

	@:to public inline function toString() : String
		return 'hsl(${h},${(s*100)}%,${(l*100)}%)';

	public inline function withAlpha( v : Float ) : HSLA
        return new HSLA( this.concat( [v] ) );

	public inline function withHue( v : Float ) : HSL
        return new HSL( [v,s,l] );

	public inline function withSaturation( v : Float ) : HSL
		return new HSL( [h,v,l] );

	public inline function withLightness( v : Float ) : HSL
		return new HSL( [h,s,v] );

}
