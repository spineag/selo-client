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
            color: OrderCat.BLACK_MAN,
            isWoman: false,
            description: "wazzzzzap",
            txtMiniScene: 1160,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:2,
            nameRU: 'Стежок',
            nameENG: 'Felix',
            level: 4,
            color: OrderCat.BLUE_MAN,
            isWoman: false,
            description: "wazzzzzap",
            txtMiniScene: 1158,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:3,
            color: OrderCat.GREEN_MAN,
            isWoman: false,
            nameRU: 'Крючок',
            nameENG: 'Martin',
            level: 6,
            description: "wazzzzzap",
            txtMiniScene: 1161,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:4,
            color: OrderCat.BROWN_MAN,
            isWoman: false,
            nameRU: 'Ирис',
            nameENG: 'Ozzy',
            level: 10,
            description: "wazzzzzap",
            txtMiniScene: 1167,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:5,
            color: OrderCat.ORANGE_MAN,
            isWoman: false,
            nameRU: 'Наперсток',
            nameENG: 'Tom',
            level: 22,
            description: "wazzzzzap",
            txtMiniScene: 1168,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:6,
            color: OrderCat.PINK_MAN,
            isWoman: false,
            nameRU: 'Акрил',
            nameENG: 'Mark',
            level: 8,
            description: "wazzzzzap",
            txtMiniScene: 1164,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:7,
            color: OrderCat.WHITE_MAN,
            isWoman: false,
            nameRU: 'Ажур',
            nameENG: 'Kevin',
            level: 32,
            description: "wazzzzzap",
            txtMiniScene: 1170,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:8,
            color: OrderCat.BLACK_WOMAN,
            isWoman: true,
            nameRU: 'Иголочка',
            nameENG: 'Cora',
            level: 22,
            description: "wazzzzzap",
            txtMiniScene: 1169,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:9,
            color: OrderCat.BLUE_WOMAN,
            isWoman: true,
            nameRU: 'Ленточка',
            nameENG: 'Ivie',
            level: 7,
            description: "wazzzzzap",
            txtMiniScene: 1162,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:10,
            color: OrderCat.GREEN_WOMAN,
            isWoman: true,
            nameRU: 'Пряжа',
            nameENG: 'Akira',
            level: 8,
            description: "wazzzzzap",
            txtMiniScene: 1163,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:11,
            color: OrderCat.BROWN_WOMAN,
            isWoman: true,
            nameRU: 'Булавка',
            nameENG: 'Lexy',
            level: 4,
            description: "wazzzzzap",
            txtMiniScene: 1157,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:12,
            color: OrderCat.ORANGE_WOMAN,
            isWoman: true,
            nameRU: 'Бусинка',
            nameENG: 'Dixie',
            level: 5,
            description: "wazzzzzap",
            txtMiniScene: 1159,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:13,
            color: OrderCat.PINK_WOMAN,
            isWoman: true,
            nameRU: 'Петелька',
            nameENG: 'Foxy',
            level: 10,
            description: "wazzzzzap",
            txtMiniScene: 1166,
            isMiniScene: false
        };
        _arrCats.push(obj);

        obj = {
            id:14,
            color: OrderCat.WHITE_WOMAN,
            isWoman: true,
            nameRU: 'Синтетика',
            nameENG: 'Daizy',
            level: 9,
            description: "wazzzzzap",
            txtMiniScene: 1165,
            isMiniScene: false
        };
        _arrCats.push(obj);
    }

    public static function get arr():Array { return _arrCats; }

    public static function getCatObjById(id:int):Object {
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
