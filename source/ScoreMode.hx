package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
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
	
	public var _timeLimit:Float = 60; //60 seconds, in milliseconds
	public var _timerStarted:Bool = false;
	
	public var _timerGrp:FlxSpriteGroup;
	private var _instructionGrp:FlxSpriteGroup;

	private var _running:Bool = false;
	public function new() 
	{
		super();
		
		//instructionsInit();
		createTimer();
		//newTimer();
	}
	
	private function instructionsInit():Void
	{
		var _instructBG:FlxSprite;
		_instructBG = new FlxSprite();
		_instructBG.makeGraphic(400, 300);
		_instructBG.screenCenter(X);
		
		var _instructBG2:FlxSprite;
		_instructBG2 = new FlxSprite(0, 0 - 3);
		_instructBG2.makeGraphic(406, 306, FlxColor.BLACK);
		_instructBG2.screenCenter(X);
		
		var _instructionText:FlxText;
		_instructionText = new FlxText(150, 15, 270, "Draw over the image and create a gesture drawing for points!", 30);
		_instructionText.color = FlxColor.BLACK;
		
		_instructionGrp = new FlxSpriteGroup();
		_instructionGrp.add(_instructBG2);
		_instructionGrp.add(_instructBG);
		_instructionGrp.add(_instructionText);
		
		add(_instructionGrp);
		
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
	
	public function startScore():Void
	{
		_instructionGrp.y = 0 - 100;
		_instructionGrp.alpha = 1;
		//FlxTween.tween(_instructionGrp, {y: FlxG.height}, 5);
		
		newTimer();
	}
	
	public function newTimer():Void
	{
		_timerGrp.alpha = 1;
		_timerStarted = true;
		_timeLimit = 60;
		//FlxTween.tween(_timerGrp, {y: FlxG.height * 0.1}, 0.8, {ease:FlxEase.backOut});
		_running = false;
		//FlxTween.tween(_timerGrp, {alpha:1}, 0.7, {ease:FlxEase.quartInOut});
	}
	
	public function killTimer():Void
	{
		_timeLimit = 0;
		_timerGrp.alpha = 0;
		
	}
	
}