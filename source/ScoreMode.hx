package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

/**
 * ...
 * @author ninjaMuffin
 */
class ScoreMode extends FlxSpriteGroup 
{
	
	private var _timer:FlxText;
	
	private var _timeLimit:Float = 60; //60 seconds, in milliseconds
	private var _timerStarted:Bool = false;
	
	private var _timerGrp:FlxSpriteGroup;

	public function new() 
	{
		super();
		
		instructionsInit();
		
		createTimer();
		newTimer();
	}
	
	private function instructionsInit():Void
	{
		var _intstuctBG:FlxSprite(0, 0);
		_intstuctBG.makeGraphic(400, 300);
		_intstuctBG.screenCenter(X);
		
		var _intstuctBG2:FlxSprite(0, 0);
		_intstuctBG2.makeGraphic(400, 300);
		_intstuctBG2.screenCenter(X);
	}
	
	private function createTimer():Void
	{
		_timer = new FlxText(0, FlxG.height * 0.1, 0, Std.string(_timeLimit), 20);
		_timer.color = FlxColor.BLACK;
		_timer.screenCenter(X);
		
		var _timerBg:FlxSprite;
		_timerBg = new FlxSprite(0, _timer.y - 10);
		_timerBg.makeGraphic(100, 40);
		_timerBg.screenCenter(X);
		
		var _timerBg2:FlxSprite;
		_timerBg2 = new FlxSprite(0, _timer.y - 14);
		_timerBg2.makeGraphic(106, 46, FlxColor.BLACK);
		_timerBg2.screenCenter(X);
		
		_timerGrp = new FlxSpriteGroup();
		_timerGrp.add(_timerBg2);
		_timerGrp.add(_timerBg);
		_timerGrp.add(_timer);
		add(_timerGrp);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (_timerStarted)
		{
			_timeLimit -= FlxG.elapsed;
			_timeLimit = FlxMath.roundDecimal(_timeLimit, 2);
			
			_timer.text = Std.string(_timeLimit);
			if (_timeLimit <= 0)
			{
				_timerStarted = false;
				killTimer();
			}
		}
		
		
		super.update(elapsed);
	}
	
	public function newTimer():Void
	{
		_timerGrp.alpha = 0;
		_timerStarted = true;
		_timeLimit = 60;
		_timerGrp.y = 0 - 44;
		FlxTween.tween(_timerGrp, {y: FlxG.height * 0.1}, 0.8, {ease:FlxEase.backOut});
		//FlxTween.tween(_timerGrp, {alpha:1}, 0.7, {ease:FlxEase.quartInOut});
	}
	
	public function killTimer():Void
	{
		FlxTween.tween(_timerGrp, {y:FlxG.camera.scroll.y - 46}, 0.8, {ease:FlxEase.backIn});
		FlxTween.tween(_timerGrp, {alpha:0}, 0.7, {ease:FlxEase.quartInOut});
	}
	
}