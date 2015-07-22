package foundation;

import foundation.Styles;
import foundation.WidgetAsset;

import tannus.io.EventDispatcher;
import tannus.io.Signal;
import tannus.io.Ptr;
import tannus.ds.Memory;
import tannus.ds.Object;
import tannus.ds.Destructible;
import tannus.math.TMath;
import tannus.geom.Point;
import tannus.html.Element;
import tannus.html.Elementable;
import tannus.html.Win;

import Std.*;

class Widget extends EventDispatcher implements WidgetAsset implements Elementable {
	/* Constructor Function */
	public function new():Void {
		super();

		el = null;
		styles = new Styles(Ptr.create( el ));
		assets = new Array();

		addSignals(['activate']);
	}

/* === Instance Methods === */

	/**
	  * Add a Destructible Object
	  */
	public function attach(asset : WidgetAsset):Void {
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
	  * Cast [this] Widget to an Element
	  */
	public function toElement():Element {
		return el;
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
	  * Activate [this] Widget
	  */
	public function activate():Void {
		//- mark [this] Widget as active
		_active = true;
		
		//- activate all attachments
		for (child in assets) {
			child.activate();
		}

		//- finally, dispatch the 'activate' Event
		dispatch('activate', this);
	}

	/**
	  * Append [this] Widget to something
	  */
	public function appendTo(parent : Dynamic):Void {
		if (is(parent, Widget)) {
			var par:Widget = cast parent;
			par.append( this );
			par.attach( par );
		}
		else {
			var par:Element = new Element(parent);
			par.appendElementable( this );
		}
	}

	/**
	  * Append something to [this] Widget
	  */
	public function append(child : Dynamic):Void {
		if (is(child, Widget)) {
			var ch:Widget = cast child;
			el.appendElementable(cast child);
			attach( ch );
		}
		else {
			var kid:Element = new Element( child );
			el.append( kid );
		}
	}

/* === Utility Methods === */

	/**
	  * Add a class to [this] Widget
	  */
	private function addClass(name : String):Void {
		el.addClass( name );
	}

	/**
	  * Remove a class from [this] Widget
	  */
	private function removeClass(name : String):Void {
		el.addClass( name );
	}

	/**
	  * Toggle the given class on [this] Widget
	  */
	private function toggleClass(name : String):Void {
		el.toggleClass( name );
	}

	/**
	  * Obtain an Array of classes applied to [this] Widget
	  */
	private inline function classes():Array<String> {
		return (el['class'].value.split(' '));
	}

	/**
	  * Add some metadata to [this] Widget
	  */
	public function meta<T>(name:String, ?value:T):Null<T> {
		if (value == null) {
			return cast el.data(name);
		}
		else {
			el.data(name, value);
			return value;
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
	private var assets : Array<WidgetAsset>;

	/* A Styles instance which points to [this] Widget */
	public var styles : Styles;

	/* Whether [this] Widget has been activated yet */
	private var _active:Bool = false;
}
