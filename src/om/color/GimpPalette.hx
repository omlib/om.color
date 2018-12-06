package om.color;

import om.error.InvalidFormat;

using StringTools;

private typedef Color = {
	var r : Int;
	var g : Int;
	var b : Int;
	@:optional var name : String;
}

/**
	Gimp palette (.gpl) file format.
*/
class GimpPalette {

    //static var EREG_NAME = ~/^ *Name: *(.+) *$/;
    //static var EREG_COLOR = ~/^ *([0-9][0-9]?[0-9]?)\s+([0-9][0-9]?[0-9]?)\s+([0-9][0-9]?[0-9]?)(\s+(.+))*$/i;

	public var name : String;
	public var columns : Int;
	public var colors : Array<Color>;

	public function new( name : String, columns : Int, ?colors : Array<Color> ) {
		this.name = name;
		this.columns = columns;
		this.colors = (colors != null) ? colors : [];
	}

	public function toString() : String {
		var str = 'GIMP Palette\nName: $name\nColumns: $columns\n#\n';
		for( c in colors )
            str += c.r+' '+c.g+' '+c.b+' '+c.name+'\n';
		return str;
	}

	public static function parse( str : String ) : GimpPalette {

		var lines = str.split( '\n' );

		if( lines[0] != 'GIMP Palette' )
			return throw new InvalidFormat( 'gpl', 'missing header' );

		var regx = ~/^ *Name: *(.+) *$/;
		var name = regx.match( lines[1] ) ? regx.matched(1) : throw new InvalidFormat( 'gpl' );

		var _columns = lines[2];
		_columns = _columns.substr( _columns.indexOf( ':' )+1 ).trim();

		if( lines[3].trim() != '#' )
			return throw new InvalidFormat( 'gpl' );

		var palette = new GimpPalette( name, Std.parseInt( _columns ) );

		regx = ~/^([0-9][0-9]?[0-9]?)\s+([0-9][0-9]?[0-9]?)\s+([0-9][0-9]?[0-9]?)(.*)$/i;

		for( i in 4...lines.length-1 ) {
			var line = lines[i].trim();
			if( line.length == 0 )
				continue;
			if( !regx.match( line ) )
				return throw new InvalidFormat( 'gpl' );
			palette.colors.push({
				r: Std.parseInt( regx.matched(1) ),
				g: Std.parseInt( regx.matched(2) ),
				b: Std.parseInt( regx.matched(3) ),
				name: regx.matched(4).trim()
			});
		}

		return palette;
	}

}
