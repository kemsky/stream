package com.kemsky.support
{
    import flash.utils.Dictionary;
    import avmplus.getQualifiedClassName;

    /**
     * Fast getQualifiedClassName implementation.
     * @private
     * @see flash.utils.getQualifiedClassName
     */
    public class TypeCache
    {
        public static const NUMBER:String = "Number";
        public static const STRING:String = "String";
        public static const BOOLEAN:String = "Boolean";
        public static const DATE:String = "Date";
        public static const XML_TYPE:String = "XML";
        public static const XML_LIST:String = "XMLList";
        public static const CLASS:String = "Class";
        public static const ARRAY:String = "Array";
        public static const UNDEFINED:String = "void";

        private static const classToFullName:Dictionary = new Dictionary(true);

        private static const instance:TypeCache = new TypeCache();

        public function TypeCache()
        {
            classToFullName[Number] = NUMBER;
            classToFullName[String] = STRING;
            classToFullName[Boolean] = BOOLEAN;
            classToFullName[Date] = DATE;
            classToFullName[XML] = XML_TYPE;
            classToFullName[Class] = CLASS;
            classToFullName[Array] = ARRAY;
            classToFullName[XMLList] = XML_LIST;
            classToFullName[undefined] = UNDEFINED;
        }

        public static function getQualifiedClassName(object:*):String
        {
            if(!(object is Class || object is XML) && object != null)
            {
                object = object.constructor;
            }
            var name:String = classToFullName[object];
            if(name == null)
            {
                name = flash.utils.getQualifiedClassName(object);
                classToFullName[object] = name;
            }
            return name;
        }
    }
}