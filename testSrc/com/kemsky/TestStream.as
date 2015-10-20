package com.kemsky
{
    import com.kemsky.filters._;
    import com.kemsky.filters.eq;
    import com.kemsky.filters.gt;
    import com.kemsky.filters.prop;
    import com.kemsky.support.EntryIterator;
    import com.kemsky.support.ValueIterator;
    import com.kemsky.support.stream_internal;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import mx.collections.ArrayCollection;
    import mx.collections.ArrayList;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class TestStream
    {
        public function TestStream()
        {
        }


        [Test]
        public function testValues():void
        {
            var s:Stream = $(1, 2, 3);
            var i:StreamIterator = new ValueIterator(s);

            var count:int = 1;
            while (i.available)
            {
                var n:Number = i.next();
                assertEquals(n, count);
                assertEquals(n, i.current);
                i.remove();
                count++;
            }

            assertEquals(s.length, 0);

            var s1:Stream = $(1, 2, 3);
            var i1:StreamIterator = new ValueIterator(s1);
            count = 0;
            for each (var item:* in i1)
            {
//                Print.items("for each: ", i1.current, item);
                if (++count < 10)
                {
                    i1.push(count);
                }
            }

            var i2:StreamIterator = new EntryIterator(s1);

            for each (var entry:Entry in i2)
            {
                //Print.items("for each entry: ", entry.index, entry.value);
            }
//            for (var p:* in i1)
//            {
//                Print.items("for: ", p);
//            }
        }

        [Test]
        public function testCompact():void
        {
            var s:Stream = $();
            s[0] = 1;
            s[10] = 2;

            var c:Stream = s.compact();
            assertEquals(c.length, 2);
            assertEquals(c.first, 1);
            assertEquals(c.second, 2);
        }

        [Test]
        public function testPartition():void
        {
            var s:Stream = $(1, 2, 3, 4, 5, 6);
            var groups:Stream = s.partition(function (item:Number):Boolean
            {
                return item <= 3;
            });

            assertEquals(groups.length, 2);

            var g1:Stream = groups[0];
            assertEquals(g1.length, 3);
            assertEquals(g1.third, 3);

            var g2:Stream = groups[1];
            assertEquals(g2.length, 3);
            assertEquals(g2.third, 6);
        }


        [Test]
        public function testFill():void
        {
            var s:Stream = $();
            s.fill(1);
            assertEquals(s.length, 0);

            s.fill(1, 1);
            assertEquals(s.length, 1);
            assertEquals(s.first, 1);
        }

        [Test]
        public function testZip():void
        {
            var s:Stream = $("1", "2");
            var e:Stream = s.zip();
            assertEquals(e.length, s.length);
            assertTrue(e.first is Stream);
            assertTrue(e.second is Stream);
            assertEquals(e.first.length, 2);
            assertEquals(e.first.first, 0);
            assertEquals(e.first.second, "1");
            assertEquals(e.second.first, 1);
            assertEquals(e.second.second, "2");
        }

        [Test]
        public function testFindIndex():void
        {
            var s:Stream = $(1, 2, 4, 3);
            assertEquals(s.findIndex(gt(_, 2)), 2);
            assertEquals(s.findIndex(gt(_, 2), true), 3);

            assertEquals(s.findIndex(gt(_, 4)), -1);
            assertEquals(s.findIndex(gt(_, 4), true), -1);
        }

        [Test]
        public function testFind():void
        {
            var s:Stream = $(1, 2, 4, 3);

            assertEquals(s.find(gt(_, 2)), 4);
            assertEquals(s.find(gt(_, 2), true), 3);

            assertTrue(s.find(gt(_, 4)) === undefined);
            assertTrue(s.find(gt(_, 4), true) === undefined);
        }

        [Test]
        public function testDrop():void
        {
            var s:Stream = $(1, 2, 3).drop(2);
            assertEquals(s.length, 1);
            assertEquals(s.first, 1);

            var s2:Stream = $().drop(2);
            assertEquals(s2.length, 0);
        }

        [Test]
        public function testMap():void
        {
            var item:Item = new Item("name1", 5, 0);
            var s:Stream = $(item);
            assertEquals(s.map(prop(_, "name")).first, "name1");
        }

        [Test]
        public function testSet():void
        {
            var s:Stream = $(1, 2, 3);
            s.setItem(2, 1);
            s.setItem(0, 3);
            assertEquals(s[0], 3);
            assertEquals(s[1], 2);
            assertEquals(s[2], 1);
        }

        [Test]
        public function testGet():void
        {
            var s:Stream = $(1, 2, 3);
            assertEquals(s.getItem(0), 1);
            assertEquals(s.getItem(1), 2);
            assertEquals(s.getItem(2), 3);

            assertTrue(s.getItem(3) === undefined);
        }

        [Test]
        public function testGroup():void
        {
            var s:Stream = $(1, 2, 3, 4, 5, 6);
            var groups:Dictionary = s.group(function (item:Number):Number
            {
                return item > 3 ? 2 : 1;
            });

            var g1:Stream = groups[1];
            assertEquals(g1.length, 3);
            assertEquals(g1.third, 3);

            var g2:Stream = groups[2];
            assertEquals(g2.length, 3);
            assertEquals(g2.third, 6);
        }

        [Test]
        public function testCount():void
        {
            var s:Stream = $(1, 2, 3);
            var count:Number = s.count(function (item:Number):Boolean
            {
                return item > 2;
            });

            assertEquals(count, 1);

            assertEquals(s.count(eq(_, 2)), 1);
        }

        [Test]
        public function testContains():void
        {
            assertTrue($(1, 2, 3).contains(2));
            assertFalse($(1, 2, 3).contains(4));
        }


        [Test]
        public function testUnique():void
        {
            assertTrue($(1, 2, 3).unique);
            assertFalse($(1, 1, 1).unique);
        }

        [Test]
        public function testClear():void
        {
            var s:Stream = $(1, 2, 3);

            s.clear();

            assertEquals(s.length, 0);
        }

        [Test]
        public function testClonePrimitiveList():void
        {
            var primitive:Stream = $(1, 2, 3);

            var primitiveClone:Stream = primitive.clone();
            assertEquals(primitiveClone.length, 3);
            assertEquals(primitiveClone[0], 1);
            assertEquals(primitiveClone[1], 2);
            assertEquals(primitiveClone[2], 3);
            assertFalse(primitiveClone === primitive);

            var primitiveCloneDeep:Stream = primitive.clone(true);
            assertEquals(primitiveCloneDeep.length, 3);
            assertEquals(primitiveCloneDeep[0], 1);
            assertEquals(primitiveCloneDeep[1], 2);
            assertEquals(primitiveCloneDeep[2], 3);
            assertFalse(primitiveCloneDeep === primitive);
        }

        [Test]
        public function testCloneObjectList():void
        {
            var item1:Item = new Item("name1", 1, 2);
            var item2:Item = new Item("name2", 2, 0);

            var object:Stream = $(item1, item2);

            var objectClone:Stream = object.clone();
            assertEquals(objectClone.length, 2);

            assertTrue(Item(objectClone[0]) === item1);
            assertEquals(Item(objectClone[0]).name, item1.name);
            assertEquals(Item(objectClone[0]).price, item1.price);
            assertEquals(Item(objectClone[0]).vat, item1.vat);

            assertTrue(Item(objectClone[0]) === item1);
            assertEquals(Item(objectClone[1]).name, item2.name);
            assertEquals(Item(objectClone[1]).price, item2.price);
            assertEquals(Item(objectClone[1]).vat, item2.vat);

            assertFalse(objectClone === object);
            assertFalse(objectClone.stream_internal::source === object.stream_internal::source);

            var objectCloneDeep:Stream = object.clone(true);
            assertEquals(objectCloneDeep.length, 2);

            assertFalse(Item(objectCloneDeep[0]) === item1);
            assertEquals(Item(objectCloneDeep[0]).name, item1.name);
            assertEquals(Item(objectCloneDeep[0]).price, item1.price);
            assertEquals(Item(objectCloneDeep[0]).vat, item1.vat);

            assertFalse(Item(objectCloneDeep[0]) === item1);
            assertEquals(Item(objectCloneDeep[1]).name, item2.name);
            assertEquals(Item(objectCloneDeep[1]).price, item2.price);
            assertEquals(Item(objectCloneDeep[1]).vat, item2.vat);

            assertFalse(objectCloneDeep === object);
            assertFalse(objectCloneDeep.stream_internal::source === object.stream_internal::source);
        }

        [Test]
        public function testDict():void
        {
            var item1:Item = new Item("1", 1, 2);
            var item2:Item = new Item("2", 2, 0);

            var s:Stream = $(item1, item2);

            var d:Dictionary = s.dictionary("name");
            assertEquals(d["1"], item1);
            assertEquals(d["2"], item2);
        }

        [Test]
        public function testObject():void
        {
            var item1:Item = new Item("1", 1, 2);
            var item2:Item = new Item("2", 2, 0);

            var s:Stream = $(item1, item2);

            var d:Object = s.object("name");
            assertEquals(d["1"], item1);
            assertEquals(d["2"], item2);
        }


        [Test]
        public function testCurry():void
        {
            function many(a:Number, b:Number, c:Number):Number
            {
                return a + b + c;
            }

            var a:Function = curry(many, 1);
            assertEquals(a(1, 1), 3);

            var b:Function = curry(a, 1);
            assertEquals(b(1), 3);

            var c:Function = curry(b, 1);
            assertEquals(c(), 3);

            assertEquals(curry(many)(1, 1)(1), 3);
        }

        [Test]
        public function testFilter():void
        {
            var s:Stream = $("1", "2", "1").filter(function (item:String):Boolean
            {
                return item == "2";
            });
            assertEquals(s.first, "2");
            assertEquals(s.length, 1);
        }


        [Test]
        public function testSkip():void
        {
            var s:Stream = $(1, 2);
            assertEquals(s.skip(1).first, 2);
            assertEquals(s.skip(1).length, 1);
        }

        [Test]
        public function testTake():void
        {
            var s:Stream = $(1, 2);

            assertEquals(s.take(1, 1).first, 2);
            assertEquals(s.take(1, 1).length, 1);

            assertEquals(s.take(1).first, 1);
            assertEquals(s.take(1).length, 1);
        }

        [Test]
        public function testLastFirst():void
        {
            var s:Stream = $();

            s.first = 0;
            s.second = 1;
            s.third = 2;
            s.fourth = 3;
            s.fifth = 4;
            s.sixth = 5;
            s.seventh = 6;
            s.eighth = 7;
            s.ninth = 8;
            s.tenth = 9;
            s.eleventh = 10;
            s.twelfth = 11;
            s.thirteenth = 12;
            s.fourteenth = 13;
            s.fifteenth = 14;


            assertEquals(s.first, 0);
            assertEquals(s.second, 1);
            assertEquals(s.third, 2);
            assertEquals(s.fourth, 3);
            assertEquals(s.fifth, 4);
            assertEquals(s.sixth, 5);
            assertEquals(s.seventh, 6);
            assertEquals(s.eighth, 7);
            assertEquals(s.ninth, 8);
            assertEquals(s.tenth, 9);
            assertEquals(s.eleventh, 10);
            assertEquals(s.twelfth, 11);
            assertEquals(s.thirteenth, 12);
            assertEquals(s.fourteenth, 13);
            assertEquals(s.fifteenth, 14);


            assertEquals(s.last, 14);

            s.first = 14;
            s.last = 0;

            assertEquals(s.first, 14);
            assertEquals(s.last, 0);

            assertEquals(s.length, 15)
        }


        [Test]
        public function testFoldLeft():void
        {
            var sum1:Number = $(0, 1, 2, 3, 4).foldLeft(function (prev:Number, current:Number):Number
            {
                return prev + current;
            }, 0);

            assertEquals(sum1, 10);

            var sum2:Number = $(0, 1, 2, 3, 4).foldLeft(function (prev:Number, current:Number):Number
            {
                return prev + current;
            }, 10);

            assertEquals(sum2, 20);

            var sum3:Number = $(0, 1, 2, 3, 4).foldLeft(function (prev:Number, current:Number):Number
            {
                return prev + current;
            });

            assertEquals(sum3, 10);
        }

        [Test]
        public function testFoldRight():void
        {
            var sum1:Number = $(0, 1, 2, 3, 4).foldRight(function (prev:Number, current:Number):Number
            {
                return prev + current;
            }, 0);

            assertEquals(sum1, 10);

            var sum2:Number = $(0, 1, 2, 3, 4).foldRight(function (prev:Number, current:Number):Number
            {
                return prev + current;
            }, 10);

            assertEquals(sum2, 20);

            var sum3:Number = $(0, 1, 2, 3, 4).foldRight(function (prev:Number, current:Number):Number
            {
                return prev + current;
            });

            assertEquals(sum3, 10);
        }

        [Test]
        public function testFlatMap():void
        {
            var s:Stream = new Stream([[1, 2, 3], $(4, 5, 6)]);

            s.push(new ArrayCollection([7, 8, 9]), new <Number>[10, 11, 12]);

            assertEquals(s.length, 4);

            var flatDefault:Stream = s.flatten();
            assertEquals(flatDefault.length, 12);
            for (var i:int = 0; i < flatDefault.length; i++)
            {
                assertEquals(flatDefault[i], i + 1);
            }

            var flatMap:Stream = s.flatMap(function (item:*):Array
            {
                return [item.length];
            });
            for (var k:int = 0; k < flatMap.length; k++)
            {
                assertEquals(flatMap[k], 3);
            }

            flatMap = s.flatMap(function (item:*):*
            {
                return item.length;
            });
            for (var m:int = 0; m < flatMap.length; m++)
            {
                assertEquals(flatMap[m], 3);
            }
        }

        [Test]
        public function testE4X():void
        {
            var firstName:Object = {name: "first", value: 0};
            var secondName:Object = {name: "second", value: 4};
            var thirdName:Object = {name: "third", value: 8};

            var first:Object = {item: firstName};
            var second:Object = {item: secondName};
            var third:Object = {item: thirdName};

            var s:Stream = $([first, second, third]);
            var items:Stream = s..item;
            assertEquals(items.length, 3);
            assertEquals(items[0], firstName);
            assertEquals(items[1], secondName);
            assertEquals(items[2], thirdName);

            var names:Stream = items..name;
            assertEquals(names.length, 3);
            assertEquals(names[0], "first");
            assertEquals(names[1], "second");
            assertEquals(names[2], "third");
        }


        [Test]
        public function testHasOwnProperty():void
        {
            var array:Stream = $([1, 2, 3]);

            for (var p:String in array)
            {
                assertTrue(array.hasOwnProperty(p));
            }

            assertTrue(array.hasOwnProperty("-1"));
            assertTrue(array.hasOwnProperty("-2"));
            assertTrue(array.hasOwnProperty("-3"));
            assertFalse(array.hasOwnProperty("-4"));

            assertFalse(array.hasOwnProperty("4"));
            assertFalse(array.hasOwnProperty("random"));
        }

        [Test]
        public function testToString():void
        {
            var empty:Stream = $();
            assertEquals(empty.toString(), "Stream{}");

            var s:Stream = $(1);
            assertEquals(s.toString(), "Stream{1}");
        }


        [Test]
        public function testArray():void
        {
            var original:Array = [1, 2, 3];

            var array:Stream = $([1, 2, 3]);

            verify(array.array(), original);

            assertTrue(array.array() is Array);
        }

        [Test]
        public function testCollection():void
        {
            var original:Array = [1, 2, 3];

            var array:Stream = $([1, 2, 3]);

            verify(array.collection(), original);

            assertTrue(array.collection() is ArrayCollection);
        }

        [Test]
        public function testList():void
        {
            var original:Array = [1, 2, 3];

            var array:Stream = $([1, 2, 3]);

            verify(array.list(), original);

            assertTrue(array.list() is ArrayList);
        }

        [Test]
        public function testCreateStream():void
        {
            var empty:Stream = $();
            assertEquals(empty.empty, true);
            assertEquals(empty.length, 0);

            var original:Array = [1, 2, 3];

            var array:Stream = $([1, 2, 3]);
            assertEquals(array.empty, false);
            assertEquals(array.length, 3);
            assertEquals(array.first, 1);
            assertEquals(array[0], 1);
            assertEquals(array[1], 2);
            assertEquals(array[2], 3);
            assertEquals(array.last, 3);
            verify(array, original);

            var collection:Stream = $(new ArrayCollection([1, 2, 3]));
            assertEquals(collection.empty, false);
            assertEquals(collection.length, 3);
            assertEquals(collection.first, 1);
            assertEquals(collection[0], 1);
            assertEquals(collection[1], 2);
            assertEquals(collection[2], 3);
            assertEquals(collection.last, 3);
            verify(collection, original);

            var args:Stream = $(1, 2, 3);
            assertEquals(args.empty, false);
            assertEquals(args.length, 3);
            assertEquals(args.first, 1);
            assertEquals(args[0], 1);
            assertEquals(args[1], 2);
            assertEquals(args[2], 3);
            assertEquals(args.last, 3);
            verify(args, original);

            var single:Stream = $("item");
            assertEquals(single.empty, false);
            assertEquals(single.length, 1);
            assertEquals(single[0], "item");
            assertEquals(single.first, "item");
            assertEquals(single.last, "item");
            assertEquals(single.first, single.last);

            var vector:Vector.<Number> = new <Number>[1, 2, 3];
            var v:Stream = $(vector);
            assertEquals(v.length, 3);
            assertEquals(v[0], 1);
            assertEquals(v[1], 2);
            assertEquals(v[2], 3);
            verify(v, vector);
        }

        [Test]
        public function testSerialize():void
        {
            var s:Stream = $(1, 2, 3);
            var b:ByteArray = new ByteArray();
            b.writeObject(s);
            b.position = 0;
            var r:Stream = b.readObject();

            for (var i:int = 0; i < s.length; i++)
            {
                assertEquals(s[i], r[i]);
            }
        }

        private static function verify(s:*, o:*):void
        {
            var index:int = 0;
            for each (var item:* in s)
            {
                assertEquals(item, o[index]);
                index++;
            }
        }
    }
}
