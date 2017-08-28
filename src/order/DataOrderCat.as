/**
 * Created by andy on 8/16/17.
 */
package order {
public class DataOrderCat {
    private static var _arrCats:Array;

    public function DataOrderCat() {
        _arrCats = [];

        var obj:Object = {
            id:1,
            nameRU: 'Узелок',
            nameENG: 'Sam',
            level: 6,
            color: OrderCat.BLACK,
            isWoman: false,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:2,
            nameRU: 'Стежок',
            nameENG: 'Felix',
            level: 3,
            color: OrderCat.BLUE,
            isWoman: false,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:3,
            color: OrderCat.GREEN,
            isWoman: false,
            nameRU: 'Крючок',
            nameENG: 'Martin',
            level: 6,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:4,
            color: OrderCat.BROWN,
            isWoman: false,
            nameRU: 'Ирис',
            nameENG: 'Ozzy',
            level: 10,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:5,
            color: OrderCat.ORANGE,
            isWoman: false,
            nameRU: 'Наперсток',
            nameENG: 'Tom',
            level: 22,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:6,
            color: OrderCat.PINK,
            isWoman: false,
            nameRU: 'Акрил',
            nameENG: 'Mark',
            level: 8,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:7,
            color: OrderCat.WHITE,
            isWoman: false,
            nameRU: 'Ажур',
            nameENG: 'Kevin',
            level: 32,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:8,
            color: OrderCat.BLACK,
            isWoman: true,
            nameRU: 'Иголочка',
            nameENG: 'Cora',
            level: 22,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:9,
            color: OrderCat.BLUE,
            isWoman: true,
            nameRU: 'Ленточка',
            nameENG: 'Ilvie',
            level: 22,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:10,
            color: OrderCat.GREEN,
            isWoman: true,
            nameRU: 'Пряжа',
            nameENG: 'Akira',
            level: 8,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:11,
            color: OrderCat.BROWN,
            isWoman: true,
            nameRU: 'Булавка',
            nameENG: 'Lexy',
            level: 3,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:12,
            color: OrderCat.ORANGE,
            isWoman: true,
            nameRU: 'Бусинка',
            nameENG: 'Dixie',
            level: 5,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:13,
            color: OrderCat.PINK,
            isWoman: true,
            nameRU: 'Петелька',
            nameENG: 'Foxy',
            level: 10,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);

        obj = {
            id:14,
            color: OrderCat.WHITE,
            isWoman: true,
            nameRU: 'Синтетика',
            nameENG: 'Daizy',
            level: 9,
            description: "wazzzzzap"
        };
        _arrCats.push(obj);
    }

    public static function get arr():Array { return _arrCats; }

    public static function getObjById(id:int):Object {
        for (var i:int=0; i<14; i++) {
            if (_arrCats[i].id == id)  return _arrCats[i];
        }
        return {};
    }
    
    public static function getArrByLevel(l:int):Array {
        var ar:Array = new Array();
        for (var i:int=0; i<14; i++) {
            if (_arrCats[i].level <= l) ar.push(_arrCats[i]);
        }
        return ar;
    }

}
}
