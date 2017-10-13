package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	
	private var _bg:FlxSprite;
	private var _bgClone:FlxSprite;
	
	private var _frame:FlxSprite;
	
	private var _player:FlxSprite;
	
	private var _mouseControls:Bool = false;
	
	private var _NGRadio:FlxSound;
	
	override public function create():Void
	{
		
		createRadio();
		
		_bg = new FlxSprite(0, 0);
		_bg.makeGraphic(FlxG.width * 2, FlxG.height * 2);
		
		_frame = new FlxSprite(_bg.x - 10, _bg.y - 10);
		_frame.makeGraphic(Std.int(_bg.width + 20), Std.int(_bg.height + 20), FlxColor.BLACK);
		
		_bgClone = new FlxSprite(0, 0);
		_bgClone = _bg.clone();
		_bg.stamp(_bgClone, 0, 0);
		
		_player = new Player(100, 100);
		
		add(_frame);
		add(_bg);
		add(_player);
		
		FlxG.camera.follow(_player);
		FlxG.camera.followLead.x = FlxG.camera.followLead.y = 20;
		FlxG.camera.bgColor = FlxColor.WHITE;
		
		super.create();
	}
	
	private function createRadio():Void
	{
		_NGRadio = new FlxSound();
		
		_NGRadio.play();
		
		_NGRadio.loadStream("http://radio-stream01.ungrounded.net/easylistening", false, false);
		
		_NGRadio.play();
	}

	override public function update(elapsed:Float):Void
	{
		_NGRadio.volume = FlxG.sound.volume;
		
		var velX:Float = _player.velocity.x;
		var velY:Float = _player.velocity.y;
		
		if (velX < 0)
		{
			velX * -1;
		}
		if (velY < 0)
		{
			velY * -1;
		}
		
		FlxG.watch.addQuick("VELY", velY);
		FlxG.watch.addQuick("VELX", velX);
		
		_player.scale.x = _player.scale.y = (FlxMath.remapToRange(velY, 0, 160, 0, 6) + FlxMath.remapToRange(velX, 0, 160, 0, 6));
		
		if (FlxG.keys.pressed.SPACE || FlxG.mouse.pressed)
		{
			_bg.stamp(_player, Std.int(_player.x), Std.int(_player.y));
		}
		
		if (FlxG.keys.justPressed.M)
		{
			_bg.stamp(_bgClone, 0, 0);
			
			//_mouseControls = !_mouseControls;
		}
		
		if (_mouseControls)
		{
			_player.x = FlxG.mouse.x;
			_player.y = FlxG.mouse.y;
		}
		
		super.update(elapsed);
	}
}