/**
 * Created by andy on 7/7/15.
 */
package temp {
import data.DataMoney;

public class DropResourceVariaty {
    public static const DROP_VARIATY:int = 3; // == 2 %
    public static const DROP_TYPE_RESOURSE:String = 'resource';
    public static const DROP_TYPE_MONEY:String = 'money';
    public static const DROP_TYPE_DECOR:String = 'decor';
    public static const DROP_TYPE_DECOR_ANIMATION:String = 'decorAnimation';

    public var resources:Array;

    public function DropResourceVariaty() {
        resources = [];

        fillVariaty();
    }

    private function fillVariaty():void {
        var obj:Object;

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 1;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 2;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 3;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 4;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 5;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 6;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 7;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 8;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 9;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 124;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_RESOURSE;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = 125;
        resources.push(obj);

//        obj = {};
//        obj.type = DROP_TYPE_MONEY;
//        obj.count = 1;
//        obj.variaty = 1;
//        obj.id = DataMoney.HARD_CURRENCY;
//        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_MONEY;
        obj.count = 100;
        obj.variaty = 1;
        obj.id = DataMoney.SOFT_CURRENCY;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_MONEY;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = DataMoney.YELLOW_COUPONE;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_MONEY;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = DataMoney.RED_COUPONE;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_MONEY;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = DataMoney.GREEN_COUPONE;
        resources.push(obj);

        obj = {};
        obj.type = DROP_TYPE_MONEY;
        obj.count = 1;
        obj.variaty = 1;
        obj.id = DataMoney.BLUE_COUPONE;
        resources.push(obj);
    }
}
}
