package om.color.space;

/**
    Hue-Saturation-Value.

    A cylindrical-coordinate representations of points in an RGB color model.
**/
@:access(om.color.space.HSVA)
@:access(om.color.space.RGBX)
abstract HSV(Array<Float>) {

    public static inline function create( h : Float, s : Float, v : Float ) : HSV
    	return new HSV( [h,s,v] );

    @:from public inline static function fromFloats( a : Array<Float> ) : HSV
       return HSV.create( a[0], a[1], a[2] );

    public var h(get,never) : Float;
    inline function get_h() : Float return this[0];

    public var s(get,never) : Float;
    inline function get_s() : Float return this[1];

    public var v(get,never) : Float;
    inline function get_v() : Float return this[2];

    inline function new( a : Array<Float> ) this = a;

    @:to public inline function toRGB() : RGB
        return toRGBX().toRGB();

    @:to public inline function toRGBA() : RGBA
        return toRGBXA().toRGBA();

    @:to public function toRGBX() : RGBX {

        if( s == 0 )
            return new RGBX( [v,v,v] );

        var _r : Float, _g : Float, _b : Float;
        var _h = h / 60;

        var i = Math.floor( _h );
        var f = _h - i;
        var p = v * (1 - s);
        var q = v * (1 - f * s);
        var t = v * (1 - (1 - f) * s);

        switch i {
        case 0: _r = v; _g = t; _b = p;
        case 1: _r = q; _g = v; _b = p;
        case 2: _r = p; _g = v; _b = t;
        case 3: _r = p; _g = q; _b = v;
        case 4: _r = t; _g = p; _b = v;
        default: _r = v; _g = p; _b = q; // case 5
        }
        return new RGBX([_r,_g,_b]);
    }

    @:to public inline function toRGBXA() : RGBXA
        return toRGBX().toRGBXA();

    @:to public inline function toString() : String
        return 'hsv(${h},${s*100}%,${v*100}%)';

    public inline function withAlpha( f : Float ) : HSVA
        return new HSVA( this.concat( [f] ) );

    public inline function withHue( f : Float ) : HSV
        return new HSV( [f,s,v] );

	public inline function withSaturation( f : Float ) : HSV
		return new HSV( [h,f,v] );

	public inline function withValue( f : Float ) : HSV
		return new HSV( [h,s,f] );



}
