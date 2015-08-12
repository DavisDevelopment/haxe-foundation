package foundation;

import foundation.TextualWidget;
import foundation.IInput;

import tannus.html.Element;
import tannus.io.Signal;
import tannus.io.Signal2;
import tannus.io.RegEx;
import tannus.io.Pointer in Ptr;
import tannus.ds.Maybe;
import tannus.ds.Memory;
import tannus.ds.Object;

class TextInput extends TextualWidget implements IInput<String> {
	/* Constructor Function */
	public function new(?n:Maybe<String>):Void {
		super();

		el = '<input type="text"/>';

		_lastval = '';
		_change = new Signal2();
		_ph = Ptr.dual(el['placeholder'].value, el['placeholder']);

		name = Memory.uniqueIdString('textinput-');

		__init();
	}

/* === Instance Methods === */

	/**
	  * Initialize [this] TextInput
	  */
	private function __init():Void {
		__bindEvents();
	}

	/**
	  * Binds Events from [el] to [this]
	  */
	private function __bindEvents():Void {
		el.on('input', function(e) {
			var val:String = getValue();
			_change.call(_lastval, val);
			_lastval = val;
		});

		addSignals(['keydown', 'keydown:enter', 'keydown:space']);
		el.on('keydown', function(e : Object) {
			var event:Object = {};
			event.write(e.plucka(['keyCode', 'shiftKey', 'ctrlKey', 'altKey', 'metaKey']));
			var ev:Dynamic = event;
			dispatch('keydown', ev);
			switch (ev.keyCode) {
				case 13:
					dispatch('keydown:enter', ev);

				case 32:
					dispatch('keydown:space', ev);

				default:
					null;
			}
		});

		el.on('focusin', function( e ) {
			dispatch('focusin', this);
		});

		el.on('focusout', function( e ) {
			dispatch('focusout', this);
		});
	}

	/**
	  * Get the value of [this] Input
	  */
	public function getValue():String {
		return (el.val());
	}

	/**
	  * Set the value of [this] Input
	  */
	public function setValue(nv : String):String {
		el.val( nv );
		return getValue();
	}

	/**
	  * Listen for change events
	  */
	public function change():Signal2<String, String> {
		return _change;
	}

	/**
	  * Shift focus to [this] Input
	  */
	public function focus():Void {
		var inp = el.toHTMLElement();
		inp.focus();
	}

	/**
	  * Highlight a range of [this] Input
	  */
	public function select(min:Int, max:Int):Void {
		inp.select();
		inp.selectionStart = min;
		inp.selectionEnd = max;
	}

	/**
	  * Get the selected text of [this] Input
	  */
	public function getSelection():String {
		return value.substring(inp.selectionStart, inp.selectionEnd);	
	}

/* === Computed Instance Fields === */

	/**
	  * The 'name' of [this] Input
	  */
	public var name(get, set):String;
	private inline function get_name() return el['name'].value;
	private inline function set_name(nn) return (el['name'] = nn);

	/**
	  * The value of [this] Input
	  */
	public var value(get, set):String;
	private inline function get_value() return getValue();
	private inline function set_value(nv) return setValue( nv );

	/**
	  * The 'placeholder' for [this] Input
	  */
	public var placeholder(get, set):String;
	private inline function get_placeholder() return _ph._;
	private inline function set_placeholder(ph) return (_ph &= ph);

	/**
	  * The 'validator' Function for [this] Input
	  */
	public var validator(get, set):String->Bool;
	private inline function get_validator() return _validate;
	private inline function set_validator(nv) return (_validate = nv);

	/**
	  * Whether the value of [this] Input is currently valid
	  */
	public var valid(get, never):Bool;
	private inline function get_valid() return validator( value );

	/**
	  * [this] Input, as a js.html.InputElement
	  */
	public var inp(get, never):js.html.InputElement;
	private inline function get_inp() return (cast el.toHTMLElement());

/* === Instance Fields === */

	/* Reference to the last known value of [this] Input */
	private var _lastval : String;

	/* Signal fired when [this] Value changes */
	private var _change : Signal2<String, String>;

	/* A Pointer to the 'placeholder' of [this] Input */
	private var _ph : Ptr<String>;

	/* The validator for [this] Input */
	private var _validate : String -> Bool;
}
