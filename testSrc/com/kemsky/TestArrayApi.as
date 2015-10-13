package com.kemsky
{
    import mx.collections.ArrayCollection;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class TestArrayApi
    {
        public function TestArrayApi()
        {
        }


        [Test]
        public function testConcat():void
        {
            var s:Stream = $();
            var s2:Stream = s.concat(1, [2], new ArrayCollection([3]), new <Number>[4]);
            assertEquals(s2.length, 4);
            assertEquals(s2.first, 1);
            assertEquals(s2.second, 2);
            assertEquals(s2.third, 3);
            assertEquals(s2.fourth, 4);
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

            var r1:Stream = s.splice(0, 1);
            assertEquals(s.length, 2);
            assertEquals(s.first, 2);
            assertEquals(r1.length, 1);
            assertEquals(r1.first, 1);

            var r2:Stream = s.splice(0, 0, 1);
            assertEquals(s.length, 3);
            assertEquals(s.first, 1);
            assertEquals(r2.length, 0);
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


            var item1:Item = new Item("name", 2);
            var item2:Item = new Item("name", 1);
            var s2:Stream = $(item1, item2);
            try
            {
                s2.sortOn("name", Stream.UNIQUESORT);
                assertFalse(true);
            }
            catch(e:Error)
            {
            }

            var s3:Stream = $(item1, item2);
            var s4:Stream = s3.sortOn("price", Stream.NUMERIC | Stream.UNIQUESORT | Stream.DESCENDING | Stream.RETURNINDEXEDARRAY);
            assertFalse(s3 === s4);
            assertEquals(s4[0], 0);
            assertEquals(s4[1], 1);
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
            try
            {
                delete s[10];
                assertFalse(true);
            }
            catch (e:Error)
            {
            }

            delete s[0];
            assertEquals(s.length, length - 1);

            assertFalse(delete s["random"]);

            assertTrue(delete s[-1]);
            assertEquals(s.last, 5);
            assertEquals(s.length, length - 2);
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

            //negative index
            for(var k:int = -1; k > -s.length; k--)
            {
                assertEquals(s[k], (s.length + k + 1));
            }

            for(var m:int = -1; m > -s.length; m--)
            {
                s[m] = s.length + m + 1;
            }

            //invalid index write
            try
            {
                s["random"] = 1;
                assertFalse(true);
            }
            catch(e:Error)
            {
            }

            //invalid index read
            try
            {
                var l:* = s["random"];
                assertFalse(true);
            }
            catch(e:Error)
            {
            }

        }
    }
}
