package foundation;

import foundation.TextualWidget;
import foundation.IInput;

import js.html.InputElement;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class DOMInput<T> extends Input<T> {
	/* Constructor Function */
	public function new():Void {
		super();

		el = '<input></input>';
	}

	private var iel(get, never):InputElement;
	private function get_iel():InputElement return cast el.at( 0 );
}
