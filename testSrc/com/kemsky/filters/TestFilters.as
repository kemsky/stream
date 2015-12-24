package com.kemsky.filters
{
    import com.kemsky.$;
    import com.kemsky.Stream;

    import flash.utils.Dictionary;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertTrue;

    public class TestFilters
    {
        public function TestFilters()
        {
        }

        [Test]
        public function testInvoke():void
        {
            var item1:Item = new Item("1", 1, 2);
            var item2:Item = new Item("2", 2, 0);

            var s:Stream = $(item1, item2);

            var result:Stream = s.filter(eq(invoke("equals", item1), true));
            assertEquals(result.length, 1);
            assertEquals(result.first, item1);

            result = s.filter(eq(invoke(["equals"], item1), true));
            assertEquals(result.length, 1);
            assertEquals(result.first, item1);

            var obj:Item = new Item("p0");
            obj.item = new Item("p1");
            obj.item.item = new Item("p2");
            obj.item.item.item = new Item("p3");
            obj.item.item.item.item = new Item("p4");

            var nested:Stream = $(obj);

            result = nested.filter(eq(invoke("method", 1), "p01"));
            assertEquals(result.length, 1);

            result = nested.filter(eq(invoke("method1", 1), undefined));
            assertEquals(result.length, 1);


            result = nested.filter(eq(invoke("item.method", 1), "p11"));
            assertEquals(result.length, 1);

            result = nested.filter(eq(invoke("item.method1", 1), undefined));
            assertEquals(result.length, 1);


            result = nested.filter(eq(invoke("item.item.method", 1), "p21"));
            assertEquals(result.length, 1);

            result = nested.filter(eq(invoke("item.item.method1", 1), undefined));
            assertEquals(result.length, 1);


            result = nested.filter(eq(invoke("item.item.item.method", 1), "p31"));
            assertEquals(result.length, 1);

            result = nested.filter(eq(invoke("item.item.item.method1", 1), undefined));
            assertEquals(result.length, 1);


            result = nested.filter(eq(invoke("item.item.item.item.method", 1), "p41"));
            assertEquals(result.length, 1);

            result = nested.filter(eq(invoke("item.item.item.item.method1", 1), undefined));
            assertEquals(result.length, 1);

            try
            {
                nested.filter(eq(invoke("item.item.item.item.item.method", 1), "p51"));
                assertTrue(false);
            }
            catch(e:Error){}

            try
            {
                invoke(null);
                assertTrue(false);
            }
            catch (e:Error)
            {
            }

            try
            {
                invoke([1]);
                assertTrue(false);
            }
            catch (e:Error)
            {
            }
        }


        [Test]
        public function testType():void
        {
            var stream:Stream = new Stream();

            var s:Stream = $("test", 123, stream);

            var d:Stream = s.filter(type(_, Stream));
            assertEquals(d.length, 1);
            assertEquals(d.first, stream);
        }


        [Test]
        public function testExisting():void
        {
            var s:Stream = $();
            s[0] = 0;
            s[3] = null;
            s[6] = NaN;
            s[10] = "";

            var r:Stream = s.filter(existing(_));
            assertEquals(r.length, 2);
            assertEquals(r.first, 0);
            assertEquals(r.second, "");
        }

        [Test]
        public function testUnderscore():void
        {
            var d:Date = new Date();

            assertEquals(_("test"), "test");
            assertEquals(_(1), 1);
            assertEquals(_(d), d);

            var s:Stream = $(true, false, false).filter(_);
            assertEquals(s.length, 1);
            assertEquals(s.first, true);
        }

        [Test]
        public function testEq():void
        {
            var d:Date = new Date();
            assertEquals(eq("test", "test")(null), true);
            assertEquals(eq(1, 1)(null), true);
            assertEquals(eq(d, d)(null), true);
            assertEquals(eq(_, _)(null), true);


            var eq1:Stream = $(1, 2, 3).filter(eq(_, 2));
            assertEquals(eq1.length, 1);
            assertEquals(eq1[0], 2);

            var item1:Item = new Item("test1", 6);
            var item2:Item = new Item("test2", 7);
            item2.bool = true;

            var eq2:Stream = $(item1, item2).filter(eq(_, item1));
            assertEquals(eq2.length, 1);
            assertEquals(eq2[0], item1);


            var eq3:Stream = $("alex", "Alex", "ALEX").filter(eq(_, "alex", Stream.CASEINSENSITIVE));
            assertEquals(eq3.length, 3);
            assertEquals(eq3.first, "alex");
            assertEquals(eq3.second, "Alex");
            assertEquals(eq3.third, "ALEX");

            var eq4:Stream = $("alex", "Alex", "ALEX").filter(eq(_, "alex"));
            assertEquals(eq4.length, 1);
            assertEquals(eq4.first, "alex");

            var s:Stream = $(item1, item2);

            assertEquals(s.filter(eq(member("bool"), true)).first, item2);
            assertEquals(s.filter(eq(member("bool"), false)).first, item1);
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

            var gt2:Stream = $("test1", "", null).filter(le(_, ""));
            assertEquals(gt2.length, 2);
            assertEquals(gt2[0], "");
            assertEquals(gt2[1], null);
        }

        [Test]
        public function testLt():void
        {
            var lt1:Stream = $(1, 2, 3).filter(lt(_, 2));
            assertEquals(lt1.length, 1);
            assertEquals(lt1[0], 1);

            var gt2:Stream = $("test1", "", null).filter(lt(_, ""));
            assertEquals(gt2.length, 1);
            assertEquals(gt2[0], null);
        }

        [Test]
        public function testGe():void
        {
            var ge1:Stream = $(1, 2, 3).filter(ge(_, 2));
            assertEquals(ge1.length, 2);
            assertEquals(ge1[0], 2);
            assertEquals(ge1[1], 3);

            var gt2:Stream = $("test1", "", null).filter(ge(_, ""));
            assertEquals(gt2.length, 2);
            assertEquals(gt2[0], "test1");
            assertEquals(gt2[1], "");
        }

        [Test]
        public function testGt():void
        {
            var gt1:Stream = $(1, 2, 3).filter(gt(_, 2));
            assertEquals(gt1.length, 1);
            assertEquals(gt1[0], 3);

            var gt2:Stream = $("test1", "", null).filter(gt(_, ""));
            assertEquals(gt2.length, 1);
            assertEquals(gt2[0], "test1");
        }


        [Test]
        public function testMember():void
        {
            var item1:Item = new Item("1", 1, 2);
            var item2:Item = new Item("2", 2, 0);

            var s:Stream = $(item1, item2);

            var result:Stream = s.filter(gt(member("price"), 1));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2);

            result = s.filter(gt(member(["price"]), 1));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2);

            result = s.price(gt(_, 1));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2);

            result = s..price.filter(gt(_, 1));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2.price);

            result = s.filter(ge(member("price"), 2));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2);

            result = s.filter(gt(add(member("price"), member("vat"), 0), 2));
            assertEquals(result.length, 1);
            assertEquals(result.first, item1);

            result = s.filter(gt(subtract(member("price"), member("vat")), 0));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2);

            result = s.filter(gt(subtract(member("price"), 1), 0));
            assertEquals(result.length, 1);
            assertEquals(result.first, item2);

            result = s.filter(gt(0, 1));
            assertEquals(result.length, 0);

            var obj:Item = new Item("p0");
            obj.item = new Item("p1");
            obj.item.item = new Item("p2");
            obj.item.item.item = new Item("p3");
            obj.item.item.item.item = new Item("p4");

            var nested:Stream = $(obj);

            result = nested.filter(eq(member("name"), "p0"));
            assertEquals(result.length, 1);

            result = nested.filter(eq(member("name1"), undefined));
            assertEquals(result.length, 1);


            result = nested.filter(eq(member("item.name"), "p1"));
            assertEquals(result.length, 1);

            result = nested.filter(eq(member("item.name1"), undefined));
            assertEquals(result.length, 1);


            result = nested.filter(eq(member("item.item.name"), "p2"));
            assertEquals(result.length, 1);

            result = nested.filter(eq(member("item.item.name1"), undefined));
            assertEquals(result.length, 1);


            result = nested.filter(eq(member("item.item.item.name"), "p3"));
            assertEquals(result.length, 1);

            result = nested.filter(eq(member("item.item.item.name1"), undefined));
            assertEquals(result.length, 1);


            result = nested.filter(eq(member("item.item.item.item.name"), "p4"));
            assertEquals(result.length, 1);

            result = nested.filter(eq(member("item.item.item.item.name1"), undefined));
            assertEquals(result.length, 1);

            try
            {
                nested.filter(eq(member("item.item.item.item.item.name"), "p5"));
                assertTrue(false);
            }
            catch(e:Error){}

            //some fun
            result = s.filter(ge(function (item:Item):Number
            {
                return item.price + item.vat;
            }, 3));
            assertEquals(result.length, 1);
            assertEquals(result.first, item1);

            try
            {
                s.random();
                assertFalse(true);
            }
            catch (e:Error)
            {
            }

            try
            {
                member(null);
                assertFalse(true);
            }
            catch (e:Error)
            {
            }

            try
            {
                member([1]);
                assertFalse(true);
            }
            catch (e:Error)
            {
            }
        }


        [Test]
        public function testMapped():void
        {
            var item:Item = new Item("name", 5, 0);

            var d:Dictionary = new Dictionary();
            d[item.name] = item;

            var o:Object = {};
            o[item.name] = item;

            var s:Stream = $(item);

            assertEquals(s.filter(mapped(member("name"), d)).length, 1);
            assertEquals(s.filter(mapped(member("name"), o)).length, 1);


            var p:Stream = $("name", "price", "vat");
            assertEquals(p.filter(mapped(_, item)).length, 3);
        }


        [Test]
        public function testEither():void
        {
            var s:Stream = $(1, 2, 3);
            assertEquals(s.count(either(_, 1, 2)), 2);

            assertEquals(s.count(either(_, [1, 2])), 2);
            assertEquals(s.count(either(_, [4])), 0);

            try
            {
                s.count(either(_));
                assertFalse(true);
            }
            catch (e:Error)
            {
            }
        }


        [Test]
        public function testDefined():void
        {
            var s:Stream = $();
            s[0] = 0;
            s[10] = 1;

            var r:Stream = s.filter(defined(_));
            assertEquals(r.length, 2);
            assertEquals(r.first, 0);
            assertEquals(r.second, 1);
        }

        [Test]
        public function testMultiply():void
        {
            var s:Stream = $(1, 2).filter(eq(multiply(_, 2), 4));
            assertEquals(s.length, 1);
            assertEquals(s.first, 2);
        }

        [Test]
        public function testDivide():void
        {
            var s:Stream = $(2, 4).filter(eq(divide(_, 2), 2));
            assertEquals(s.length, 1);
            assertEquals(s.first, 4);

            s = $(2, 4).filter(eq(divide(_, _), 1));
            assertEquals(s.length, 2);
            assertEquals(s.first, 2);
            assertEquals(s.second, 4);
        }

        [Test]
        public function testNot():void
        {
            var s:Stream = $("1", "2").filter(not(function (item:String):Boolean
            {
                return item == "2";
            }));
            assertEquals(s.first, "1");
            assertEquals(s.length, 1);
        }

    }
}
