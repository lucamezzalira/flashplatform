package  {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class ColorComparision {

		private const NUM_AVERAGE_COLORS:int = 64;	
		private const DISTANCE:int = 10;
		
		private var weightHue:Number = 0.8;
		private var weightSaturation:Number = 0.1;
		private var weightValue:Number = 0.1;
		
		private var arrBmp1:Array;
		private var arrBmp2:Array;

		private var l1:Number;
		private var defTollerance:int;
		
		public function ColorComparision() {
			defTollerance = DISTANCE
		}
		
		public function getSimilars(_colorSource:BitmapData, _colorToCompare:BitmapData):Array{
			
			var finalDiffArr:Array = new Array();			
			var hsv1:Array;
			var hsv2:Array;
			var currDist:Number;
			
			arrBmp1 = averageColours(_colorSource, NUM_AVERAGE_COLORS);	
			arrBmp2 = averageColours(_colorToCompare, NUM_AVERAGE_COLORS);	
			
			for(var i:int = arrBmp1.length-1; i > 0; i--){

				l1 = 0;
				
				hsv1 = ColorMathUtil.RGBtoHSV(arrBmp1[i].r, arrBmp1[i].g, arrBmp1[i].b);

				var distH:Number = 0;
				var distS:Number = 0;
				var distV:Number = 0;
				
				for(var j:int = arrBmp2.length-1; j > 0; j--){
					
					hsv2 = ColorMathUtil.RGBtoHSV(arrBmp2[j].r, arrBmp2[j].g, arrBmp2[j].b);
					distH = hsv2[0] - hsv1[0]
					distS = hsv2[1] - hsv1[1]
					distV = hsv2[2] - hsv1[2]
					currDist = Math.sqrt(weightHue*distH*distH + weightSaturation*distS*distS + weightValue*distV*distV)

					
					if(currDist < defTollerance){
					
						finalDiffArr.push(arrBmp1[i]);
						
					}
				}
				
			}
			
			removeDuplicate(finalDiffArr);
			
			return finalDiffArr;
			
		}
		
		private function removeDuplicate(arr:Array) : void{
			var i:int;
			var j: int;
			for (i = 0; i < arr.length - 1; i++){
				for (j = i + 1; j < arr.length; j++){
					if (arr[i] === arr[j]){
						arr.splice(j, 1);
					}
				}
			}
		}
		
		private function averageColours( source:BitmapData, colours:int ):Array{
			
			var averages:Array = new Array();
			var columns:int = Math.round( Math.sqrt( colours ) );

			var row:int = 0;
			var col:int = 0;

			var x:int = 0;
			var y:int = 0;

			var w:int = Math.round( source.width / columns );
			var h:int = Math.round( source.height / columns );
			
			for (var i:int = 0; i < colours; i++)
			{
				var rect:Rectangle = new Rectangle( x, y, w, h );

				var box:BitmapData = new BitmapData( w, h, false );
				box.copyPixels( source, rect, new Point() );

				averages.push( averageColour( box ) );
				box.dispose();

				col = i % columns;

				x = w * col;
				y = h * row;

				if ( col == columns - 1 ) row++;
			}

			return averages;
		}

		private function averageColour( source:BitmapData ):Object
		{
			var red:Number = 0;
			var green:Number = 0;
			var blue:Number = 0;

			var count:Number = 0;
			var pixel:Number;

			for (var x:int = 0; x < source.width; x++)
			{
				for (var y:int = 0; y < source.height; y++)
				{
					pixel = source.getPixel(x, y);

					red += pixel >> 16 & 0xFF;
					green += pixel >> 8 & 0xFF;
					blue += pixel & 0xFF;

					count++
				}
			}

			red /= count;
			green /= count;
			blue /= count;

			return{r:red, g:green, b:blue};
			
			//return red << 16 | green << 8 | blue;
		}

		public function set tollerance(_value:int):void{

			defTollerance = _value;
			
		}

	}
	
}
