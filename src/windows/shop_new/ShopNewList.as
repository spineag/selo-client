/**
 * Created by andy on 9/5/17.
 */
package windows.shop_new {
import com.greensock.TweenMax;

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import utils.CButton;
import utils.CTextField;

public class ShopNewList {
    private var g:Vars = Vars.getInstance();
    private var _woSource:Sprite;
    private var _woShop:WOShopNew;
    private var _arrCurrent:Array;
    private var _mask:Sprite;
    private var _cont:Sprite;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _arrItems:Array;
    private var _shift:int;
    private var _maxShift:int;
    private var _isDecor:Boolean;
    private var _isAnim:Boolean;
    private var _txtPages:CTextField;
    private var _curPage:int;
    private var _maxPage:int;

    public function ShopNewList(s:Sprite, w:WOShopNew) {
        _woSource = s;
        _woShop = w;
        _mask = new Sprite();
        _mask.y = -676/2 + 171;
        _woSource.addChild(_mask);
        _cont = new Sprite();
        _mask.addChild(_cont);
        _isAnim = false;
        _arrItems = [];
        createArrows();

        _txtPages = new CTextField(120, 30, '0/0');
        _txtPages.setFormat(CTextField.BOLD18, 18, ManagerFilters.BROWN_COLOR);
        _txtPages.cacheIt = false;
        _txtPages.y = 325;
        _txtPages.x = -60;
        _woSource.addChild(_txtPages);
    }

    public function updateList(ar:Array):void {
        _isDecor = g.user.shopTab == WOShopNew.DECOR;
        clearItems();
        if (_isDecor) {
            _mask.x = -988/2 + 81 + 160 + 7;
            _mask.mask = new Quad(663, 452 + 50);
        } else {
            _mask.x = -988/2 + 81;
            _mask.mask = new Quad(830, 452 + 50);
        }
        _shift = 0;
        _cont.x = 0;
        fillItems(ar);
        checkArrows();
    }

    private function clearItems():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            if (_cont.contains((_arrItems[i] as ShopNewListItem).source)) _cont.removeChild((_arrItems[i] as ShopNewListItem).source);
            (_arrItems[i] as ShopNewListItem).deleteIt();
        }
        _arrItems.length = 0;
    }

    private function fillItems(ar:Array):void {
        _arrCurrent = ar;
        var c:int;
        if (_isDecor) c = 4; else c = 5;
        var p1:int;
        var item:ShopNewListItem;
        for (var i:int=0; i<ar.length; i++) {
            item = new ShopNewListItem(ar[i], Math.ceil(i/(2*c)), i%(2*c), _woShop);
            p1 = int(i/c);
            if (p1%2) item.source.y = 216 + 17;
            else item.source.y = 1;
            item.source.x = (i%c)*167 + 167*c * int(i/(2*c));
            _cont.addChild(item.source);
            _arrItems.push(item);
        }
        p1 = ar.length%(2*c);
        if (p1 > c) p1 = c;
        _maxShift = int(ar.length/(2*c))*c + p1;
        if (_maxShift == p1) _maxShift = 0;
        if (_isDecor) {
            _maxPage = int(_arrItems.length/8);
            if (_arrItems.length%8) _maxPage++;
        } else {
            _maxPage = int(_arrItems.length/10);
            if (_arrItems.length%10) _maxPage++;
        }
    }

    private function createArrows():void {
        _leftArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.alignPivot();
        _leftArrow.addChild(im);
        _leftArrow.clickCallback = onClickLeft;
        _leftArrow.x = -988/2 + 36;
        _leftArrow.y = -676/2 + 397;
        _woSource.addChild(_leftArrow);

        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX = -1;
        im.alignPivot();
        _rightArrow.addChild(im);
        _rightArrow.clickCallback = onClickRight;
        _rightArrow.x = 988/2 - 36;
        _rightArrow.y = -676/2 + 397;
        _woSource.addChild(_rightArrow);
    }

    private function onClickLeft():void {
        if (_isAnim) return;
        if (_curPage <= 1) return;
        _isAnim = true;
        if (_isDecor) _shift = _shift - 4;
            else _shift = _shift - 5;
        if (_shift < 0) _shift = 0;
        TweenMax.to(_cont, .3, {x: -_shift * 167, onComplete: function():void { _isAnim = false;  checkArrows(); }});
    }

    private function onClickRight():void {
        if (_isAnim) return;
        if (_curPage >= _maxPage) return;
        _isAnim = true;
        if (_isDecor) _shift = _shift + 4;
        else _shift = _shift + 5;
        if (_shift > _maxShift) _shift = _maxShift;
        TweenMax.to(_cont, .3, {x: -_shift * 167, onComplete: function():void { _isAnim = false;   checkArrows(); }});
    }

    private function checkArrows():void {
        if (_maxShift == 0) _rightArrow.visible = _leftArrow.visible = false;
        else {
            _leftArrow.visible = _shift > 0;
            _rightArrow.visible = _shift < _maxShift;
        }
       updateTxtPages();
    }

    private function updateTxtPages():void {
        if (_isDecor) {
            _curPage = int(_shift/4) + 1;
            if (_shift%4) _curPage++;
        } else {
            _curPage = int(_shift/5) + 1;
            if (_shift%5) _curPage++;
        }
        _txtPages.text = String(_curPage) + "/" + String(_maxPage);
    }

    public function openOnResource(id:int):void {
        for (var i:int=0; i<_arrItems.length; i++) {
            if ((_arrItems[i] as ShopNewListItem).id == id) {
                if (_isDecor) _shift = 4*(_arrItems[i] as ShopNewListItem).pageNumber;
                else _shift = 5*(_arrItems[i] as ShopNewListItem).pageNumber;
                _cont.x = -_shift*167;
                return;
            }
        }
    }

    public function getShopItemBounds(id:int):Object {
        for (var i:int=0; i<_arrItems.length; i++) {
            if ((_arrItems[i] as ShopNewListItem).id == id) {
                if (_isDecor) _shift = 4*((_arrItems[i] as ShopNewListItem).pageNumber -1);
                else _shift = 5*((_arrItems[i] as ShopNewListItem).pageNumber -1);
                _cont.x = -_shift*167;
                return (_arrItems[i] as ShopNewListItem).itemBounds;
            }
        }
        return null;
    }

    public function addItemArrow(id:int, t:int):void {
        for (var i:int=0; i<_arrItems.length; i++) {
            if ((_arrItems[i] as ShopNewListItem).id == id) {
                (_arrItems[i] as ShopNewListItem).addArrow(t);
                return;
            }
        }
    }

    public function addArrowAtPos(n:int, t:int):void {
        var arShift:int;
        if (_isDecor) arShift = _shift*4*2 + n;
        else arShift = _shift*5*2 + n;
        (_arrItems[arShift] as ShopNewListItem).addArrow(t);
    }

    public function deleteAllArrows():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            (_arrItems[i] as ShopNewListItem).deleteArrow();
        }
    }
    
    public function deleteIt():void {
        if (!_mask) return;
        clearItems();
        _woSource.removeChild(_leftArrow);
        _leftArrow.deleteIt();
        _woSource.removeChild(_rightArrow);
        _rightArrow.deleteIt();
        _woSource.removeChild(_mask);
        _woShop = null;
        _woSource = null;
        _mask.dispose();
        _mask = null;
    }
}
}
