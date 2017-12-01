/**
 * Created by andy on 9/22/17.
 */
package windows.paper_new {
import com.junkbyte.console.Cc;

import data.BuildType;

import data.StructureDataResource;
import data.StructureMarketItem;
import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import user.Someone;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class WOPaperNewItem {
    private var g:Vars = Vars.getInstance();
    private var _data:StructureMarketItem;
    private var _source:CSprite;
    private var _txtSellerName:CTextField;
    private var _txtResourceName:CTextField;
    private var _txtCountResource:CTextField;
    private var _txtPrice:CTextField;
    private var _txtClick:CTextField;
    private var _ava:Image;
    private var _personSeller:Someone;
    private var _helpIcon:Image;
    private var _ramka:Image;
    private var _wo:WOPaperNew;
    private var _dataResource:StructureDataResource;

    public function WOPaperNewItem(ob:StructureMarketItem, wo:WOPaperNew) {
        _data = ob;
        _wo = wo;
        _dataResource = g.allData.getResourceById(_data.resourceId);
        _source = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_cell'));
        _source.addChild(im);

        _txtSellerName = new CTextField(131, 48, "");
        _txtSellerName.setFormat(CTextField.BOLD24, 21, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txtSellerName.alignH = Align.LEFT;
        _txtSellerName.x = 90;
        _txtSellerName.y = 17;
        _source.addChild(_txtSellerName);
        _txtResourceName = new CTextField(135, 34, _dataResource.name);
        _txtResourceName.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
        _txtResourceName.alignH = Align.RIGHT;
        _txtResourceName.x = 88;
        _txtResourceName.y = 88;
        _source.addChild(_txtResourceName);
        _txtCountResource = new CTextField(45, 22, 'x' + String(_data.resourceCount));
        _txtCountResource.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_LIGHT_NEW);
        _txtCountResource.alignH = Align.RIGHT;
        _txtCountResource.x = 68;
        _txtCountResource.y = 143;
        _source.addChild(_txtCountResource);
        _txtPrice = new CTextField(69, 28, String(_data.cost));
        _txtPrice.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW);
        _txtPrice.alignH = Align.RIGHT;
        _txtPrice.x = 118;
        _txtPrice.y = 130;
        _source.addChild(_txtPrice);
        _txtClick = new CTextField(222, 28, "Visit market");
        _txtClick.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txtClick.x = 9;
        _txtClick.y = 184;
        _source.addChild(_txtClick);

        if (_dataResource.buildType == BuildType.PLANT) im = new Image(g.allData.atlas['resourceAtlas'].getTexture(_dataResource.imageShop + '_icon'));
        else im = new Image(g.allData.atlas[_dataResource.url].getTexture(_dataResource.imageShop));
        im.alignPivot();
        MCScaler.scale(im, 80, 80);
        im.x = 57;
        im.y = 122;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        MCScaler.scale(im, 30, 30);
        im.x = 195;
        im.y = 131;
        _source.addChild(im);
        updatePersonInfo();
        _ramka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_friend_panel'));
        MCScaler.scale(_ramka, 74, 70);
        _ramka.x = 6;
        _ramka.y = 5;
        _source.addChild(_ramka);
        if (_data.needHelp > 0) {
            _helpIcon = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
//            MCScaler.scale(_helpIcon, 25, 25);
            _helpIcon.x = 205;
            _helpIcon.y = 2;
            _source.addChild(_helpIcon);
        }
        _source.endClickCallback = onClickVisit;
        if (_data.isOpened) _source.alpha = .5;
    }

    public function get source():CSprite { return _source; }

    public function updatePersonInfo():void {
        _personSeller = g.user.getSomeoneBySocialId(_data.userSocialId);
        if (_personSeller.photo) {
            if (_ava) return;
            _txtSellerName.text = _personSeller.name + ' ' + _personSeller.lastName;
            g.load.loadImage(_personSeller.photo, onLoadPhoto);
        } else {
            var arr:Array = new Array();
            arr.push(String(g.managerLanguage.allTexts[628]));
            arr.push(String(g.managerLanguage.allTexts[629]));
            arr.push(String(g.managerLanguage.allTexts[630]));
            arr.push(String(g.managerLanguage.allTexts[631]));
            arr.push(String(g.managerLanguage.allTexts[632]));
            arr.push(String(g.managerLanguage.allTexts[633]));
            arr.push(String(g.managerLanguage.allTexts[634]));
            arr.push(String(g.managerLanguage.allTexts[635]));
            arr.push(String(g.managerLanguage.allTexts[636]));
            arr.push(String(g.managerLanguage.allTexts[637]));
            arr.push(String(g.managerLanguage.allTexts[638]));
            arr.push(String(g.managerLanguage.allTexts[639]));
            arr.push(String(g.managerLanguage.allTexts[640]));
            arr.push(String(g.managerLanguage.allTexts[641]));
            arr.push(String(g.managerLanguage.allTexts[642]));
            arr.push(String(g.managerLanguage.allTexts[643]));
            arr.push(String(g.managerLanguage.allTexts[644]));
            arr.push(String(g.managerLanguage.allTexts[645]));
            arr.push(String(g.managerLanguage.allTexts[646]));
            arr.push(String(g.managerLanguage.allTexts[647]));
            arr.push(String(g.managerLanguage.allTexts[648]));
            arr.push(String(g.managerLanguage.allTexts[649]));
            arr.push(String(g.managerLanguage.allTexts[650]));
            arr.push(String(g.managerLanguage.allTexts[651]));
            arr.push(String(g.managerLanguage.allTexts[652]));
            arr.push(String(g.managerLanguage.allTexts[653]));
            arr.push(String(g.managerLanguage.allTexts[654]));
            arr.push(String(g.managerLanguage.allTexts[655]));
            arr.push(String(g.managerLanguage.allTexts[656]));
            arr.push(String(g.managerLanguage.allTexts[657]));

            _txtSellerName.text = String(arr[int(Math.random()*arr.length-1)]);
        }
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!_source) return;
        if (!bitmap) bitmap = g.pBitmaps[_personSeller.photo].create() as Bitmap;
        if (!bitmap) { Cc.error('WOPapperItem:: no photo for userId: ' + _personSeller.userSocialId); return; }
        _ava = new Image(Texture.fromBitmap(bitmap));
        _ava.x = 13;
        _ava.y = 11;
        MCScaler.scale(_ava, 56, 56);
        _source.addChildAt(_ava, 1);
    }

    private function onClickVisit():void {
        if (!_data) return;
        _data.isOpened = true;
        _source.alpha = .5;
        _ramka.alpha = .7;
        g.windowsManager.cashWindow = _wo;
        _wo.hideIt();
        _personSeller.idVisitItemFromPaper = _data.resourceId;
        _personSeller.level = _data.level;
        _personSeller.userId = _data.userId;
        g.windowsManager.openWindow(WindowsManager.WO_MARKET, null, _personSeller);
    }

    public function deleteIt():void {
        if (!_source) return;
        _wo = null;
        _data = null;
        _personSeller = null;
        _source.removeChild(_txtClick);
        _txtClick.deleteIt();
        _source.removeChild(_txtCountResource);
        _txtCountResource.deleteIt();
        _source.removeChild(_txtPrice);
        _txtPrice.deleteIt();
        _source.removeChild(_txtResourceName);
        _txtResourceName.deleteIt();
        _source.removeChild(_txtSellerName);
        _txtSellerName.deleteIt();
        _source.dispose();
        _source = null;
    }


}
}
