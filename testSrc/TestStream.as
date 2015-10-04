package
{
    import com.kemsky.$;
    import com.kemsky.impl.Stream;
    import com.kemsky.impl.curry;
    import com.kemsky.impl.filters._;
    import com.kemsky.impl.filters.add;
    import com.kemsky.impl.filters.and;
    import com.kemsky.impl.filters.eq;
    import com.kemsky.impl.filters.ge;
    import com.kemsky.impl.filters.gt;
    import com.kemsky.impl.filters.le;
    import com.kemsky.impl.filters.lt;
    import com.kemsky.impl.filters.ne;
    import com.kemsky.impl.filters.or;
    import com.kemsky.impl.filters.prop;
    import com.kemsky.impl.filters.subtract;

    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    import mx.logging.Log;
    import mx.logging.targets.TraceTarget;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class TestStream
    {
        //private static const log:ILogger = Log.getLogger("TestStream");

        public function TestStream()
        {
            Log.addTarget(new TraceTarget());
        }


        [Test]
        public function testCount():void
        {
            var s:Stream = $(1, 2, 3);
            var count:Number = s.count(function(item:Number):Boolean
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
            assertFalse(primitiveClone == primitive);

            var primitiveCloneDeep:Stream = primitive.clone(true);
            assertEquals(primitiveCloneDeep.length, 3);
            assertEquals(primitiveCloneDeep[0], 1);
            assertEquals(primitiveCloneDeep[1], 2);
            assertEquals(primitiveCloneDeep[2], 3);
            assertFalse(primitiveCloneDeep == primitive);
        }

        [Test]
        public function testCloneObjectStream():void
        {
            var item1:Item = new Item("name1", 1, 2);
            var item2:Item = new Item("name2", 2, 0);

            var object:Stream = $(item1, item2);

            var objectClone:Stream = object.clone();
            assertEquals(objectClone.length, 2);

            assertEquals(Item(objectClone[0]), item1);
            assertEquals(Item(objectClone[0]).name, item1.name);
            assertEquals(Item(objectClone[0]).price, item1.price);
            assertEquals(Item(objectClone[0]).vat, item1.vat);

            assertEquals(Item(objectClone[1]), item2);
            assertEquals(Item(objectClone[1]).name, item2.name);
            assertEquals(Item(objectClone[1]).price, item2.price);
            assertEquals(Item(objectClone[1]).vat, item2.vat);

            var objectCloneDeep:Stream = object.clone(true);
            assertEquals(objectCloneDeep.length, 2);

            assertEquals(Item(objectCloneDeep[0]).name, item1.name);
            assertEquals(Item(objectCloneDeep[0]).price, item1.price);
            assertEquals(Item(objectCloneDeep[0]).vat, item1.vat);

            assertEquals(Item(objectCloneDeep[1]).name, item2.name);
            assertEquals(Item(objectCloneDeep[1]).price, item2.price);
            assertEquals(Item(objectCloneDeep[1]).vat, item2.vat);
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

            result = s.price(gt(1));
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
        }

        [Test]
        public function testFoldAsOption():void
        {
            var empty:Stream = $(null);
            var nonEmpty:Stream = $("random");

            assertEquals(empty.fold("empty"), "empty");
            assertEquals(empty.fold(), null);
            assertEquals(nonEmpty.fold("empty"), "random");
            assertEquals(nonEmpty.fold(), "random");
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
            var s:Stream = $("1", "2", "1").filter(eq("2"));
            assertEquals(s.first, "2");
            assertEquals(s.length, 1);

            //todo
        }

        [Test]
        public function testEq():void
        {
            var eq1:Stream = $(1, 2, 3).filter(eq(2));
            assertEquals(eq1.length, 1);
            assertEquals(eq1[0], 2);
        }

        [Test]
        public function testNe():void
        {
            var ne1:Stream = $(1, 2, 3).filter(ne(2));
            assertEquals(ne1.length, 2);
            assertEquals(ne1[0], 1);
            assertEquals(ne1[1], 3);
        }

        [Test]
        public function testOr():void
        {
            var or1:Stream = $(1, 2, 3).filter(or(eq(1), eq(3)));
            assertEquals(or1.length, 2);
            assertEquals(or1[0], 1);
            assertEquals(or1[1], 3);
        }

        [Test]
        public function testAnd():void
        {
            var and1:Stream = $(1, 2, 3).filter(and(gt(1), lt(3)));
            assertEquals(and1.length, 1);
            assertEquals(and1[0], 2);
        }

        [Test]
        public function testLe():void
        {
            var le1:Stream = $(1, 2, 3).filter(le(2));
            assertEquals(le1.length, 2);
            assertEquals(le1[0], 1);
            assertEquals(le1[1], 2);
        }

        [Test]
        public function testLt():void
        {
            var lt1:Stream = $(1, 2, 3).filter(lt(2));
            assertEquals(lt1.length, 1);
            assertEquals(lt1[0], 1);
        }

        [Test]
        public function testGe():void
        {
            var ge1:Stream = $(1, 2, 3).filter(ge(2));
            assertEquals(ge1.length, 2);
            assertEquals(ge1[0], 2);
            assertEquals(ge1[1], 3);
        }

        [Test]
        public function testGt():void
        {
            var gt1:Stream = $(1, 2, 3).filter(gt(2));
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
        }

        [Test]
        public function testFold():void
        {
            var sum1:Number = $(0, 1, 2, 3, 4).fold(function (prev:Number, current:Number):Number
            {
                return prev + current;
            }, 0);

            assertEquals(sum1, 10);

            var sum2:Number = $(0, 1, 2, 3, 4).fold(function (prev:Number, current:Number):Number
            {
                return prev + current;
            }, 10);

            assertEquals(sum2, 20);
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
            var s:Stream = new Stream([[1, 2, 3], $(4, 5, 6), new ArrayCollection([7, 8, 9])]);

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
            verify(array.collection, original);
            verify(array.list, original);

            assertTrue(array.array is Array);
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
            verify(args.collection, original);
            verify(args.list, original);


            var single:Stream = $("item");
            assertEquals(single.empty, false);
            assertEquals(single.length, 1);
            assertEquals(single[0], "item");
            assertEquals(single.first, "item");
            assertEquals(single.last, "item");
            assertEquals(single.first, single.last);
        }

        private function verify(s:*, o:Array):void
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
