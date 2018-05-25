/**
 * Created by user on 1/20/17.
 */
package windows.questAward {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.ManagerFilters;

import quest.ManagerQuest;
import quest.QuestStructure;

import resourceItem.newDrop.DropObject;

import starling.display.Image;
import starling.display.Quad;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.Utils;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOQuestFinishAward extends WindowMain {
    private var _btn:CButton;
    private var _quest:QuestStructure;
    private var _items:Array;
    private var _callback:Function;
    private var _questIcon:Image;

    public function WOQuestFinishAward() {
        super();
        _windowType = WindowsManager.WO_QUEST_AWARD;
        _woWidth = 650;
        _woHeight = 300;
        var im:Image = new Image(g.allData.atlas['questAtlas'].getTexture('end_quest'));
        im.x = -210;
        im.y = -195;
        im.touchable = false;
        _source.addChild(im);
        var txt:CTextField = new CTextField(200, 100, g.managerLanguage.allTexts[626]);
        txt.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = 58 - txt.textBounds.width/2;
        txt.y = -155;
        _source.addChild(txt);

        _btn = new CButton();
        _btn.addButtonTexture(130, 40, CButton.GREEN, true);
        _btn.clickCallback = onClick;
        _btn.y = 72;
        _btn.x = 60;
        _source.addChild(_btn);
        txt = new CTextField(130, 40, g.managerLanguage.allTexts[328]);
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(txt);

        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
    }

    override public function showItParams(f:Function, params:Array):void {
        _callback = f;
        if (params.length && params[0] is QuestStructure) {
            _quest = params[0] as QuestStructure;
        } else {
            Cc.error('WOQuestFinishAward showItParams:: no quest in params');
        }
        _items = [];
        var it:Item;
        var aw:Array = _quest.awards;
        for (var i:int = 0; i < aw.length; i++) {
            it = new Item(aw[i]);
            it.y = -35;
            _source.addChild(it);
            _items.push(it);
        }
        switch (_items.length) {
            case 1:
                _items[0].x = 60;
                break;
            case 2:
                _items[0].x = 0;
                _items[1].x = 120;
                break;
            case 3:
                _items[0].x = -20;
                _items[1].x = 60;
                _items[2].x = 140;
                break;
        }
        var txt:CTextField = new CTextField(400, 100, String(_quest.questName));
        txt.setFormat(CTextField.BOLD30, 26, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        txt.alignH = Align.LEFT;
        txt.x = 58 - txt.textBounds.width/2;
        txt.y = -210;
        _source.addChild(txt);
        super.showIt();
        var st:String = _quest.iconPath;
        if (st == '0') {
            st = _quest.getUrlFromTask();
            if (st == '0') {
                addIm(_quest.iconImageFromAtlas());
            } else {
                g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
            }
        } else {
            g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
        }
        Cc.info("woQuest showItParams 7");
    }

    private function onClick():void { onClickExit(); }
    private function onLoadIcon(bitmap:Bitmap):void { addIm(new Image(Texture.fromBitmap(bitmap))); }

    private function addIm(im:Image):void {
        _questIcon = im;
        if (_questIcon) {
            MCScaler.scale(_questIcon, 146, 146);
            _questIcon.alignPivot();
            _questIcon.x = -250;
            _questIcon.y = -60;
            _source.addChild(_questIcon);
        }
    }

    private function onClickExit():void {
        var d:DropObject = new DropObject();
        for (var i:int=0; i<_items.length; i++) {
            (_items[i] as Item).flyIt(d);
        }
        d.releaseIt(null, false);
        _items.length = 0;
        if (_callback != null) {
            _callback.apply(null, [_quest]);
            _callback = null;
        }
        Utils.createDelay(.5, super.hideIt);
    }

    override protected function deleteIt():void { super.deleteIt(); }
}
}

import data.DataMoney;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import quest.QuestAwardStructure;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CTextField;
import utils.MCScaler;

internal class Item extends Sprite {
    private var g:Vars = Vars.getInstance();
    private var _aw:QuestAwardStructure;
    private var im:Image;
    private var _txt:CTextField;
    private var _source:Sprite;

    public function Item(aw:QuestAwardStructure) {
        _source = new Sprite();
        _aw = aw;
        _txt = new CTextField(60, 30, String(_aw.countResource));
        _txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -30;
        _txt.y = 35;
        addChild(_txt);

        if (_aw.typeResource == 'money') {
            switch (_aw.idResource) {
                case DataMoney.SOFT_CURRENCY: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins')); break;
                case DataMoney.HARD_CURRENCY: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins')); break;
                case DataMoney.BLUE_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone')); break;
                case DataMoney.RED_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone')); break;
                case DataMoney.GREEN_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone')); break;
                case DataMoney.YELLOW_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone')); break;
            }
        } else if (_aw.typeResource == 'resource') {
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_aw.idResource).imageShop));
        } else if (_aw.typeResource == 'plant') {
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_aw.idResource).imageShop + '_icon'));
        } else if (_aw.typeResource == 'decor') {
            im = new Image(g.allData.atlas['decorAtlas'].getTexture(g.allData.getResourceById(_aw.idResource).image));
        } else if (_aw.typeResource == 'instrument') {
            im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(_aw.idResource).imageShop));
        } else if (_aw.typeResource == 'xp') {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("xp_icon"));
        }

        if (im) {
            MCScaler.scale(im, 70, 70);
            im.alignPivot();
            addChild(im);
        }
    }

    private function deleteIt():void {
        if (_txt) {
            removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        if (_source) _source.dispose();
    }

    public function flyIt(d:DropObject):void {
        var p:Point = new Point();
        p = _source.localToGlobal(p);
        if (_aw.typeResource == 'money')
            d.addDropMoney(_aw.idResource, _aw.countResource, p);
        else if (_aw.typeResource == 'decor')
            d.addDropDecor(g.allData.getBuildingById(_aw.idResource), p, _aw.countResource);
        else if (_aw.typeResource == 'xp')
            d.addDropXP(_aw.countResource, p);
        else d.addDropItemNewByResourceId(_aw.idResource, p, _aw.countResource);
        deleteIt();
    }

}
