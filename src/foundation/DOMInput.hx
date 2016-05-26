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

/* === Instance Methods === */

	/* shift focus to [this] Input */
	public function focus():Void iel.focus();

	/* highlight all or part of [this]'s value */
	public function select(?start:Int, ?end:Int):Void {
		iel.select();
		if (start != null) {
			iel.selectionStart = start;
			iel.selectionEnd = (end == null ? iel.value.length : end);
		}
	}

/* === Instance Fields === */

	private var ntype(get, set):String;
	private inline function get_ntype():String return iel.type;
	private inline function set_ntype(v : String):String return (iel.type = v);

	/* reference to the underlying input */
	private var iel(get, never):InputElement;
	private function get_iel():InputElement return cast el.at( 0 );
}
