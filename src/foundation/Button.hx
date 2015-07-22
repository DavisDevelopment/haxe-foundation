package foundation;

import foundation.Widget;
import foundation.ButtonSize;

class Button extends Widget {
	/* Constructor Function */
	public function new(txt : String):Void {
		super();
		el = '<a href="#" class="button">$txt</a>';
		__init();
	}

/* === Instance Methods === */

	/**
	  * Initalize [this] Button
	  */
	private function __init():Void {
		addSignals(['click', 'mouseenter', 'mouseleave']);
		el.on('mouseenter mouseleave', function( event ) {
			dispatch(event.type, event);
		});

		el.on('click', function( event ) {
			if (!disabled) {
				dispatch('click', event);
			}
		});
	}

	/**
	  * Reset [this] Button's size to 'normal'
	  */
	private function resetSize():Void {
		var all:Array<ButtonSize> = [Tiny, Small, Large, Fill];
		for (s in all)
			el.removeClass(s);
	}

/* === Computed Instance Fields === */

	/**
	  * The size of [this] Button
	  */
	public var size(get, set):Array<ButtonSize>;
	private function get_size():Array<ButtonSize> {
		var result:Array<ButtonSize> = new Array();
		if (el.is('.tiny')) result.push(Tiny);
		if (el.is('.small')) result.push(Small);
		if (el.is('.large')) result.push(Large);
		if (el.is('.expand')) result.push(Fill);
		if (!el.is('.tiny') && !el.is('.small') && !el.is('.large') && !el.is('.expand'))
			result.push( Normal );
		return result;
	}
	private function set_size(sizes : Array<ButtonSize>) {
		resetSize();
		for (s in sizes)
			el.addClass( s );
		return sizes;
	}

	/**
	  * Whether [this] Button is 'tiny'
	  */
	public var tiny(get, set):Bool;
	private function get_tiny() return el.is('.tiny');
	private function set_tiny(t : Bool):Bool {
		(t?el.addClass:el.removeClass)('tiny');
		return t;
	}

	/**
	  * Whether [this] Button is 'small'
	  */
	public var small(get, set):Bool;
	private function get_small() return el.is('.small');
	private function set_small(s : Bool):Bool {
		(s?el.addClass:el.removeClass)('small');
		return s;
	}

	/**
	  * Whether [this] Button is 'normal'
	  */
	public var normal(get, set):Bool;
	private function get_normal()
		return (!el.is('.tiny') && !el.is('.small') && !el.is('.large') && !el.is('.expand'));
	private function set_normal(n : Bool):Bool {
		if (n)
			resetSize();
		return n;
	}

	/**
	  * Whether [this] Button is 'large'
	  */
	public var large(get, set):Bool;
	private function get_large() return el.is('.large');
	private function set_large(l : Bool):Bool {
		(l?el.addClass:el.removeClass)('large');
		return l;
	}

	/**
	  * Whether [this] Button is 'expanded'
	  */
	public var fill(get, set):Bool;
	private function get_fill() return el.is('.expand');
	private function set_fill(s : Bool):Bool {
		(s?el.addClass:el.removeClass)('expand');
		return s;
	}

	/**
	  * Whether [this] Button is 'disabled'
	  */
	public var disabled(get, set):Bool;
	private function get_disabled() return el.is('.disabled');
	private function set_disabled(d : Bool):Bool {
		(d?el.addClass:el.removeClass)('disabled');
		return d;
	}

	/**
	  * Whether [this] Button has rounded edges
	  */
	public var roundedCorners(get, set):Bool;
	private function get_roundedCorners() return el.is('.radius');
	private function set_roundedCorners(r : Bool):Bool {
		(r?el.addClass:el.removeClass)('radius');
		return r;
	}

	/**
	  * Whether [this] Button has rounded sides
	  */
	public var roundedSides(get, set):Bool;
	private function get_roundedSides() return el.is('.round');
	private function set_roundedSides(r : Bool):Bool {
		(r?el.addClass:el.removeClass)('round');
		return r;
	}
}
