package foundation;

import foundation.Styles;
import tannus.html.ElStyles;
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

using Lambda;
using tannus.ds.ArrayTools;
using StringTools;
using tannus.ds.StringUtils;
using tannus.math.TMath;

class Widget extends EventDispatcher implements WidgetAsset implements Elementable {
	/* Constructor Function */
	public function new():Void {
		super();

		__checkEvents = false;

		el = null;
		styles = new Styles(Ptr.create( el ));
		assets = new Array();
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
	  * Test a CSS-selector against [this]
	  */
	public function is(selector : String):Bool {
		if (el == null) {
			return false;
		}
		else {
			return el.is( selector );
		}
	}

	/**
	  * Engage Foundation library
	  */
	private inline function engage():Void {
		Foundation.initialize( el );
	}

	/**
	  * reset [this] Widget's plugin-data, or let Foundation know it exists
	  */
	private inline function reflow():Void {
		Foundation.reInitializeElement( el );
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
		if (Std.is(parent, Widget)) {
			var par:Widget = cast parent;
			par.append( this );
		}
		else {
			var par:Element = new Element(parent);
			par.appendElementable( this );
			parentElement = par;
			parentWidget = null;
		}
	}

	/**
	  * Append something to [this] Widget
	  */
	public function append(child : Dynamic):Void {
		if (Std.is(child, Widget)) {
			var ch:Widget = cast child;
			el.appendElementable(cast child);
			attach( ch );
			ch.parentWidget = this;
			ch.parentElement = el;
		}
		else {
			var kid:Element = new Element( child );
			el.append( kid );
		}
	}

	/**
	  * Determine whether the given Object is (in some way or another) a 'child' of [this] One
	  */
	public function parentOf(child : Dynamic):Bool {
		if (Std.is(child, Widget)) {
			var cw:Widget = cast child;
			return el.contains( cw.el );
		}
		else {
			var ce:Element = new Element( child );
			return el.contains( ce );
		}
	}

	/**
	  * Determine whether the given Object is the parent of [this] one
	  */
	public function childOf(parent : Dynamic):Bool {
		if (Std.is(parent, Widget))
			return cast(parent, Widget).parentOf( parent );
		else
			return new Element( parent ).contains( el );
	}

	/**
	  * Append [child] as a child of [this], and place it at offset [index] in the array
	  */
	public function insertAt(child:Dynamic, index:Int):Void {
		if (!parentOf( child )) {
			append( child );
		}
		if (Std.is(child, Widget)) {
			el.index(cast(child, Widget).toElement(), index);
		}
		else {
			el.index(new Element( child ).at( 0 ), index);
		}
	}

	/**
	  * Ascend the widget hierarchy until a widget for which [test] returns true is found
	  */
	public function parentWidgetUntil<T:Widget>(test : Widget -> Bool):Null<T> {
		if (parentWidget != null) {
			var pw = parentWidget;
			if (test( pw )) {
				return cast pw;
			}
			else return pw.parentWidgetUntil( test );
		}
		else return null;
	}

/* === Utility Methods === */

	/**
	  * Add a class to [this] Widget
	  */
	public function addClass(name : String):Void {
		el.addClass( name );
	}
	public function addClasses(names : Iterable<String>):Void {
		names.iter( addClass );
	}

	/**
	  * Remove a class from [this] Widget
	  */
	public function removeClass(name : String):Void {
		el.removeClass( name );
	}

	/**
	  * Toggle the given class on [this] Widget
	  */
	public function toggleClass(name : String):Void {
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

	/**
	  * forward events from the underlying DOM into our event-system
	  */
	public function forwardEvent(name:String, ?src:Element, ?trans:Dynamic -> Dynamic):Void {
		if (src == null) 
			src = el;
		if (trans == null) 
			trans = (function(x) return untyped x);
		src.on(name, untyped function(raw_event) {
			var event = trans( raw_event );
			dispatch(name, event);
		});
	}

	/**
	  * forward an Array of events
	  */
	public function forwardEvents<A, B>(names:Array<String>, ?src:Element, ?trans:A->B):Void {
		for (n in names) {
			forwardEvent(n, src, trans);
		}
	}

/* === Computed Instace Fields === */

	/* the Document */
	private var d(get, never):js.html.HTMLDocument;
	private inline function get_d():js.html.HTMLDocument return Win.current.document;
	
	/* the Document as an Element */
	private var doc(get, never):Element;
	private inline function get_doc() return new Element( d );

	/**
	  * The textual content of [this] Widget
	  */
	public var text(get, set) : String;
	private function get_text() return el.text;
	private function set_text(nt : String) return (el.text = nt);

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

	/* the CSS properties of [this] Widget */
	public var css(get, never):ElStyles;
	private inline function get_css():ElStyles return el.style;

/* === Instance Fields === */

	/* Underlying Element instance */
	public var el : Null<Element>;
	
	/* Array of Attached Destructibles */
	private var assets : Array<WidgetAsset>;

	/* A Styles instance which points to [this] Widget */
	public var styles : Styles;

	/* the parent widget of [this] one */
	public var parentWidget : Null<Widget> = null;
	public var parentElement : Null<Element> = null;

	/* Whether [this] Widget has been activated yet */
	private var _active:Bool = false;
}
