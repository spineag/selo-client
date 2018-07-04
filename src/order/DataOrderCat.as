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
            nameRU: 'Тим',
            nameENG: 'Tim',
            level: 6,
            color: OrderCat.BLACK_MAN,
            isWoman: false,
            description: "wazzzzzap",
            txtMiniScene: 1160,
            isMiniScene: false,
            animation: 'animations_json/cat_quest_m',
            animationName: 'cat_timmy',
            namePng: 'cat_order/black_cat_m_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:2,
            nameRU: 'Молли',
            nameENG: 'Molly',
            level: 6,
            color: OrderCat.BLACK_MAN,
            isWoman: false,
            description: "wazzzzzap",
            txtMiniScene: 1160,
            isMiniScene: false,
            animation: 'animations_json/cat_molly_q',
            animationName: 'cat_molly',
            namePng: 'cat_order/black_cat_m_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:3,
            nameRU: 'Узелок',
            nameENG: 'Sam',
            level: 6,
            color: OrderCat.BLACK_MAN,
            isWoman: false,
            description: "wazzzzzap",
            txtMiniScene: 1160,
            isMiniScene: false,
            animation: 'animations_json/uzelok_cat_q',
            animationName: 'cat_sam',
            namePng: 'cat_order/black_cat_m_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:4,
            nameRU: 'Стежок',
            nameENG: 'Felix',
            level: 4,
            color: OrderCat.BLUE_MAN,
            isWoman: false,
            description: "wazzzzzap",
            txtMiniScene: 1158,
            isMiniScene: false,
            animation: 'animations_json/felix_cat',
            animationName: 'cat_felix',
            namePng: 'cat_order/blue_cat_m_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:5,
            color: OrderCat.GREEN_MAN,
            isWoman: false,
            nameRU: 'Крючок',
            nameENG: 'Martin',
            level: 6,
            description: "wazzzzzap",
            txtMiniScene: 1161,
            isMiniScene: false,
            animation: 'animations_json/martin_cat_q',
            animationName: 'cat_martin',
            namePng: 'cat_order/green_cat_m_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:6,
            color: OrderCat.BROWN_MAN,
            isWoman: false,
            nameRU: 'Ирис',
            nameENG: 'Ozzy',
            level: 10,
            description: "wazzzzzap",
            txtMiniScene: 1167,
            isMiniScene: false,
            animation: 'animations_json/ozzy_cat_q',
            animationName: 'cat_ozzy',
            namePng: 'cat_order/brown_cat_m_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:7,
            color: OrderCat.ORANGE_MAN,
            isWoman: false,
            nameRU: 'Наперсток',
            nameENG: 'Tom',
            level: 22,
            description: "wazzzzzap",
            txtMiniScene: 1168,
            isMiniScene: false,
            animation: 'animations_json/tom_cat_q',
            animationName: 'cat_tom',
            namePng: '/cat_order/orange_cat_m_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:8,
            color: OrderCat.PINK_MAN,
            isWoman: false,
            nameRU: 'Акрил',
            nameENG: 'Mark',
            level: 8,
            description: "wazzzzzap",
            txtMiniScene: 1164,
            isMiniScene: false,
            animation: 'animations_json/mark_cat_q',
            animationName: 'cat_mark',
            namePng: 'cat_order/pink_cat_m_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:9,
            color: OrderCat.WHITE_MAN,
            isWoman: false,
            nameRU: 'Ажур',
            nameENG: 'Kevin',
            level: 32,
            description: "wazzzzzap",
            txtMiniScene: 1170,
            isMiniScene: false,
            animation: 'animations_json/kevin_cat_q',
            animationName: 'cat_kevin',
            namePng: 'cat_order/white_cat_m_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:10,
            color: OrderCat.BLACK_WOMAN,
            isWoman: true,
            nameRU: 'Иголочка',
            nameENG: 'Cora',
            level: 22,
            description: "wazzzzzap",
            txtMiniScene: 1169,
            isMiniScene: false,
            animation: 'animations_json/cora_cat_q',
            animationName: 'cat_cora',
            namePng: 'cat_order/black_cat_w_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:11,
            color: OrderCat.BLUE_WOMAN,
            isWoman: true,
            nameRU: 'Ленточка',
            nameENG: 'Ivie',
            level: 7,
            description: "wazzzzzap",
            txtMiniScene: 1162,
            isMiniScene: false,
            animation: 'animations_json/ivie_cat_q',
            animationName: 'cat_ivie',
            namePng: 'cat_order/blue_cat_w_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:12,
            color: OrderCat.GREEN_WOMAN,
            isWoman: true,
            nameRU: 'Пряжа',
            nameENG: 'Akira',
            level: 8,
            description: "wazzzzzap",
            txtMiniScene: 1163,
            isMiniScene: false,
            animation: 'animations_json/akira_cat_q',
            animationName: 'cat_akira',
            namePng: 'cat_order/green_cat_w_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:13,
            color: OrderCat.BROWN_WOMAN,
            isWoman: true,
            nameRU: 'Булавка',
            nameENG: 'Lexy',
            level: 4,
            description: "wazzzzzap",
            txtMiniScene: 1157,
            isMiniScene: false,
            animation: 'animations_json/lexy_cat',
            animationName: 'cat_lexy',
            namePng: 'cat_order/brown_cat_w_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:14,
            color: OrderCat.ORANGE_WOMAN,
            isWoman: true,
            nameRU: 'Бусинка',
            nameENG: 'Dixie',
            level: 5,
            description: "wazzzzzap",
            txtMiniScene: 1159,
            isMiniScene: false,
            animation: 'animations_json/dexie_cat_q',
            animationName: 'cat_dixie',
            namePng: 'cat_order/orange_cat_w_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:15,
            color: OrderCat.PINK_WOMAN,
            isWoman: true,
            nameRU: 'Петелька',
            nameENG: 'Foxy',
            level: 10,
            description: "wazzzzzap",
            txtMiniScene: 1166,
            isMiniScene: false,
            animation: 'animations_json/foxy_cat_q',
            animationName: 'cat_foxy',
            namePng: 'cat_order/pink_cat_w_window.png',
            txtId: 1
        };
        _arrCats.push(obj);

        obj = {
            id:16,
            color: OrderCat.WHITE_WOMAN,
            isWoman: true,
            nameRU: 'Синтетика',
            nameENG: 'Daizy',
            level: 9,
            description: "wazzzzzap",
            txtMiniScene: 1165,
            isMiniScene: false,
            animation: 'animations_json/daisy_cat_q',
            animationName: 'cat_daizy',
            namePng: 'cat_order/white_cat_w_window.png',
            txtId: 1
        };
        _arrCats.push(obj);
    }

    public static function get arr():Array { return _arrCats; }

    public static function getCatObjById(id:int):Object {
        for (var i:int=0; i<_arrCats.length; i++) {
            if (_arrCats[i].id == id)  return _arrCats[i];
        }
        return {};
    }
    
    public static function getArrByLevel(l:int):Array {
        var ar:Array = new Array();
        for (var i:int=0; i<_arrCats.length; i++) {
            if (_arrCats[i].level <= l) ar.push(_arrCats[i]);
        }
        return ar;
    }

    public static function setCatObjByTxtId(id:int, txtId:int):void {
        for (var i:int=0; i<_arrCats.length; i++) {
            if (_arrCats[i].id == id)  {
                _arrCats[i].txtId = txtId;
            }
        }
    }
}
}
