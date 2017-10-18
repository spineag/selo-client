/**
 * Created by user on 10/1/15.
 */
package windows.lockedLand {
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;

import windows.WOComponents.BackgroundWhiteIn;
import windows.WindowsManager;

public class LockedLandItem {
    public var source:Sprite;
    private var _isGood:Boolean;
    private var g:Vars = Vars.getInstance();
    private var _id:int;
    private var _count:int;
    private var _iconCoins:Image;
    private var _galo4ka:Image;
    private var _bg:BackgroundWhiteIn;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtCount:CTextField;
    private var _txtCountAll:CTextField;
    private var _arrCTex:Array;

    public function LockedLandItem() {
        source = new Sprite();
    }

    public function fillWithCurrency(count:int):void {
        _iconCoins = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        _iconCoins.x = -25;
        _iconCoins.y = -50;
        source.addChild(_iconCoins);
        _txtCount = new CTextField(150,40,String(g.user.softCurrencyCount));
        if (g.user.softCurrencyCount >= count)_txtCount.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        else _txtCount.setFormat(CTextField.BOLD24, 24, ManagerFilters.RED_TXT_NEW, Color.WHITE);
        _txtCount.alignH = Align.LEFT;
        _txtCount.y = 40;
        source.addChild(_txtCount);

        _txtCountAll = new CTextField(150,40, '/ ' + String(count));
        _txtCountAll.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountAll.alignH = Align.LEFT;
        _txtCountAll.y = 40;
        source.addChild(_txtCountAll);
        _txtCount.x =  20 - (_txtCount.textBounds.width/2 + _txtCountAll.textBounds.width/2);
        _txtCountAll.x = _txtCount.x + _txtCount.textBounds.width;

        if (g.user.softCurrencyCount >= count) {
            _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
            _galo4ka.x = 5;
            _galo4ka.y = 80;
            source.addChild(_galo4ka);
            _galo4ka.filter = ManagerFilters.SHADOW_TINY;

            _isGood = true;
        } else {
            _btn = new CButton();
//            _btnOpen.addTextField(158, 41, 0, 0, String(g.managerLanguage.allTexts[418]));
//            _btnOpen.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR)
            _btn.addButtonTexture(135, CButton.HEIGHT_41, CButton.GREEN, true);
            _btn.addTextField(135, 35, 0, 0, String(g.managerLanguage.allTexts[355]));
            _btn.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
            source.addChild(_btn);
            _btn.x = 25;
            _btn.y = 105;
            var f1:Function = function ():void {
                g.windowsManager.hideWindow(WindowsManager.WO_LOCKED_LAND);
                g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, false);
            };
            _btn.clickCallback = f1;
            _isGood = false;
        }
    }

    public function fillWithResource(id:int, count:int):void {
        if (!g.allData.getResourceById(id)) {
            Cc.error('LockedLandItem fillWithResource:: g.dataResource.objectResources[id] == null for id: ' + id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'LockedLandItem');
            return;
        }
        var icon:Image;
        _id = id;
        _count = count;
        if (g.allData.getResourceById(id).buildType == BuildType.PLANT)
            icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(id).imageShop + '_icon'));
        else
            icon = new Image(g.allData.atlas[g.allData.getResourceById(id).url].getTexture(g.allData.getResourceById(id).imageShop));
        if (!icon) {
            Cc.error('LockedLandItem fillWithResource:: no such image: ' + g.allData.getResourceById(id).imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'lockedLandItem');
            return;
        }
        icon.x = -25;
        icon.y = -50;
        source.addChild(icon);
        _txtCount = new CTextField(150,40,String(g.userInventory.getCountResourceById(id)));
        if (g.userInventory.getCountResourceById(id) >= count)_txtCount.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        else _txtCount.setFormat(CTextField.BOLD24, 24, ManagerFilters.RED_TXT_NEW, Color.WHITE);
        _txtCount.alignH = Align.LEFT;
        _txtCount.y = 40;
        source.addChild(_txtCount);

        _txtCountAll = new CTextField(150,40, '/ ' + String(count));
        _txtCountAll.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountAll.alignH = Align.LEFT;
        _txtCountAll.y = 40;
        source.addChild(_txtCountAll);
        _txtCount.x =  20 - (_txtCount.textBounds.width/2 + _txtCountAll.textBounds.width/2);
        _txtCountAll.x = _txtCount.x + _txtCount.textBounds.width;

        if (g.userInventory.getCountResourceById(id) >= count) {
            _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
            _galo4ka.x = 5;
            _galo4ka.y = 80;
            _galo4ka.filter = ManagerFilters.SHADOW_TINY;
            source.addChild(_galo4ka);
            _isGood = true;
        } else {
            _btn = new CButton();
            _btn.addButtonTexture(135, CButton.HEIGHT_41, CButton.GREEN, true);
            _btn.setTextFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
            source.addChild(_btn);
            _txtBtn = new CTextField(120, 38, String(g.managerLanguage.allTexts[355]) + ' ' + String(g.allData.getResourceById(id).priceHard *(count - g.userInventory.getCountResourceById(id))));
            _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            MCScaler.scale(im,im.height-5,im.width-5);
            var sensi:SensibleBlock = new SensibleBlock();
            sensi.textAndImage(_txtBtn,im,135);
            _btn.addSensBlock(sensi,0,20);
            _btn.x = 25;
            _btn.y = 105;
            _btn.clickCallback = buyItem;
            _isGood = false;
        }
    }

    public function fillWithFriends(count:int):void {
        var icon:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_icon'));
        icon.x = 41 - icon.width/2;
        icon.y = 34 - icon.height/2;
        source.addChild(icon);
        _arrCTex = [];
        var txt:CTextField = new CTextField(150,40,'0/' +String(count));
        txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.x = -35;
        txt.y = 55;
        source.addChild(txt);
        _arrCTex.push(txt);
        txt = new CTextField(200,60,String(g.managerLanguage.allTexts[415]) + ' ' +String(count) + ' ' + String(g.managerLanguage.allTexts[416]));
        txt.setFormat(CTextField.BOLD18, 16, ManagerFilters.BROWN_COLOR);
        txt.x = 90;
        txt.y = 15;
        source.addChild(txt);
        _arrCTex.push(txt);
        if (0 > count) {
            _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
            _galo4ka.x = 351;
            _galo4ka.y = 31;
            _galo4ka.filter = ManagerFilters.SHADOW_TINY;
            source.addChild(_galo4ka);
            _isGood = true;
        } else {
            _btn = new CButton();
            _btn.addButtonTexture(120, 30, CButton.RED, true);
            txt = new CTextField(120,30,String(g.managerLanguage.allTexts[415]));
            txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.YELLOW_COLOR);
            _btn.addChild(txt);
            _btn.x = 362;
            _btn.y = 50;
            source.addChild(_btn);
            _arrCTex.push(txt);
            var f1:Function = function ():void {
                g.windowsManager.hideWindow(WindowsManager.WO_LOCKED_LAND);
                g.windowsManager.openWindow(WindowsManager.WO_INVITE_FRIENDS, null, false);
            };
            _btn.clickCallback = f1;
            _isGood = false;
        }
    }

    public function deleteIt():void {
        if (_iconCoins) _iconCoins.filter = null;
        if (_galo4ka) _galo4ka.filter = null;
        if (_arrCTex) {
            for (var i:int = 0; i < _arrCTex.length; i++) {
                _arrCTex[i].deleteIt();
                _arrCTex[i] = null;
            }
        }

        if (_txtCount) {
            source.removeChild(_txtCount);
            _txtCount.deleteIt();
            _txtCount = null;
        }
        if (_txtBtn) {
            _btn.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        if (_btn) {
            source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        source.dispose();
        source = null;
    }

    public function get isGood():Boolean {
        return _isGood;
    }

    private function buyItem():void {
        g.windowsManager.hideWindow(WindowsManager.WO_LOCKED_LAND);
        g.windowsManager.openWindow(WindowsManager.WO_BUY_FOR_HARD, null,'lockedLand', _id, _count);
    }


}
}
