package benchmark.iterate
{
    import com.kemsky.impl.Stream;

    import flash.utils.getTimer;

    public class TestIterate
    {
        private static const count:int = 10;
        private static const attempts:Number = 10;


        public function TestIterate()
        {
        }


        [Test]
        public function testWriteStream():void
        {
            var total:Number = 0;
            for (var i:int = 0; i < attempts; i++)
            {
                total += writeStream();
            }

            //Print Write Stream: 3283.8 ms
            Print.print("Write Stream Mean: {0} ms", total/attempts);
        }

        private function writeStream():Number
        {
            var s:Stream = new Stream();
            var i:int;

            var start:Number = getTimer();
            for (i = 0; i < count; i++)
            {
                s[i] = i;
            }
            var result:Number = getTimer() - start;
            //Print.print("Write Stream: {0} ms", result);
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

            //Print Write Stream: 3283.8 ms
            Print.print("Read Stream Mean: {0} ms", total/attempts);
        }

        private function readStream():Number
        {
            var s:Stream = new Stream();
            s.length = count;
            var i:int;

            var item:Object;
            var start:Number = getTimer();
            for (i = 0; i < count; i++)
            {
                item = s[i];
            }
            var result:Number = getTimer() - start;
            //Print.print("Read Stream: {0} ms", result);
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

            //Print Write Stream: 138.7 ms
            Print.print("Write Array Mean: {0} ms", total/attempts);
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

            //Print Write Stream: 138.7 ms
            Print.print("Read Array Mean: {0} ms", total/attempts);
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
    }
}
