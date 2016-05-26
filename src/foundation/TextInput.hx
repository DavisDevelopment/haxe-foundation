package foundation;

import foundation.TextualWidget;
import foundation.IInput;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

/**
  * class TextInput wraps js.html.InputElement[type=text]
  */
class TextInput extends DOMInput<String> {
	/* Constructor Function */
	public function new():Void {
		super();

		// el = '<input></input>';
		ntype = 'text';
	}
}
