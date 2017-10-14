package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.utils.ByteArray;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.plugin.screengrab.FlxScreenGrab;
import flixel.addons.util.PNGEncoder;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import openfl.net.FileReference;

class PlayState extends FlxState
{
	
	private var _bg:FlxSprite;
	private var _bgClone:FlxSprite;
	private var _bgUndo:FlxSprite;
	private var _bgRedo:FlxSprite;
	
	private var _frame:FlxSprite;
	
	private var _player:FlxSprite;
	
	private var _NGRadio:FlxSound;
	private var _screenGrab:FlxButton;
	
	private var _title:FlxText;
	private var _prompts:FlxText;
	
	private var _reference:FlxSprite;
	
	private var _maxBrushSize:Float = 6;
	
	/**
	 * Timer so that when inking, it doesn't save the initial do in the undo/redo
	 */
	private var _timer:Float = 0.05;
	
	override public function create():Void
	{
		
		createRadio();
		
		_title = new FlxText(0, -135, 0, "Title Here\nControls:\nWASD = Move\nSpacebar= Draw", 25);
		_title.color = FlxColor.BLACK;
		add(_title);
		
		
		var curr_date:Date = Date.now();
		
		_prompts = new FlxText(400, -40, 0, "Prompt of the day: " + Prompts.prompts[curr_date.getDate()], 25);
		_prompts.color = FlxColor.BLACK;
		add(_prompts);
		
		_bg = new FlxSprite(0, 0);
		_bg.makeGraphic(FlxG.width * 2, FlxG.height * 2);
		
		_frame = new FlxSprite(_bg.x - 10, _bg.y - 10);
		_frame.makeGraphic(Std.int(_bg.width + 20), Std.int(_bg.height + 20), FlxColor.BLACK);
		
		_bgClone = new FlxSprite(0, 0);
		_bgClone = _bg.clone();
		_bg.stamp(_bgClone, 0, 0);
		
		_bgUndo = new FlxSprite(0, 0);
		_bgUndo = _bg.clone();
		
		_bgRedo = new FlxSprite(0, 0);
		_bgRedo = _bg.clone();
		
		_player = new Player(100, 100);
		
		
		_reference = new FlxSprite(70, 0);
		_reference.loadGraphic("assets/images/552086.jpg", false, 1829, 2870);
		_reference.setGraphicSize(0, Std.int(_bg.height));
		_reference.updateHitbox();
		_reference.alpha = 0.5;
		
		
		add(_frame);
		add(_bg);
		//add(_reference);
		add(_player);
		
		FlxScreenGrab.defineCaptureRegion(0, 0, Std.int(_bg.width), Std.int(_bg.height));
		_screenGrab = new FlxButton(20, 20, "Screenshot", 
		function()
		{
			/*
			var bmp:BitmapData = new BitmapData(_bg.width, _bg.height, true, 0x0);
			bmp.draw(_bg.pixels);
			var b:ByteArray = bmp.encode(
			*/
			var png:ByteArray;
			png = PNGEncoder.encode(_bg.pixels);
			
			var file:FileReference = new FileReference();
			file.save(png, "LOL");
			//Backup
			//FlxScreenGrab.grab(null, true, true);
		});
		
		add(_screenGrab);
		
		FlxG.camera.follow(_player);
		FlxG.camera.followLead.x = FlxG.camera.followLead.y = 25;
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
		
		/*
		if (velX < 0)
		{
			velX * -1;
			FlxG.watch.addQuick("VELX", velX);
		}
		if (velY < 0)
		{
			velY * -1;
			FlxG.watch.addQuick("VELY", velY);
		}
		*/
		
		_player.scale.x = _player.scale.y = (FlxMath.remapToRange(velY, 0, 160, 0, _maxBrushSize) + FlxMath.remapToRange(velX, 0, 160, 0, _maxBrushSize));
		//_player.setGraphicSize(Std.int(FlxMath.remapToRange(velY, 0, 160, 0, 6) + FlxMath.remapToRange(velX, 0, 160, 0, 6)));
		FlxG.watch.addQuick("Scale", _player.scale.x);
		
		controls();
		
		
		undo();
		
		super.update(elapsed);
	}
	
	private function controls():Void
	{
		
		if (FlxG.keys.pressed.SPACE || FlxG.mouse.pressed)
		{
			if (_timer <= 0)
			{
				_bg.stamp(_player, Std.int(_player.x), Std.int(_player.y));
			}
			else
			{
				_timer -= FlxG.elapsed;
			}
			
		}
		else
		{
			_timer = 0.05;
		}
		
		//Zoom float for screenshots = 0.5
		
		if (FlxG.keys.anyJustPressed([DELETE, BACKSPACE]))
		{
			_bg.stamp(_bgClone, 0, 0);
		}
		
		if (FlxG.keys.anyPressed([UP, DOWN]))
		{
			var ZOOM_FACTOR:Int = 35;
			
			if (FlxG.keys.pressed.DOWN)
			{
				FlxG.camera.zoom -= 1 / ZOOM_FACTOR;
			}
			if (FlxG.camera.zoom < 0.24)
			{
				FlxG.camera.zoom = 0.24;
			}
			if (FlxG.keys.pressed.UP)
			{
				FlxG.camera.zoom += 1 / ZOOM_FACTOR;
			}
		}
		
		if (FlxG.keys.justPressed.RIGHT)
		{
			_maxBrushSize *= 1.1;
		}
		if (FlxG.keys.justPressed.LEFT)
		{
			_maxBrushSize /= 1.1;
		}
		
		FlxG.watch.addQuick("Cam Scale", FlxG.camera.zoom);
		
	}
	
	private function undo():Void
	{
		if (FlxG.keys.pressed.Z)
		{
			_bg.stamp(_bgUndo);
		}
		
		if (FlxG.keys.pressed.X)
		{
			_bg.stamp(_bgRedo);
		}
		
		if (FlxG.keys.justPressed.SPACE)
		{
			_bgUndo.stamp(_bg);
		}
		
		if (FlxG.keys.justReleased.SPACE)
		{
			_bgRedo.stamp(_bg);
		}
		
	}
}