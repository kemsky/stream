/*
 *  Copyright: (c) 2015. Turtsevich Alexander
 *
 *  Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.html
 */

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

        public static function getQualifiedClassName(object:*):String
        {
            if(!(object is XML || object is Class) && object != null)
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
