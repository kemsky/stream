package com.kemsky
{
    import com.kemsky.filters._;
    import com.kemsky.filters.eq;
    import com.kemsky.filters.gt;
    import com.kemsky.filters.member;
    import com.kemsky.support.ValueIterator;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import mx.collections.ArrayCollection;
    import mx.collections.ArrayList;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class TestStream
    {
        private static const xml:XML = <order>
            <book ISBN="0942407296">
                <title>Baking Extravagant Pastries with Kumquats</title>
                <author>
                    <lastName>Contino</lastName>
                    <firstName>Chuck</firstName>
                </author>
                <pageCount>238</pageCount>
            </book>
            <book ISBN="0865436401">
                <title>Emu Care and Breeding</title>
                <editor>
                    <lastName>Case</lastName>
                    <firstName>Justin</firstName>
                </editor>
                <pageCount>115</pageCount>
            </book>
        </order>;

        public function TestStream()
        {
        }


        [Test]
        public function testMXML():void
        {
            var s:Stream = new Stream();
            s.initialized({}, "");
        }

        [Test]
        public function testConcat():void
        {
            var s:Stream = $().concat(xml.children());

            assertEquals(s.length, 2);
            assertEquals(s.first.pageCount, "238");
            assertEquals(s.second.pageCount, "115");
        }

        [Test]
        public function testFactory():void
        {
            var s:Stream = $(null);
            assertEquals(s.length, 0);

            var s1:Stream = $(null, undefined);
            assertEquals(s1.length, 2);
        }

        [Test]
        public function testVector():void
        {
            var s:Stream = $(1, 2, 3);
            var v:Vector.<Object> = s.vector();
            assertEquals(v.length, 3);
            assertEquals(v[0], 1);
            assertEquals(v[1], 2);
            assertEquals(v[2], 3);

            assertEquals($().vector().length, 0);
        }

        [Test]
        public function testFromValues():void
        {
            var obj:Object = {name1: "first", name2: "second"};

            var s:Stream = Stream.fromValues(obj).sort();
            assertEquals(s.length, 2);
            assertEquals(s.first, "first");
            assertEquals(s.second, "second");

            var s2:Stream = Stream.fromKeys(null);
            assertEquals(s2.length, 0);
        }

        [Test]
        public function testFromKeys():void
        {
            var obj:Object = {name1: "first", name2: "second"};

            var s:Stream = Stream.fromKeys(obj).sort();
            assertEquals(s.length, 2);
            assertEquals(s.first, "name1");
            assertEquals(s.second, "name2");

            var s2:Stream = Stream.fromKeys(null);
            assertEquals(s2.length, 0);
        }

        [Test]
        public function testDeduplicate():void
        {
            var s:Stream = $(1, 2, 2, 3, 1);

            var d1:Stream = s.deduplicate();
            assertEquals(d1.length, 3);
            assertEquals(d1.first, 1);
            assertEquals(d1.second, 2);
            assertEquals(d1.third, 3);

            var s1:Stream = $("test", "you", "now");
            var d2:Stream = s1.deduplicate(function(a:String, b:String):Boolean
            {
                return a.length == b.length;
            });
            assertEquals(d2.length, 2);
            assertEquals(d2.first, "test");
            assertEquals(d2.second, "you");
        }

        [Test]
        public function testValues():void
        {
            var s:Stream = $(1, 2, 3);
            var values:Iterator = s.iterator();

            var count:int = 1;
            for each (var item:Number in values)
            {
                assertEquals(item, count++);
            }

            values.reset();
            assertEquals(values.index, -1);
            assertEquals(values.hasNext, true);

            values.end();
            assertEquals(values.index, -1);
            assertEquals(values.hasNext, false);

            try
            {
                values.next();
                assertTrue(false);
            }
            catch (e:Error)
            {}

            try
            {
                values.item = 0;
                assertTrue(false);
            }
            catch (e:Error)
            {}

            try
            {
                values.remove();
                assertTrue(false);
            }
            catch (e:Error)
            {}

            values.reset();
            var position:int = 0;
            while (values.hasNext)
            {
                var n:Number = values.next();
                assertEquals(n, position + 1);
                assertEquals(n, values.item);
                assertEquals(position, values.index);
                position++;
            }

            values.reset();
            assertEquals(values.index, -1);
            assertEquals(values.hasNext, true);


            values.reset();
            var first:Number = values.next();
            values.item = 0;
            assertEquals(values.item, 0);
            assertEquals(s.first, 0);
            values.remove();
            assertEquals(s.first, 2);
            var second:Number = values.next();
            values.remove();
            var third:Number = values.next();
            values.remove();
            assertEquals(s.length, 0);
        }

        [Test]
        public function testMax():void
        {
            assertEquals($(2, 3, 1).max(), 3);
            assertEquals($(2, 3, 1).max(_), 3);
            assertEquals($().max(_, 1), 1);

            var item1:Item = new Item("item1", 1);
            var item2:Item = new Item("item2", 2);

            assertEquals($(item1, item2).max(member("price")), item2);
            assertEquals($().max(member("price"), 1), 1);

            try
            {
                $().max();
                assertTrue(false);
            }
            catch(e:Error)
            {
            }
        }

        [Test]
        public function testMin():void
        {
            assertEquals($(2, 3, 1).min(), 1);
            assertEquals($(2, 3, 1).min(_), 1);
            assertEquals($().min(_, 1), 1);

            var item1:Item = new Item("item1", 1);
            var item2:Item = new Item("item2", 2);

            assertEquals($(item1, item2).min(member("price")), item1);
            assertEquals($().min(member("price"), 1), 1);

            try
            {
                $().min();
                assertTrue(false);
            }
            catch(e:Error)
            {
            }
        }

        [Test]
        public function testCompact():void
        {
            var s:Stream = $();
            s[0] = 1;
            s[3] = 2;

            var c:Stream = s.compact(true);
            assertEquals(c.length, 2);
            assertEquals(c.first, 1);
            assertEquals(c.second, 2);

            var s1:Stream = $();
            s1[0] = 1;
            s1[1] = null;
            s1[2] = NaN;
            s1[3] = 2;

            var c1:Stream = s1.compact();
            assertEquals(c1.length, 2);
            assertEquals(c1.first, 1);
            assertEquals(c1.second, 2);
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
            var s1:Stream = $("1", "2");
            var s2:Stream = $(1, 2);
            var e:Stream = s1.zip(s2);
            assertEquals(e.length, s1.length);
            assertTrue(e.first is Stream);
            assertTrue(e.second is Stream);
            assertEquals(e.first.length, 2);
            assertEquals(e.first.second, 1);
            assertEquals(e.first.first, "1");
            assertEquals(e.second.second, 2);
            assertEquals(e.second.first, "2");
        }

        [Test]
        public function testZipWithIndex():void
        {
            var s:Stream = $("1", "2");
            var e:Stream = s.zipWithIndex();
            assertEquals(e.length, s.length);
            assertTrue(e.first is Stream);
            assertTrue(e.second is Stream);
            assertEquals(e.first.length, 2);
            assertEquals(e.first.second, 0);
            assertEquals(e.first.first, "1");
            assertEquals(e.second.second, 1);
            assertEquals(e.second.first, "2");
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
            assertEquals(s.map(member("name")).first, "name1");
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
        public function testAdd():void
        {
            var s:Stream = $(1, 2, 3);
            s.addItem(2, 1);
            s.addItem(0, 3);
            //3, 1, 2, 1, 3
            assertEquals(s.length, 5);
            assertEquals(s[0], 3);
            assertEquals(s[1], 1);
            assertEquals(s[2], 2);
            assertEquals(s[3], 1);
            assertEquals(s[4], 3);

            var d:Stream = $(1, 2, 3);
            d.addItem(4, 4);
            assertEquals(d.length, 5);
            assertEquals(d.last, 4);

            var e:Stream = $();
            e.addItem(0, 4);
            assertEquals(e.length, 1);
            assertEquals(e.last, 4);
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
        public function testRemove():void
        {
            var s:Stream = $(1, 2, 3);
            s.removeItem(0);
            s.removeItem(1);
            assertEquals(s.length, 1);
            assertEquals(s[0], 2);
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
            assertFalse(objectClone.source === object.source);

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
            assertFalse(objectCloneDeep.source === object.source);
        }

        [Test]
        public function testDict():void
        {
            var item1:Item = new Item("1", 1, 2);
            var item2:Item = new Item("2", 2, 0);

            var s:Stream = $(item1, item2);

            var d:Dictionary = s.dictionary(member("name"));
            assertEquals(d["1"], item1);
            assertEquals(d["2"], item2);

            var v:Dictionary = $(item1, item2, item1).dictionary(_);
            assertEquals(v[item1], item1);
            assertEquals(v[item2], item2);
        }

        [Test]
        public function testObject():void
        {
            var item1:Item = new Item("1", 1, 2);
            var item2:Item = new Item("2", 2, 0);

            var s:Stream = $(item1, item2);

            var d:Object = s.object(member("name"), member("price"));
            assertEquals(d["1"], item1.price);
            assertEquals(d["2"], item2.price);

            var n:Object = s.object(member("name"));
            assertEquals(n["1"], item1);
            assertEquals(n["2"], item2);
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

            try
            {
                $().foldLeft(function (prev:Number, current:Number):Number
                {
                    return prev + current;
                });
                assertTrue(false);
            }
            catch(e:Error)
            {
            }
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

            try
            {
                $().foldRight(function (prev:Number, current:Number):Number
                {
                    return prev + current;
                });
                assertTrue(false);
            }
            catch(e:Error)
            {
            }
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

            flatMap = Stream.of(xml).flatMap(function (item:XML):XMLList
            {
                return item.book;
            });

            assertEquals(flatMap.length, 2);
            assertEquals(flatMap.first.pageCount, "238");
            assertEquals(flatMap.second.pageCount, "115");
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
                //noinspection JSUnfilteredForInLoop
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

            var list:XMLList = xml.book;


            var x:Stream = $(list);
            assertEquals(x.length, 2);
            assertEquals(x.first.name(), "book");
            assertEquals(x.first.pageCount, "238");
            assertEquals(x.second.name(), "book");
            assertEquals(x.second.pageCount, "115");

            var xm:Stream = $(xml);
            assertEquals(xm.length, 2);
            assertEquals(xm.first.name(), "book");
            assertEquals(xm.first.pageCount, "238");
            assertEquals(xm.second.name(), "book");
            assertEquals(xm.second.pageCount, "115");
        }


        [Test]
        public function testOf():void
        {
            var flatten:Stream = Stream.of(1, 2, 3);
            assertEquals(flatten.length, 3);
            assertEquals(flatten.first, 1);
            assertEquals(flatten.second, 2);
            assertEquals(flatten.third, 3);

            assertEquals(Stream.of().length, 0);
        }

        [Test]
        public function testFrom():void
        {
            var obj:Object = {name1: "first", name2: "second", name3: "third"};
            var from:Stream = Stream.from(obj).sortOn("first");
            assertEquals(from.length, 3);

            assertEquals(from.first[0], "name1");
            assertEquals(from.first[1], "first");
            assertEquals(from.first.length, 2);

            assertEquals(from.second[0], "name2");
            assertEquals(from.second[1], "second");
            assertEquals(from.second.length, 2);

            assertEquals(from.third[0], "name3");
            assertEquals(from.third[1], "third");
            assertEquals(from.third.length, 2);

            var key:Stream = Stream.from(obj, function (item:*):String
            {
                return item[0];
            }).sort();

            assertEquals(key.length, 3);
            assertEquals(key.first, "name1");
            assertEquals(key.second, "name2");
            assertEquals(key.third, "name3");

            var value:Stream = Stream.from(obj, function (item:*):*
            {
                return item[1];
            }).sort();

            assertEquals(value.length, 3);
            assertEquals(value.first, "first");
            assertEquals(value.second, "second");
            assertEquals(value.third, "third");

            assertEquals(Stream.from(null).length, 0);

            var original:Array = [1, 2, 3];
            var array:Stream = Stream.from(original);
            verify(array, original);
            var vector:Stream = Stream.from(Vector.<Number>(original));
            verify(vector, original);
            var arrayCollection:Stream = Stream.from(new ArrayCollection(original));
            verify(arrayCollection, original);
            var arrayList:Stream = Stream.from(new ArrayList(original));
            verify(arrayList, original);
            var arrayStream:Stream = Stream.from(new Stream(original));
            verify(arrayStream, original);

            var x:Stream = Stream.from(xml.children());
            assertEquals(x.length, 2);
            assertEquals(x.first.pageCount, "238");
            assertEquals(x.second.pageCount, "115");

            var xm:Stream = Stream.from(xml);
            assertEquals(xm.length, 2);
            assertEquals(xm.first.pageCount, "238");
            assertEquals(xm.second.pageCount, "115");
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
