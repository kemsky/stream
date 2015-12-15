package com.kemsky.support
{
    import avmplus.getQualifiedClassName;

    import com.kemsky.Stream;
    import com.kemsky.combine;
    import com.kemsky.filters._;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class TestSupport
    {
        public function TestSupport()
        {
        }


        [Test]
        public function testCombine():void
        {
            var lower:Function = function(value:String):String
            {
                return value.toLowerCase();
            };
            var first:Function = function(value:String):String
            {
                return value.charAt(0);
            };

            assertEquals(combine()(1), 1);
            assertEquals(combine(_)(1), 1);

            var c:Function = combine(first, lower);
            assertEquals(c("ALEX"), "a");
        }

        [Test]
        public function testTypeCache():void
        {
            var n:Number = 1.3;
            var s:String = "test";
            var a:Array = [1, 2, 3];
            var b:Boolean = true;
            var cls:Class = Item;
            var d:Date = new Date(2000);
            var x:XML = <t>test</t>;
            var xl:XMLList = <t href="5">test</t>.@href;
            var item:Item = new Item();

            assertEquals(TypeCache.getQualifiedClassName(n), TypeCache.NUMBER);
            assertEquals(TypeCache.getQualifiedClassName(s), TypeCache.STRING);
            assertEquals(TypeCache.getQualifiedClassName(a), TypeCache.ARRAY);
            assertEquals(TypeCache.getQualifiedClassName(b), TypeCache.BOOLEAN);
            assertEquals(TypeCache.getQualifiedClassName(cls), "Item");
            assertEquals(TypeCache.getQualifiedClassName(Class), TypeCache.CLASS);
            assertEquals(TypeCache.getQualifiedClassName(d), TypeCache.DATE);
            assertEquals(TypeCache.getQualifiedClassName(x), TypeCache.XML_TYPE);
            assertEquals(TypeCache.getQualifiedClassName(xl), TypeCache.XML_LIST);
            assertEquals(TypeCache.getQualifiedClassName(undefined), TypeCache.UNDEFINED);
            assertEquals(TypeCache.getQualifiedClassName(item), "Item");

            assertEquals(TypeCache.getQualifiedClassName(n), getQualifiedClassName(n));
            assertEquals(TypeCache.getQualifiedClassName(s), getQualifiedClassName(s));
            assertEquals(TypeCache.getQualifiedClassName(a), getQualifiedClassName(a));
            assertEquals(TypeCache.getQualifiedClassName(b), getQualifiedClassName(b));
            assertEquals(TypeCache.getQualifiedClassName(cls), getQualifiedClassName(cls));
            assertEquals(TypeCache.getQualifiedClassName(Class), getQualifiedClassName(Class));
            assertEquals(TypeCache.getQualifiedClassName(d), getQualifiedClassName(d));
            assertEquals(TypeCache.getQualifiedClassName(x), getQualifiedClassName(x));
            assertEquals(TypeCache.getQualifiedClassName(xl), getQualifiedClassName(xl));
            assertEquals(TypeCache.getQualifiedClassName(item), getQualifiedClassName(item));
            assertEquals(TypeCache.getQualifiedClassName(undefined), getQualifiedClassName(undefined));
        }

        [Test]
        public function testToValue():void
        {
            var date:Date = new Date(2000);

            assertEquals(toValue(undefined, 1), 1);
            assertEquals(toValue(undefined, "test"), "test");
            assertEquals(toValue(undefined, date), date);
            assertEquals(toValue(undefined, null), null);
            assertTrue(toValue(undefined, undefined) === undefined);


            assertTrue(toValue(1, undefined) === undefined);
            assertTrue(toValue("test", undefined) === undefined);
            assertTrue(toValue(date, undefined) === undefined);
            assertTrue(toValue(null, undefined) === undefined);

            var f:Function = function(value:*):*
            {
                return value;
            };

            assertEquals(toValue(1, f), 1);
            assertEquals(toValue("test", f), "test");
            assertEquals(toValue(date, f), date);
            assertTrue(toValue(undefined, f) === undefined);
            assertEquals(toValue(null, f), null);
        }

        [Test]
        public function testCompare():void
        {
            var date:Date = new Date(2000);

            assertEquals(Compare.compare(null, null), 0);
            assertEquals(Compare.compare(null, 1), -1);
            assertEquals(Compare.compare(null, 1, Stream.DESCENDING), 1);
            assertEquals(Compare.compare(1, null), 1);
            assertEquals(Compare.compare(1, 1, Stream.NUMERIC), 0);
            assertEquals(Compare.compare(1, "1"), -1);

            assertEquals(Compare.compare(new Date(), date), 1);
            assertEquals(Compare.compare(date, date), 0);
            assertEquals(Compare.compare(date, new Date()), -1);


            assertEquals(Compare.compare(NaN, 1), -1);
            assertEquals(Compare.compare(NaN, NaN), 0);
            assertEquals(Compare.compare(1, NaN), 1);

            assertEquals(Compare.compare("abc", "def"), -1);
            assertEquals(Compare.compare("t", "t"), 0);
            assertEquals(Compare.compare("def", "abc"), 1);


            var xs1:XML = <a>123</a>;
            var xs2:XML = <a>1</a>;
            assertEquals(Compare.compare(xs1, xs2), 1);
            assertEquals(Compare.compare(xs2, xs2), 0);
            assertEquals(Compare.compare(xs2, xs1), -1);

            assertEquals(Compare.compare(xs1, xs2, Stream.NUMERIC), 1);
            assertEquals(Compare.compare(xs2, xs2, Stream.NUMERIC), 0);
            assertEquals(Compare.compare(xs2, xs1, Stream.NUMERIC), -1);

            try
            {
                Compare.compare(new Item(), new Item());
                assertFalse(true);
            }
            catch (e:Error)
            {
            }
        }

    }
}
