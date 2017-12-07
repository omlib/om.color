package om.color.space;

@:access(om.color.space.RGBXA)
@:access(om.color.space.HSV)
abstract HSVA(Array<Float>) {

    public static inline function create( h : Float, s : Float, l : Float, a : Float ) : HSVA
        return new HSVA( [h,s,l,a] );

    @:from public static inline function fromFloats( a : Array<Float> ) : HSVA
        	return create( a[0], a[1], a[2], a[3] );

    public var h(get,never) : Float;
	inline function get_h() : Float return this[0];

    public var s(get,never) : Float;
	inline function get_s() : Float return this[1];

    public var v(get,never) : Float;
	inline function get_v() : Float return this[2];

    public var a(get,never) : Float;
	inline function get_a() : Float return this[3];

    inline function new( channels : Array<Float> ) this = channels;

    @:to public inline function toHSV() : HSV
        return new HSV( this.slice( 0, 3 ) );

    @:to public inline function toHSLA() : HSLA
        return toRGBXA().toHSLA();

    @:to public inline function toRGB(): RGB
    	return toRGBXA().toRGBA();

	@:to public inline function toRGBA(): RGBA
    	return toRGBXA().toRGB();

    @:to public function toRGBXA() : RGBXA {

        if( s == 0 )
            return new RGBXA([v,v,v,a]);

        var r : Float, g : Float, b : Float;
        var i : Int, f : Float, p : Float, q : Float, t : Float;
        var _h = h / 60;

        i = Math.floor(_h);
        f = _h - i;
        p = v * (1 - s);
        q = v * (1 - f * s);
        t = v * (1 - (1 - f) * s);

        switch i{
        case 0: r = v; g = t; b = p;
        case 1: r = q; g = v; b = p;
        case 2: r = p; g = v; b = t;
        case 3: r = p; g = q; b = v;
        case 4: r = t; g = p; b = v;
        default: r = v; g = p; b = q; // case 5
        }

        return new RGBXA([r,g,b,a]);
    }

    public inline function toString() : String
        return 'hsla(${h},${(s*100)}%,${(v*100)}%,${a})';

}
