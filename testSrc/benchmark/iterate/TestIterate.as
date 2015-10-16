package benchmark.iterate
{
    import com.kemsky.List;
    import com.kemsky.support.isNaNFast;

    import flash.utils.getTimer;

    public class TestIterate
    {
        private static const count:int = 10;
        private static const attempts:Number = 10;


        public function TestIterate()
        {
        }


        [Test]
        public function testGlobalFunctions():void
        {
            const n:uint = 1000;
            var i:int;
            var number:Number = NaN;
            var start:Number = 0;
            var result:Boolean;

            start = getTimer();
            for(i = 0; i < n; i++)
            {
                result = isNaNFast(number) && isNaNFastInternal(number) && isNaN(number);
            }
            Print.message("Warm up: {0} ms", getTimer() - start);

            start = getTimer();
            for(i = 0; i < n; i++)
            {
                result = isNaNFast(number);
            }
            Print.message("Global: {0} ms", getTimer() - start);

            start = getTimer();
            for(i = 0; i < n; i++)
            {
                result = isNaNFastInternal(number);
            }
            Print.message("Method: {0} ms", getTimer() - start);

            start = getTimer();
            for(i = 0; i < n; i++)
            {
                result = !(number <= 0) && !(number > 0);
            }
            Print.message("Inline: {0} ms", getTimer() - start);

            start = getTimer();
            for(i = 0; i < n; i++)
            {
                result = isNaN(number);
            }
            Print.message("isNaN: {0} ms", getTimer() - start);

            //10/16/2015 12:02:27.728 [INFO] Print Warm up: 1567 ms
            //10/16/2015 12:02:32.558 [INFO] Print Global: 4829 ms
            //10/16/2015 12:02:37.126 [INFO] Print Method: 4567 ms
            //10/16/2015 12:02:38.153 [INFO] Print Inline: 1026 ms
            //10/16/2015 12:02:39.837 [INFO] Print isNaN: 1683 ms
        }

        [Test]
        public function testWriteStream():void
        {
            var total:Number = 0;
            for (var i:int = 0; i < attempts; i++)
            {
                total += writeStream();
            }

            //Print Write List: 3283.8 ms
            Print.message("Write List Mean: {0} ms", total/attempts);
        }

        private function writeStream():Number
        {
            var s:List = new List();
            var i:int;

            var start:Number = getTimer();
            for (i = 0; i < count; i++)
            {
                s[i] = i;
            }
            var result:Number = getTimer() - start;
            //Print.print("Write List: {0} ms", result);
            return result;
        }


        [Test]
        public function testReadStream():void
        {
            var total:Number = 0;
            for (var i:int = 0; i < attempts; i++)
            {
                total += readStream();
            }

            //Print Write List: 3283.8 ms
            Print.message("Read List Mean: {0} ms", total/attempts);
        }

        private function readStream():Number
        {
            var s:List = new List();
            s.length = count;
            var i:int;

            var item:Object;
            var start:Number = getTimer();
            for (i = 0; i < count; i++)
            {
                item = s[i];
            }
            var result:Number = getTimer() - start;
            //Print.print("Read List: {0} ms", result);
            return result;
        }


        [Test]
        public function testWriteArray():void
        {
            var total:Number = 0;
            for (var i:int = 0; i < attempts; i++)
            {
                total += writeArray();
            }

            //Print Write List: 138.7 ms
            Print.message("Write Array Mean: {0} ms", total/attempts);
        }

        private function writeArray():Number
        {
            var s:Array = [];
            var i:int;

            var start:Number = getTimer();
            for (i = 0; i < count; i++)
            {
                s[i] = i;
            }
            var result:Number = getTimer() - start;
            //Print.print("Write Array: {0} ms", result);
            return result;
        }

        [Test]
        public function testReadArray():void
        {
            var total:Number = 0;
            for (var i:int = 0; i < attempts; i++)
            {
                total += readArray();
            }

            //Print Write List: 138.7 ms
            Print.message("Read Array Mean: {0} ms", total/attempts);
        }

        private function readArray():Number
        {
            var s:Array = [];
            s.length = count;
            var i:int;

            var item:Object;
            var start:Number = getTimer();
            for (i = 0; i < count; i++)
            {
                item = s[i];
            }
            var result:Number = getTimer() - start;
            //Print.print("Read Array: {0} ms", result);
            return result;
        }

        private function isNaNFastInternal(target:*):Boolean
        {
            return !(target <= 0) && !(target > 0);
        }
    }
}
