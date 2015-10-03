package
{
    import com.kemsky.impl.Stream;
    import com.kemsky.impl.curry;
    import com.kemsky.impl.filters._;
    import com.kemsky.impl.filters.eq;
    import com.kemsky.impl.filters.ge;
    import com.kemsky.impl.filters.gt;
    import com.kemsky.impl.filters.or;
    import com.kemsky.$;
    import com.kemsky.impl.filters.prop;
    import com.kemsky.impl.filters.subtract;
    import com.kemsky.impl.filters.add;

    import flash.utils.Dictionary;

    import mx.collections.ArrayCollection;
    import mx.logging.ILogger;
    import mx.logging.Log;
    import mx.logging.targets.TraceTarget;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class TestStream
    {
        private static const log:ILogger = Log.getLogger("TestStream");

        public function TestStream()
        {
            Log.addTarget(new TraceTarget());
        }


        [Test]
        public function testClonePrimitiveStream():void
        {
            var primitive:Stream = $(1, 2 , 3);

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
            var nullable:Stream = $(null);
            var nonnull:Stream = $("random");

            assertEquals(nullable.fold("empty"), "empty");
            assertEquals(nullable.fold(), null);
            assertEquals(nonnull.fold("empty"), "random");
            assertEquals(nonnull.fold(), "random");
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
        }

        [Test]
        public function testSkip():void
        {
            assertEquals($(1, 2).skip(1).first, 2);
            assertEquals($(1, 2).skip(1).length, 1);
        }

        [Test]
        public function testLastFirst():void
        {
            assertEquals($(0, 1, 2, 3, 4).first, 0);
            assertEquals($(0, 1, 2, 3, 4).last, 4);
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

            var flatDefault:Stream = s.flatMap();
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
        public function testCreate():void
        {
            var streamEmpty:Stream = $();
            assertEquals(streamEmpty.length, 0);
            iterate(streamEmpty);
            deleteItem(streamEmpty);
            push(streamEmpty, 5);
            pop(streamEmpty);

            var streamArray:Stream = $([1, 2, 3, 4, 5]);
            assertEquals(streamArray.length, 5);
            iterate(streamArray);
            deleteItem(streamArray);
            push(streamArray, 5);
            pop(streamArray);

            var streamArrayCollection:Stream = $(new ArrayCollection([1, 2, 3, 4, 5]));
            assertEquals(streamArrayCollection.length, 5);
            iterate(streamArrayCollection);
            deleteItem(streamArrayCollection);
            push(streamArrayCollection, 5);
            pop(streamArrayCollection);

            var streamArguments:Stream = $(1, 2, 3, 4, 5);
            assertEquals(streamArguments.length, 5);
            iterate(streamArguments);
            deleteItem(streamArguments);
            push(streamArguments, 5);
            pop(streamArguments);

            var streamOneItem:Stream = $("item");
            assertEquals(streamOneItem.length, 1);
            iterate(streamOneItem);
            deleteItem(streamOneItem);
            push(streamOneItem, 5);
            pop(streamOneItem);
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
