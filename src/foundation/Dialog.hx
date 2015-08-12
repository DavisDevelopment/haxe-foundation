package foundation;

import foundation.Pane;
import foundation.Link;

import tannus.html.Element;
import tannus.ds.Memory;

class Dialog extends Pane {
	/* Constructor Function */
	public function new():Void {
		super();
		addClass('reveal-modal');
		var id:String = Memory.uniqueIdString('dialog-');
		var a = el.attributes;
		a += {
			'id': id,
			'data-reveal': 'yes',
			'aria-hidden': 'true',
			'role': 'dialog'
		};
		closeButton = new Link('', '#');
		closeButton.el.html('&#215;');
		closeButton.addClass('close-reveal-modal');
		closeButton.el.attr('aria-label', 'Close');
		append( closeButton );

		addSignals(['open', 'close']);
		closeButton.on('click', function(x) {
			dispatch('close', this);
		});
		var bg:Element = 'div.reveal-modal-bg';
		bg.on('click', function(x) {
			dispatch('close', this);
		});
	}

/* === Instance Methods === */

	/**
	  * Open [this] Dialog
	  */
	public function open():Void {
		if (!el.is('html *')) {
			appendTo('body');
			activate();
			engage();
		}
		untyped {
			el.foundation('reveal', 'open');
		};
		dispatch('open', this);
	}

	/**
	  * Close [this] Dialog
	  */
	public function close():Void {
		untyped {
			el.foundation('reveal', 'close');
		};
		dispatch('close', this);
	}

/* === Computed Instance Fields === */

	/**
	  * The 'size' of [this] Dialog
	  */
	public var size(get, set):DialogSize;
	private function get_size():DialogSize {
		var t = (function(n) return el.is('.$n'));
		if (t('tiny'))
			return Tiny;
		else if (t('small'))
			return Small;
		else if (t('medium'))
			return Medium;
		else if (t('large'))
			return Large;
		else if (t('xlarge'))
			return ExtraLarge;
		else if (t('fill'))
			return Fill;
		else return null;
	}
	private function set_size(ns : DialogSize):DialogSize {
		var all = ['tiny', 'small', 'medium', 'large', 'xlarge', 'fill'];
		for (s in all) {
			removeClass( s );
		}
		addClass( ns );
		return ns;
	}

/* === Instance Fields === */

	/* Link which user may click to close [this] Dialog */
	private var closeButton : Link;
}

/**
  * Enum of all possible Dialog sizes
  */
@:enum
abstract DialogSize (String) from String to String {
	var Tiny = 'tiny';
	var Small = 'small';
	var Medium = 'medium';
	var Large = 'large';
	var ExtraLarge = 'xlarge';
	var Fill = 'fill';
}
