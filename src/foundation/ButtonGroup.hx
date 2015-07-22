package foundation;

import foundation.Button;
import foundation.List;

import Std.*;

using Lambda;

class ButtonGroup extends List {
	/* Constructor Function */
	public function new():Void {
		super();
		el.addClass('button-group');
	}

/* === Instance Methods === */

	/**
	  * Add a Button to [this] Group
	  */
	public function addButton(txt : Dynamic):Button {
		if (is(txt, String)) {
			var button:Button = new Button( txt );
			addItem( button );
			return button;
		}
		else if (is(txt, Button)) {
			var button:Button = cast txt;
			addItem( button );
			return button;
		}
		else {
			throw 'ButtonGroupError: Cannot add $txt as a Button!';
		}
	}

	/**
	  * Remove a Button from the list
	  */
	public function removeButton(btn : Button):Bool {
		var has:Bool = items.has(btn);
		items.remove( btn );
		return has;
	}

	/**
	  * Get a Button from the List
	  */
	public inline function button(index : Int):Null<Button> {
		return cast item(index);
	}

	/**
	  * Obtain a function to toggle a class
	  */
	private inline function tfunc(status : Bool):String->Void {
		return untyped (status?el.addClass:el.removeClass).bind(_);
	}

	/**
	  * Make [this] Group have rounded corners
	  */
	public inline function roundCorners(r : Bool) tfunc(r)('radius');

	/**
	  * Make [this] Group have rounded sides
	  */
	public inline function roundSides(r : Bool) tfunc(r)('round');

/* === Computed Instance Fields === */

	/**
	  * Whether [this] Group is tiny
	  */
	public var tiny(get, set):Bool;
	private inline function get_tiny() return el.is('.tiny');
	private function set_tiny(t : Bool):Bool {
		tfunc(t)('tiny');
		return t;
	}
}
