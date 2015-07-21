package foundation;

import tannus.io.EventDispatcher;
import tannus.io.Signal;
import tannus.io.Ptr;
import tannus.ds.Memory;
import tannus.ds.Object;
import tannus.ds.Destructible;
import tannus.math.TMath;
import tannus.geom.Point;
import tannus.html.Element;
import tannus.html.Win;

class Widget extends EventDispatcher implements Destructible {
	/* Constructor Function */
	public function new():Void {
		super();

		el = null;
		assets = new Array();
	}

/* === Instance Methods === */

	/**
	  * Add a Destructible Object
	  */
	public function attach(asset : Destructible):Void {
		assets.push( asset );
	}

	/**
	  * Destroy [this] Widget
	  */
	public function destroy():Void {
		for (x in assets)
			x.destroy();
		if (el != null)
			el.remove();
	}

	/**
	  * Engage Foundation library
	  */
	private function engage():Void {
		untyped {
			doc.foundation();
		};
	}

/* === Computed Instace Fields === */

	/**
	  * The Document as an Element
	  */
	private var doc(get, never):Element;
	private inline function get_doc() return new Element(Win.current.document);

/* === Instance Fields === */

	/* Underlying Element instance */
	public var el : Null<Element>;
	
	/* Array of Attached Destructibles */
	private var assets : Array<Destructible>;
}
