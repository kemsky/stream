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
        public function testReverse():void
        {
            var s:Array = [1, 2, 3];
            var r:Stream = $(s).reverse();

            for (var i:int = 0; i < r.length; i++)
            {
                assertEquals(r[i], s[s.length - i - 1]);
            }
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
        public function testJoin():void
        {
            var s:Stream = $(1, 2, 3);
            var str:String = s.join(",");
            assertEquals(str, "1,2,3");
        }

        [Test]
        public function testPop():void
        {
            var s:Stream = $(1, 2, 3, 4, 5);
            var length:int = s.length;
            var item:* = s[length - 1];
            var popped:* = s.pop();
            assertEquals(s.length, length - 1);
            assertEquals(popped, item);
        }

        [Test]
        public function testPush():void
        {
            var s:Stream = $(1, 2, 3, 4, 5);
            var length:int = s.length;
            var item:int = 6;
            s.push(item);
            assertEquals(s.length, length + 1);
            assertEquals(s[length], item);
        }

        [Test]
        public function testDelete():void
        {
            var s:Stream = $(1, 2, 3, 4, 5);
            var length:int = s.length;
            if (length == 0)
            {
                try
                {
                    delete s[0];
                    assertFalse(true);
                }
                catch (e:Error)
                {
                }
            }
            else
            {
                delete s[0];
                assertEquals(s.length, length - 1);
            }
        }

        [Test]
        public function testIterate():void
        {
            var s:Stream = $(1, 2, 3, 4, 5);
            for (var i:int = 0; i < s.length; i++)
            {
                assertEquals(s[i], i + 1);
            }
            var index:int = 1;
            for each (var item:* in s)
            {
                assertEquals(index, item);
                index++;
            }
            assertEquals(s.length, index - 1);
        }
    }
}
