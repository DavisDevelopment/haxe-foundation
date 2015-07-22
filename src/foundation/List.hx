package foundation;

import tannus.html.Element;
import foundation.Widget;

import Std.*;

class List extends Widget {
	/* Constructor Function */
	public function new(ordered:Bool=true):Void {
		super();
		var tag:String = (ordered?'ul':'ol');
		el = '<$tag></$tag>';
		items = new Array();
	}

/* === Instance Methods === */

	/**
	  * Add a new List-Item to [this] List
	  */
	public function addItem(thing : Dynamic):Void {
		var li:Element = '<li></li>';
		if (is(thing, Widget)) {
			var w:Widget = cast thing;
			li.append( w.el );
			items.push( w );
			attach( w );
		}
		else {
			var w:Widget = new Widget();
			w.el = new Element(thing);
			li.append( w.el );
			items.push( w );
			attach( w );
		}
		append( li );
	}

	/**
	  * Remove an item from [this] List
	  */
	public inline function item<T:Widget>(index : Int):Null<T> {
		return untyped items[index];
	}

/* === Instance Fields === */

	/* The items of [this] list */
	private var items:Array<Widget>;
}
