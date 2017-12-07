package om.color.space;

@:access(om.color.space.RGBX)
abstract RGBXA(Array<Float>) {

    public static inline function create( r : Float, g : Float, b : Float, a : Float ) : RGBXA
        return new RGBXA( [r,g,b,a] );

    @:from public static inline function fromInts( a: Array<Int> ) : RGBXA
        return RGBXA.create( a[0]/255, a[1]/255, a[2]/255, a[3]/255 );

    @:from public static function fromInt( i : Int ) : RGBXA {
        var c : RGBA = i;
        return create( c.r/255, c.g/255, c.b/255, c.a/255 );
    }

    public var r(get,never) : Float;
    inline function get_r() : Float return this[0];

    public var g(get,never) : Float;
    inline function get_g() : Float return this[1];

    public var b(get,never) : Float;
    inline function get_b() : Float return this[2];

    public var a(get,never) : Float;
    inline function get_a() : Float return this[3];

    inline function new(channels : Array<Float>) this = channels;

    public function inSpace() : Bool
        return r >= 0 && r <= 1 && g >= 0 && g <= 1 && b >= 0 && b <= 1 && a >= 0 && a <= 1;

    @:to public inline function toHSLA() : HSLA
        return toRGBX().toHSL().withAlpha( a );

    @:to public inline function toHSVA() : HSVA
        return toRGBX().toHSV().withAlpha( a );

    @:to public inline function toRGB() : RGB
        return toRGBX().toRGB();

    @:to public inline function toRGBA() : RGBA
        return RGBA.fromFloats([r,g,b,a]);

    @:to public inline function toRGBX() : RGBX
        return new RGBX( this.slice(0,3) );

    @:to public inline function toString() : String
        return 'rgba(${(r*100)}%,${(g*100)}%,${(b*100)}%,${a})';

}
