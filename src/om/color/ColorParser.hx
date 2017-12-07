package om.color;

using om.ArrayTools;

enum Int2FloatMode {
    HexMode;
    DegreeMode;
    NaturalMode;
}

enum ChannelInfo {
    CIDegree( value : Float );
    CIFloat( value : Float );
    CIInt( value : Int );
    CIPercent( value : Float );
}

class ColorInfo {

    public var name(default,null) : String;
    public var channels(default,null) : Array<ChannelInfo>;

    public function new( name : String, channels : Array<ChannelInfo> ) {
        this.name = name;
        this.channels = channels;
    }

    public function toString() {
        return '$name, channels: $channels';
    }
}

class ColorParser {

    static var isPureHex = ~/^([0-9a-f]{2}){3,4}$/i;

    public static function parseColor( s : String ) : ColorInfo
        return new ColorParser().processColor( s );

    public static function parseHex( s : String ) : ColorInfo
        return new ColorParser().processHex( s );

    public static function parseChannel( s : String ) : ChannelInfo
        return new ColorParser().processChannel( s );

    var pattern_color : EReg;
    var pattern_channel : EReg;

    public function new() {
        pattern_color = ~/^\s*([^(]+)\s*\(([^)]*)\)\s*$/i;
        pattern_channel = ~/^\s*(-?\d*.\d+|-?\d+)(%|deg|rad)?\s*$/i;
    }

    public function processColor( s : String ) : ColorInfo {
        if( !pattern_color.match( s ) )
            return null;
        var name = pattern_color.matched( 1 );
        if( name == null )
            return null;
        name = name.toLowerCase();

        var m2 = pattern_color.matched( 2 );
        var s_channels = null == m2 ? [] : m2.split(",");
        var channels = [];
        var channel;
        for( s_channel in s_channels ) {
            channel = processChannel( s_channel );
            if( channel == null )
                return null;
            channels.push( channel );
        }
        return new ColorInfo( name, channels );
    }

    public function processChannel( s : String ) : ChannelInfo {
        if( !pattern_channel.match( s ) )
            return null;
        var value = pattern_channel.matched( 1 );
        var unit  = pattern_channel.matched( 2 );
        if( unit == null ) unit = "";
        return try switch unit {
            case "%" if( FloatTools.canParse(value) ):
                CIPercent( FloatTools.parse( value ) );
            case("deg" | "DEG") if( FloatTools.canParse( value ) ):
                CIDegree( FloatTools.parse( value ) );
            case("rad" | "RAD") if( FloatTools.canParse( value ) ):
                CIDegree( FloatTools.parse( value ) * 180 / Math.PI );
            case "" if( value == '${IntTools.parse(value)}' ):
                var i = IntTools.parse( value );
                CIInt( i );
            case "" if( FloatTools.canParse( value ) ):
                CIFloat( FloatTools.parse( value ) );
            default:
                null;
        } catch(e:Dynamic)
            return null;
    }

    public function processHex( s : String ) : ColorInfo {
        if( !isPureHex.match( s ) ) {
            if( s.substr( 0, 1 ) == "#" ) {
                if( s.length == 4 ) // needs dup
                    s = s.charAt(1) + s.charAt(1) + s.charAt(2) + s.charAt(2) + s.charAt(3) + s.charAt(3);
                else if(s.length == 5)// needs dup
                    s = s.charAt(1) + s.charAt(1) + s.charAt(2) + s.charAt(2) + s.charAt(3) + s.charAt(3) + s.charAt(4) + s.charAt(4);
                else
                    s = s.substr(1);
            } else if( s.substr( 0, 2 ) == "0x" )
                s = s.substr(2);
            else
                return null;
        }
        var channels = [];
        while( s.length > 0 ) {
            channels.push( CIInt( Std.parseInt( '0x${s.substr(0,2)}' ) ) );
            s = s.substr( 2 );
        }
        if( channels.length == 4 )
            return new ColorInfo( "hexa", channels.slice(1).concat([channels[0]] ) );
        else
            return new ColorInfo( "rgb", channels );
    }

    public static function getFloatChannels( channels : Array<ChannelInfo>, length : Int, modes : Array<Int2FloatMode> ) {
        if( length != channels.length )
            throw 'invalid number of channels, expected $length but it is ${channels.length}';
        return channels.mapi( (v,i) -> getFloatChannel( v, modes[i] ) );
    }

    public static function getFloatChannel( channel : ChannelInfo, mode: Int2FloatMode ) : Float
        return switch [channel,mode] {
        case [CIFloat(v) , _]: v;
        case [CIInt(v) , HexMode]: v / 255;
        case [CIInt(v) , DegreeMode]: v;
        case [CIInt(v) , NaturalMode]: v;
        case [CIDegree(v) , _]: v;
        case [CIPercent(v) , DegreeMode]: v / 100 * 360;
        case [CIPercent(v) , _]: v / 100;
        default: throw 'can\'t get a float value from $channel';
        };

}
