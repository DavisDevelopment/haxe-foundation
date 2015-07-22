package foundation;

import foundation.Pane;

import tannus.math.Percent;
import Std.*;

using Lambda;

class SplitPane extends Pane {
	/* Constructor Function */
	public function new(ratios : Array<Float>):Void {
		super();
		panes = new Array();
		addClass('row');
		el.css('max-width', '100%');

		var pr:Array<Percent> = [for (r in ratios) new Percent(r)];
		for (r in pr) {
			addPane( r );
		}

		on('activate', function(x) {
			engage();
		});
	}

/* === Instance Methods === */

	/**
	  * Add a Pane of the specified size
	  */
	public function addPane(size : Percent):Pane {
		var pane:Pane = new Pane();
		pane.meta('ratio', size);
		pane.addClass('small-' + Math.round(size.of(12)));
		pane.addClass('columns');
		panes.push( pane );
		append( pane );
		return pane;
	}

	/**
	  * Remove a Pane from [this] SplitPane
	  */
	public inline function pane(i : Int):Null<Pane> {
		return (panes[i]);
	}

/* === Instance Fields === */

	/* Array of Panes associated with [this] SplitPane */
	private var panes : Array<Pane>;
}
