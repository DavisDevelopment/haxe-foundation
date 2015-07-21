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

import Std.*;

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

	/**
	  * Append [this] Widget to something
	  */
	public function appendTo(parent : Dynamic):Void {
		if (is(parent, Widget)) {
			cast(parent, Widget).append( this );
		}
		else {
			var par:Element = new Element(parent);
			par.append( el );
		}
	}

	/**
	  * Append something to [this] Widget
	  */
	public function append(child : Dynamic):Void {
		if (is(child, Widget)) {
			el.append(cast(child, Widget).el);
		}
		else {
			var kid:Element = new Element( child );
			el.append( kid );
		}
	}

/* === Computed Instace Fields === */

	/**
	  * The Document as an Element
	  */
	private var doc(get, never):Element;
	private inline function get_doc() return new Element(Win.current.document);

	/**
	  * The textual content of [this] Widget
	  */
	public var text(get, set) : String;
	private inline function get_text() return el.text;
	private inline function set_text(nt : String) return (el.text = nt);

	/**
	  * The width of [this] Widget
	  */
	public var width(get, set):Float;
	private inline function get_width() return el.w;
	private inline function set_width(nw) return (el.w = nw);

	/**
	  * The height of [this] Widget
	  */
	public var height(get, set):Float;
	private inline function get_height() return el.h;
	private inline function set_height(nh) return (el.h = nh);

/* === Instance Fields === */

	/* Underlying Element instance */
	public var el : Null<Element>;
	
	/* Array of Attached Destructibles */
	private var assets : Array<Destructible>;
}
