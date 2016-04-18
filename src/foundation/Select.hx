package foundation;

import tannus.ds.Delta;

import tannus.html.Element;
import js.html.SelectElement;
import js.html.OptionElement;

using Lambda;
using tannus.ds.ArrayTools;

class Select<T> extends Input<T> {
	/* Constructor Function */
	public function new():Void {
		super();

		el = '<label></label>';
		se = '<select></select>';
		el.append( se );
		options = new Array();
		
		__listen();
	}

/* === Instance Methods === */

	/* attach the given Option to [this] */
	public function addOption(o : Option<T>):Option<T> {
		se.append( o.el );
		options.push( o );
		return o;
	}

	/* add an Option to [this] */
	public inline function option(text:String, value:T):Option<T> {
		return addOption(new Option(this, text, value));
	}

	/* get all Options attached to [this] */
	public inline function getOptions():Array<Option<T>> {
		return options.copy();
	}

	/* get the current value of [this] */
	override public function getValue():Null<T> {
		return selectedOption.value;
	}

	/* set the current value of [this] */
	override public function setValue(v : T):Void {
		null;
	}

	/* listen for incoming events */
	private function __listen():Void {
		var prev:Null<T> = null;
		
		se.on('change', function(event : Dynamic):Void {
			var curr = getValue();
			var change:Delta<T> = new Delta(curr, prev);
			prev = curr;
			dispatch('change', change);
		});
	}

/* === Computed Instance Fields === */

	/* the Option which is currently selected */
	public var selectedOption(get, never):Option<T>;
	private inline function get_selectedOption():Option<T> return options[s.selectedIndex];

	/* [s] as it's underlying type */
	public var s(get, never):SelectElement;
	private inline function get_s():SelectElement return cast se.at( 0 );

/* === Instance Fields === */

	/* the <select> element */
	private var se : Element;
	
	/* the Options attached to [this] */
	private var options : Array<Option<T>>;
}

class Option<T> extends Widget {
	/* Constructor Function */
	public function new(s:Select<T>, t:String, v:T):Void {
		super();

		el = '<option></option>';
		el.data('hxModel:Option', this);
		text = t;
		value = v;
	}

/* === Computed Instance Fields === */

	public var o(get, never):OptionElement;
	private inline function get_o():OptionElement return cast el.at( 0 );

	public var value(get, set):T;
	private inline function get_value():T return untyped el.data( '__v' );
	private inline function set_value(v : T):T {
		el.data('__v', v);
		return value;
	}
}
