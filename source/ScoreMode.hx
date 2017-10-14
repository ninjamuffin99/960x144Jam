package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class ScoreMode extends FlxSpriteGroup 
{
	
	private var _timer:FlxText;
	private var _timeLimit:Float = 60; //60 seconds, in milliseconds

	public function new() 
	{
		super();
		
		_timer = new FlxText(0, FlxG.height * 0.1, 0, Std.string(_timeLimit), 20);
		_timer.color = FlxColor.BLACK;
		_timer.x = FlxG.width - 20;
		add(_timer);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		_timeLimit -= FlxG.elapsed;
		_timeLimit = FlxMath.roundDecimal(_timeLimit, 2);
		
		_timer.text = Std.string(_timeLimit);
		
		super.update(elapsed);
	}
	
}