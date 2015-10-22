package
{
    [RemoteClass(alias="Item")]
    public class Item
    {
        public var name:String;
        public var price:Number;
        public var vat:Number;
        public var bool:Boolean;
        public var item:Item;

        public function Item(name:String = null, price:Number = 0, vat:Number = 0)
        {
            this.name = name;
            this.price = price;
            this.vat = vat;
        }

        public function toString():String
        {
            return "Item(name=" + String(name) + ", price=" + String(price) + ")";
        }
    }
}
