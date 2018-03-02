/**
 * Created by user on 2/15/16.
 */
package order {

public class OrderItemStructure {
    public var dbId:String;
    public var resourceIds:Array;
    public var resourceCounts:Array;
    public var coins:int;
    public var xp:int;
    public var addCoupone:Boolean;
    public var startTime:int;
    public var placeNumber:int;
    public var cat:OrderCat;
    public var catOb:Object;
    public var delOb:Boolean = false;
//    public var saleCat:Boolean = false;
    public var fasterBuy:Boolean = false;
}
}
