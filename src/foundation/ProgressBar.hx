package foundation;

import foundation.Pane;

import tannus.html.Element;
import tannus.math.Percent;

class ProgressBar extends Pane {
	/* Constructor Function */
	public function new():Void {
		super();
		addClass('progress');
		meter = '<span class="meter"></span>';
		meter.css('width', '0%');
		append( meter );
	}

/* === Computed Instance Fields === */

	/**
	  * The progress
	  */
	public var progress(get, set):Percent;
	private inline function get_progress() return new Percent(Std.parseFloat(meter.css('width')));
	private function set_progress(np : Percent):Percent {
		meter.css('width', np.toString());
		return progress;
	}

/* === Instance Fields === */

	private var meter : Element;
}
