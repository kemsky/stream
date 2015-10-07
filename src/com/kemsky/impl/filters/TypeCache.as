package com.kemsky.impl.filters
{
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getQualifiedSuperclassName;

    public class TypeCache
    {
        private static const CLASS_PATTERN:RegExp = /\.([a-zA-Z0-9_$]+)$/;

        public static const NUMBER:String = "Number";
        public static const INT:String = "int";
        public static const UINT:String = "uint";
        public static const STRING:String = "String";
        public static const BOOLEAN:String = "Boolean";
        public static const DATE:String = "Date";
        public static const XML_TYPE:String = "XML";
        public static const CLASS:String = "Class";
        public static const ARRAY:String = "Array";
        public static const ANY:String = "*";

        private static const classToFullName:Dictionary = new Dictionary(true);
        private static const classToFullSuperName:Dictionary = new Dictionary(true);
        private static const fullNameToClass:Dictionary = new Dictionary(true);

        classToFullName[Number] = NUMBER;
        classToFullName[int] = INT;
        classToFullName[uint] = UINT;
        classToFullName[String] = STRING;
        classToFullName[Boolean] = BOOLEAN;
        classToFullName[Date] = DATE;
        classToFullName[XML] = XML_TYPE;
        classToFullName[Class] = CLASS;
        classToFullName[Array] = ARRAY;


        fullNameToClass[NUMBER] = Number;
        fullNameToClass[INT] = int;
        fullNameToClass[UINT] = uint;
        fullNameToClass[STRING] = String;
        fullNameToClass[BOOLEAN] = Boolean;
        fullNameToClass[DATE] = Date;
        fullNameToClass[XML_TYPE] = XML;
        fullNameToClass[CLASS] = Class;
        fullNameToClass[ARRAY] = Array;
        fullNameToClass[ANY] = Object;


        public static function getQualifiedSuperclassName(object:*):String
        {
            if(!(object is Class) && object != null)
            {
                object = object.constructor;
            }

            var name:String = classToFullSuperName[object];
            if(name == null)
            {
                name = flash.utils.getQualifiedSuperclassName(object);
                classToFullSuperName[object] = name;
            }
            return name;
        }

        public static function getQualifiedClassName(object:*):String
        {
            if(!(object is Class) && object != null)
            {
                object = object.constructor;
            }

            var name:String = classToFullName[object];
            if(name == null)
            {
                name = flash.utils.getQualifiedClassName(object);
                fullNameToClass[name] = object;
                classToFullName[object] = name;
            }
            return name;
        }

        public static function getDefinitionByName(object:String):Class
        {
            var clazz:Class = fullNameToClass[object];
            if(clazz == null)
            {
                clazz = flash.utils.getDefinitionByName(object) as Class;
                fullNameToClass[object] = clazz;
                classToFullName[clazz] = object.replace(CLASS_PATTERN, "::$1");
            }
            return clazz;
        }
    }
}
