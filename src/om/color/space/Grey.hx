package om.color.space;

using om.Math;

@:access(om.color.space.RGBX)
abstract Grey(Float) from Float to Float {

	public static inline function black() return new Grey(0);
	public static inline function white() return new Grey(1);

	public static inline function create( v : Float ) : Grey
		return new Grey( v );

	public inline function new( f : Float ) this = f;

	public inline function contrast() : Grey
    	return this > 0.5 ? black(): white();

	public inline function darker( t : Float ) : Grey
		return new Grey( t.clamp( 0, 1 ).interpolate( this, 0 ) );

	@:op(A==B) public inline function equals( other : Grey ) : Bool
		return nearEquals( other );

	public inline function nearEquals( other : Grey, ?tolerance = Math.EPSILON ) : Bool
		return this.nearEquals( other, tolerance );

	public inline function interpolate( other : Grey, t : Float ) : Grey
		return new Grey( t.interpolate( this, other ) );

	public inline function lighter( t : Float ) : Grey
		return new Grey( t.clamp(0,1).interpolate( this, 1 ) );

	public inline function min( other : Grey ) : Grey
		return new Grey( this.min( other ) );

	public inline function max( other : Grey ) : Grey
		return new Grey( this.max( other ) );

	@:to public inline function toRGB() : RGB
		return toRGBX().toRGB();

	@:to public inline function toRGBA() : RGBA
		return toRGBXA().toRGBA();

	@:to public inline function toRGBX() : RGBX
		return new RGBX([this,this,this]);

	@:to public inline function toRGBXA() : RGBXA
		return toRGBX().toRGBXA();

	@:to public inline function toString() : String
       return 'grey(${(${this}*100)}%)';

}
