package com.kemsky
{
    import com.kemsky.impl.Stream;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class TestArrayApi
    {
        public function TestArrayApi()
        {
        }

        [Test]
        public function testEach():void
        {
            var s:Stream = $(1, 2, 3, 3);
            var counter:int = 0;
            s.forEach(function (item:Number):void
            {
                counter++;
            });

            assertEquals(counter, 4);
        }

        [Test]
        public function testSome():void
        {
            var s:Stream = $(1, 2, 3, 3);
            assertTrue(s.some(function (item:Number):Boolean
            {
                return item > 2;
            }));
        }


        [Test]
        public function testEvery():void
        {
            var s:Stream = $(1, 2, 3, 3);
            assertTrue(s.every(function (item:Number):Boolean
            {
                return item > 0;
            }));
        }

        [Test]
        public function testLastIndex():void
        {
            var s:Stream = $(1, 2, 3, 3);
            assertEquals(s.lastIndexOf(3), s.length - 1);
        }

        [Test]
        public function testShift():void
        {
            var s:Stream = $(1, 2, 3);
            var l:Number = s.shift();

            assertEquals(s.length, 2);
            assertEquals(l, 1);
            assertEquals(s.first, 2);
        }


        [Test]
        public function testUnShift():void
        {
            var s:Stream = $(2, 3);
            var l:uint = s.unshift(1);

            assertEquals(s.length, 3);
            assertEquals(l, 3);
            assertEquals(s.first, 1);
        }

        [Test]
        public function testSplice():void
        {
            var s:Stream = $(1, 2, 3);

            s.splice(0, 1);
            assertEquals(s.length, 2);
            assertEquals(s.first, 2);

            s.splice(0, 0, 1);
            assertEquals(s.length, 3);
            assertEquals(s.first, 1);
        }

        [Test]
        public function testSort():void
        {
            var s:Stream = $(1, 2);

            var s1:Stream = s.sort(Stream.NUMERIC | Stream.UNIQUESORT | Stream.DESCENDING);
            assertEquals(s, s1);
            assertEquals(s1[0], 2);
            assertEquals(s1[1], 1);

            var s2:Stream = s.sort(Stream.NUMERIC | Stream.UNIQUESORT | Stream.DESCENDING | Stream.RETURNINDEXEDARRAY);
            assertFalse(s === s2);
            assertEquals(s2[0], 0);
            assertEquals(s2[1], 1);

            var s3:Stream = $(1, 2, 1);
            try
            {
                s3.sort(Stream.NUMERIC | Stream.UNIQUESORT);
                assertFalse(true);
            }
            catch (e:Error)
            {
            }

            var s4:Stream = $("alex", "Alex", "Bob");

            var ins:Stream = s4.sort();
            assertEquals(ins.first, "Alex");
            assertEquals(ins.last, "alex");

            var sens:Stream = s4.sort(Stream.CASEINSENSITIVE);
            assertEquals(sens.first.toLowerCase(), "alex");
            assertEquals(sens.last, "Bob");
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
