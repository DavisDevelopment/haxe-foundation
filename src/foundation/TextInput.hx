package foundation;

import foundation.TextualWidget;
import foundation.IInput;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class TextInput extends Input<String> {
	/* Constructor Function */
	public function new():Void {
		super();

		el = '<input></input>';
	}
}
