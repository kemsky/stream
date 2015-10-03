package
{
    import com.kemsky.$;
    import com.kemsky.impl.Stream;
    import com.kemsky.impl.filters.eq;

    import mx.collections.ArrayCollection;
    import mx.logging.ILogger;
    import mx.logging.Log;
    import mx.logging.targets.TraceTarget;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class TestArrayApi
    {
        private static const log:ILogger = Log.getLogger("TestStream");

        public function TestArrayApi()
        {
            Log.addTarget(new TraceTarget());
        }

        [Test]
        public function testFilter():void
        {
            var s:Stream = $("1", "2", "1").filter(eq("2"));
            assertEquals(s.first, "2");
            assertEquals(s.length, 1);
        }

        [Test]
        public function testSortOn():void
        {
            var s:Stream = new Stream();
            s.push(new Item("lettuce", 1.49));
            s.push(new Item("spinach", 1.89));
            s.push(new Item("asparagus", 3.99));
            s.push(new Item("celery", 1.29));
            s.push(new Item("squash", 1.44));

            s.sortOn("name");

            s.sortOn("price", Array.NUMERIC | Array.DESCENDING);

            var val:Number = s[0].price;
            for (var i:int = 0; i < s.length; i++)
            {
                assertTrue(val >= s[i].price);
                val = s[i].price;
            }
        }


        [Test]
        public function testCreate():void
        {
            var streamArguments:Stream = $(1, 2, 3, 4, 5);
            assertEquals(streamArguments.length, 5);
            iterate(streamArguments);
            deleteItem(streamArguments);
            push(streamArguments, 5);
            pop(streamArguments);
        }

        private function join(stream:Stream):void
        {
            log.info(stream.join(","));
        }

        private function pop(stream:Stream):void
        {
            var length:int = stream.length;
            var item:* = stream[length - 1];
            var popped:* = stream.pop();
            assertEquals(stream.length, length - 1);
            assertEquals(popped, item);
        }

        private function push(stream:Stream, item:*):void
        {
            var length:int = stream.length;
            stream.push(item);
            assertEquals(stream.length, length + 1);
            assertEquals(stream[length], item);
        }

        private function deleteItem(stream:Stream):void
        {
            var length:int = stream.length;
            if (length == 0)
            {
                try
                {
                    delete stream[0];
                    assertFalse(true);
                }
                catch (e:Error)
                {
                }
            }
            else
            {
                delete stream[0];
                assertEquals(stream.length, length - 1);
            }
        }

        private function iterate(stream:Stream):void
        {
            var count:int = stream.length;
            for each (var item:* in stream)
            {
                count--;
            }
            assertEquals(count, 0);
        }
    }
}
