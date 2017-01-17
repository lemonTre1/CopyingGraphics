package
{
	
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	[SWF( backgroundColor="0xFFFFFF",width="1024",height="768")]
	public class CopyingGraphics extends Sprite
	{
		
		private static const INIT_SEGMENTS:uint=10;
		private static const MAX_SEGMENTS:uint=20;
		private static const MIN_SEGMENTS:uint=3;
		private static const THICKNESS:uint=1;
		private static const COLOR:uint=0x66CCCC;
		private static const ROTATION_RATE:uint=1;
		
		
		private var _shapeHolder:Sprite;
		private var _shapes:Vector.<Shape>;
		
		public function CopyingGraphics()
		{
			
			init();
		}
		
		
		private function init():void{
			
			
			_shapeHolder=new Sprite();
			_shapeHolder.x=stage.stageWidth/2;
			_shapeHolder.y=stage.stageHeight/2;
			this.addChild(_shapeHolder);
			_shapes=new Vector.<Shape>();
			
			for(var i:uint=0;i<INIT_SEGMENTS;i++)
				addSegment();
			
			
			positionSegments();
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onStageKeyDown);
			filters=[new GlowFilter(COLOR)];
		}
		
		
		private function draw():void{
			
			var shape:Shape=_shapes[0];
			shape.graphics.lineTo(shape.mouseX,shape.mouseY);
			var segments:uint=_shapeHolder.numChildren;
			for(var i:uint=1;i<segments;i++)
				_shapes[i].graphics.copyFrom(shape.graphics);
		}
		
		private function addSegment():void{
			
			var shape:Shape=new Shape();
			if(_shapes.length>0)
				shape.graphics.copyFrom(_shapes[0].graphics);
			else
				shape.graphics.lineStyle(THICKNESS,COLOR);
			
			_shapes.push(shape);
			_shapeHolder.addChild(shape);
			
		}
		
		private function removeSegment():void{
			
			var shape:Shape=_shapes.pop();
			_shapeHolder.removeChild(shape);
		}
		
		private function positionSegments():void{
			
			var segments:uint=_shapeHolder.numChildren;
			var angle:Number=360/segments;
			for(var i:uint=1;i<segments;i++)
				_shapes[i].rotation=angle*i;
		}
		
		private function onStageMouseDown(e:MouseEvent):void{
			
			var shape:Shape=_shapes[0];
			shape.graphics.moveTo(shape.mouseX,shape.mouseY);
			stage.addEventListener(Event.ENTER_FRAME,onThisEnterFrame);
		}
		
		private function onStageMouseUp(e:MouseEvent):void{
			stage.removeEventListener(Event.ENTER_FRAME,onThisEnterFrame);
		}
		
		private function onThisEnterFrame(e:Event):void{
			
			_shapeHolder.rotation+=ROTATION_RATE;
			draw();
		}
		
		private function onStageKeyDown(e:KeyboardEvent):void{
			
			switch(e.keyCode){
				case Keyboard.UP:
					if(_shapeHolder.numChildren<MAX_SEGMENTS){
						
						addSegment();
						positionSegments();
					}
					break;
				case Keyboard.DOWN:
					if(_shapeHolder.numChildren<MIN_SEGMENTS){
						
						addSegment();
						positionSegments();
					}
					break;	
			}
		}
		
	}
}