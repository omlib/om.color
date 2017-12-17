package om.color.space;

/**
    CIELUV
**/
@:access(om.color.space.RGBX)
@:access(om.color.space.XYZ)
abstract LUV(Array<Float>) {

    public static inline function create( l : Float, u : Float, v : Float ) : LUV
        return new LUV( [l,u,v] );

    @:from public static inline function fromFloats( a : Array<Float> ) : LUV
        return LUV.create( a[0], a[1], a[2] );

    public var l(get,never) : Float;
    inline function get_l() return this[0];

    public var u(get,never) : Float;
    inline function get_u() return this[1];

    public var v(get,never) : Float;
    inline function get_v() return this[2];

    @:noCompletion public inline function new( a : Array<Float> ) this = a;

    @:to public function toRGB() return toRGBX().toRGB();
    @:to public function toRGBX() return toXYZ().toRGBX();
    @:to public function toString() return 'cieluv(${l},${u},${v})';

    @:to public function toXYZ() : XYZ {
        var u = u * 100;
        var v = v * 100;
        var x = 9 * u / (9 * u - 16 * v + 12);
        var y = 4 * v / (9 * u - 16 * v + 12);
        var uPrime = (l == 0 ? 0: u / (13 * l)) + XYZ.whiteReference.u * 100;
        var vPrime = (l == 0 ? 0: v / (13 * l)) + XYZ.whiteReference.v * 100;
        var Y = l > 8 ?
              XYZ.whiteReference.y * 100 * Math.pow((l + 16)/116, 3):
              XYZ.whiteReference.y * 100 * l * Math.pow(3/29, 3);
        var X = Y * 9 * uPrime / (4 * vPrime);
        var Z = Y * (12 - 3 * uPrime - 20 * vPrime) / (4 * vPrime);
        return new XYZ([X / 100, Y / 100, Z / 100]);
    }

}
