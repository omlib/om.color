package om.color.space;

/**
    CIE XYZ color.
**/
@:access(om.color.space.RGBX)
abstract XYZ(Array<Float>) {

    public static inline function create( x : Float, y : Float, z : Float ) : XYZ
        return new XYZ( [x,y,z] );

    @:from public static inline function fromFloats( a : Array<Float> ) : XYZ
        return XYZ.create( a[0], a[1], a[2] );

    public static var whiteReference(default,null) = new XYZ([0.95047, 1, 1.08883]);
    public static var epsilon(default,null) = 216.0/24389.0; // 0.008856
    public static var kappa(default,null) = 24389.0/27.0; // 903.3

    public var x(get,never) : Float;
    inline function get_x() return this[0];

    public var y(get,never) : Float;
    inline function get_y() return this[1];

    public var z(get,never) : Float;
    inline function get_z() return this[2];

    public var u(get,never) : Float;
    inline function get_u() return (4 * x) / (x + 15 * y + 3 * z);

    public var v(get,never) : Float;
    inline function get_v() return (9 * y) / (x + 15 * y + 3 * z);

    inline function new( a : Array<Float> ) this = a;

    @:to public inline function toRGB(): RGB
        return toRGBX().toRGB();

    @:to public function toRGBX() : RGBX {

        var x = x, y = y, z = z,
        r = x *  3.2406 + y * -1.5372 + z * -0.4986,
        g = x * -0.9689 + y *  1.8758 + z *  0.0415,
        b = x *  0.0557 + y * -0.2040 + z *  1.0570;

        r = r > 0.0031308 ? 1.055 * Math.pow(r, 1.0 / 2.4) - 0.055: 12.92 * r;
        g = g > 0.0031308 ? 1.055 * Math.pow(g, 1.0 / 2.4) - 0.055: 12.92 * g;
        b = b > 0.0031308 ? 1.055 * Math.pow(b, 1.0 / 2.4) - 0.055: 12.92 * b;

        return new RGBX([r,g,b]);
    }

    @:to public inline function toString() : String
        return 'xyz(${x},${y},${z})';

}
