package om.color.space;

@:access(om.color.space.RGBXA)
@:access(om.color.space.HSL)
abstract HSLA(Array<Float>) {

    public static inline function create( h : Float, s : Float, l : Float, a : Float ) : HSLA
        return new HSLA( [h,s,l,a] );

    @:from public static inline function fromFloats( a : Array<Float> ) : HSLA
        	return create( a[0], a[1], a[2], a[3] );

    public var h(get,never) : Float;
	inline function get_h() : Float return this[0];

    public var s(get,never) : Float;
	inline function get_s() : Float return this[1];

    public var l(get,never) : Float;
	inline function get_l() : Float return this[2];

    public var a(get,never) : Float;
	inline function get_a() : Float return this[3];

    inline function new( channels : Array<Float> ) this = channels;

    public inline function toCSS3() : String
        return toString();

    @:to public inline function toHSL() : HSL
        return new HSL( this.slice( 0, 3 ) );

    @:to public inline function toHSVA() : HSVA
        return toRGBXA().toHSVA();

    @:to public inline function toRGB(): RGB
    	return toRGBXA().toRGBA();

	@:to public inline function toRGBA(): RGBA
    	return toRGBXA().toRGB();

    @:to public inline function toRGBXA() : RGBXA
        return new RGBXA([
            HSL._c( h + 120, s, l ),
            HSL._c( h, s, l ),
            HSL._c( h - 120, s, l ),
            a
        ]);

    public inline function toString() : String
        return 'hsla(${h},${(s*100)}%,${(l*100)}%,${a})';

}
