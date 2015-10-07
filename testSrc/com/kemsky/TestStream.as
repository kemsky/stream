package com.kemsky
{
    import com.kemsky.impl.Stream;
    import com.kemsky.impl.curry;
    import com.kemsky.impl.filters._;
    import com.kemsky.impl.filters.add;
    import com.kemsky.impl.filters.and;
    import com.kemsky.impl.filters.either;
    import com.kemsky.impl.filters.eq;
    import com.kemsky.impl.filters.ge;
    import com.kemsky.impl.filters.gt;
    import com.kemsky.impl.filters.le;
    import com.kemsky.impl.filters.lt;
    import com.kemsky.impl.filters.mapped;
    import com.kemsky.impl.filters.ne;
    import com.kemsky.impl.filters.boolFalse;
    import com.kemsky.impl.filters.or;
    import com.kemsky.impl.filters.boolTrue;
    import com.kemsky.impl.filters.prop;
    import com.kemsky.impl.filters.subtract;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    CONFIG::flex {
        import mx.collections.ArrayCollection;
        import mx.collections.IList;
    }

    public class TestStream
    {
        public function TestStream()
        {
        }

        [Test]
        public function testMap():void
        {
            var item:Item = new Item("name", 5, 0);

            var d:Dictionary = new Dictionary();
            d[item.name] = item;

            var o:Object = {};
            o[item.name] = item;

            var s:Stream = $(item);

            assertEquals(s.filter(mapped(prop("name"), d)).length, 1);
            assertEquals(s.filter(mapped(prop("name"), o)).length, 1);


            var p:Stream = $("name", "price", "vat");
            assertEquals(p.filter(mapped(_, item)).length, 3);
        }

        [Test]
        public function testBoolean():void
        {
            var item1:Item = new Item();
            var item2:Item = new Item();
            item2.bool = true;
            var s:Stream = $(item1, item2);

            assertEquals(s.filter(boolTrue(prop("bool"))).first, item2);
            assertEquals(s.filter(boolFalse(prop("bool"))).first, item1);
        }

        [Test]
        public function testEither():void
        {
            var s:Stream = $(1, 2, 3);
            assertEquals(s.count(either(_, 1, 2)), 2);

            assertEquals(s.count(either(_, [1, 2])), 2);
            assertEquals(s.count(either(_, [4])), 0);
        }

        [Test]
        public function testSet():void
        {
            var s:Stream = $(1, 2, 3);
            s.set(2, 1);
            s.set(0, 3);
            assertEquals(s[0], 3);
            assertEquals(s[1], 2);
            assertEquals(s[2], 1);
        }

        [Test]
        public function testGet():void
        {
            var s:Stream = $(1, 2, 3);
            assertEquals(s.get(0), 1);
            assertEquals(s.get(1), 2);
            assertEquals(s.get(2), 3);

            assertTrue(s.get(3) === undefined);
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
        public function testClonePrimitiveStream():void
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
        public function testCloneObjectStream():void
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
        public function testProperty():void
        {
            var item1:Item = new Item("1", 1, 2);
            var item2:Item = new Item("2", 2, 0);

            var s:Stream = $(item1, item2);

            var result:Stream = s.filter(gt(prop("price"), 1));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2);

            result = s.price(gt(_, 1));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2);

            result = s..price.filter(gt(_, 1));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2.price);

            result = s.filter(ge(prop("price"), 2));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2);

            result = s.filter(gt(add(prop("price"), prop("vat")), 2));
            assertEquals(result.length, 1);
            assertEquals(result.first, item1);

            result = s.filter(gt(subtract(prop("price"), prop("vat")), 0));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2);

            result = s.filter(gt(0, 1));
            assertEquals(result.length, 0);

            //some fun
            result = s.filter(ge(function (item:Item):Number
            {
                return item.price + item.vat;
            }, 3));
            assertEquals(result.length, 1);
            assertEquals(result.first, item1);
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
        public function testEq():void
        {
            var eq1:Stream = $(1, 2, 3).filter(eq(_, 2));
            assertEquals(eq1.length, 1);
            assertEquals(eq1[0], 2);

            var item1:Item = new Item("test1", 6);
            var item2:Item = new Item("test2", 7);

            var eq2:Stream = $(item1, item2).filter(eq(_, item1));
            assertEquals(eq2.length, 1);
            assertEquals(eq2[0], item1);
        }

        [Test]
        public function testNe():void
        {
            var ne1:Stream = $(1, 2, 3).filter(ne(_, 2));
            assertEquals(ne1.length, 2);
            assertEquals(ne1[0], 1);
            assertEquals(ne1[1], 3);
        }

        [Test]
        public function testOr():void
        {
            var or1:Stream = $(1, 2, 3).filter(or(eq(_, 1), eq(_, 3)));
            assertEquals(or1.length, 2);
            assertEquals(or1[0], 1);
            assertEquals(or1[1], 3);
        }

        [Test]
        public function testAnd():void
        {
            var and1:Stream = $(1, 2, 3).filter(and(gt(_, 1), lt(_, 3)));
            assertEquals(and1.length, 1);
            assertEquals(and1[0], 2);
        }

        [Test]
        public function testLe():void
        {
            var le1:Stream = $(1, 2, 3).filter(le(_, 2));
            assertEquals(le1.length, 2);
            assertEquals(le1[0], 1);
            assertEquals(le1[1], 2);
        }

        [Test]
        public function testLt():void
        {
            var lt1:Stream = $(1, 2, 3).filter(lt(_, 2));
            assertEquals(lt1.length, 1);
            assertEquals(lt1[0], 1);
        }

        [Test]
        public function testGe():void
        {
            var ge1:Stream = $(1, 2, 3).filter(ge(_, 2));
            assertEquals(ge1.length, 2);
            assertEquals(ge1[0], 2);
            assertEquals(ge1[1], 3);
        }

        [Test]
        public function testGt():void
        {
            var gt1:Stream = $(1, 2, 3).filter(gt(_, 2));
            assertEquals(gt1.length, 1);
            assertEquals(gt1[0], 3);
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
        }

        [Test]
        public function testFlatMap():void
        {
            var s:Stream = new Stream([[1, 2, 3], $(4, 5, 6)]);

            CONFIG::flex {
                s.push(new ArrayCollection([7, 8, 9]));
            }


            var flatDefault:Stream = s.flatten();
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
            verify(array.array, original);
            CONFIG::flex {
                verify(array.collection, original);
                verify(array.list, original);
            }

            assertTrue(array.array is Array);

            CONFIG::flex {
                assertTrue(array.collection is ArrayCollection);
                assertTrue(array.list is IList);

                var collection:Stream = $(new ArrayCollection([1, 2, 3]));
                assertEquals(collection.empty, false);
                assertEquals(collection.length, 3);
                assertEquals(collection.first, 1);
                assertEquals(collection[0], 1);
                assertEquals(collection[1], 2);
                assertEquals(collection[2], 3);
                assertEquals(collection.last, 3);
                verify(collection, original);
                verify(collection.array, original);
                verify(collection.collection, original);
                verify(collection.list, original);
            }

            var args:Stream = $(1, 2, 3);
            assertEquals(args.empty, false);
            assertEquals(args.length, 3);
            assertEquals(args.first, 1);
            assertEquals(args[0], 1);
            assertEquals(args[1], 2);
            assertEquals(args[2], 3);
            assertEquals(args.last, 3);
            verify(args, original);
            verify(args.array, original);
            CONFIG::flex {
                verify(args.collection, original);
                verify(args.list, original);
            }


            var single:Stream = $("item");
            assertEquals(single.empty, false);
            assertEquals(single.length, 1);
            assertEquals(single[0], "item");
            assertEquals(single.first, "item");
            assertEquals(single.last, "item");
            assertEquals(single.first, single.last);
        }

        private static function verify(s:*, o:Array):void
        {
            var index:int = 0;
            for each (var item:* in s)
            {
                assertEquals(item, o[index]);
                index++;
            }
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
    }
}