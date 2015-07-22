package foundation;

import foundation.Widget;
import tannus.graphics.Color;

class TextualWidget extends Widget {
	/* Constructor Function */
	public function new():Void {
		super();
	}

/* === Computed Instance Fields === */

	/**
	  * The Color of the text
	  */
	public var textColor(get, set):Color;
	private function get_textColor():Color {
		var tc:String = el.css('color');
		return Color.fromString( tc );
	}
	private function set_textColor(tc : Color):Color {
		el.css('color', tc.toString());
		return textColor;
	}

	/**
	  * The Font-Family of the text
	  */
	public var fontFamily(get, set):String;
	private function get_fontFamily():String {
		return el.css('font-family');
	}
	private function set_fontFamily(nf : String):String {
		el.css('font-family', nf);
		return fontFamily;
	}
}
