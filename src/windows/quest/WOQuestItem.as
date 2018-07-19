/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import starling.display.Sprite;

public class WOQuestItem {
    private var _source:Sprite;
    private var _parent:Sprite;
    private var _arItems:Array;

    public function WOQuestItem(p:Sprite, ar:Array) {
        _parent = p;
        _source = new Sprite();
        _source.x = -285;
        _source.y = 12;
        _parent.addChild(_source);

        _arItems = [];
        var c:int = ar.length;
        var it:Item;
        for (var i:int=0; i<c; i++) {
            it = new Item(c, ar[i]);
            _source.addChild(it);
            _arItems.push(it);
        }
        switch (c) {
            case 1: _arItems[0].y = 40; break;
            case 2: _arItems[0].y = 40; _arItems[1].y = 120; break;
            case 3: _arItems[0].y = 40; _arItems[1].y = 120; _arItems[2].y = 200; break;
        }
    }

    public function deleteIt():void {
        for (var i:int=0; i<_arItems.length; i++) {
            _source.removeChild(_arItems[i]);
            _arItems[i].deleteIt();
        }
        _arItems = [];
        _parent.removeChild(_source);
        _parent = null;
        _source.dispose();
    }
}
}

import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;

import quest.ManagerQuest;
import quest.ManagerQuest;
import quest.QuestTaskStructure;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.BackgroundQuest;

import windows.WOComponents.BackgroundQuestDone;
import windows.WOComponents.BackgroundWhiteIn;
import windows.WOComponents.BackgroundYellowOut;

internal class Item extends Sprite {
    private var g:Vars = Vars.getInstance();
    private var _task:QuestTaskStructure;
    private var _bg:BackgroundQuest;
    private var _bgDone:BackgroundQuestDone;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txt:CTextField;
    private var _countTxt:CTextField;
    private var _c:int;
    private var _galo4ka:Image;

    public function Item(c:int, t:QuestTaskStructure) {
        _task = t;
        _c = c;
        if (_task.isDone) {
            _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
            MCScaler.scale(_galo4ka, 50, 50);
            _galo4ka.alignPivot();
            _galo4ka.x = 510;
            _galo4ka.y = -10;
        } else {
            _btn = new CButton();
            _btn.addButtonTexture(120, CButton.HEIGHT_55, CButton.GREEN, true);
            _btn.addTextField(120, 51, -2, -5, String(g.managerLanguage.allTexts[312]));
            _btn.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
            _btn.x = 505;
            _btn.y = -5;
            _countTxt = new CTextField(60, 40, '');
            _countTxt.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR);
            _countTxt.x = 232;
            _countTxt.y = -14;
        }
        if (_task.isDone) {
            _bgDone = new BackgroundQuestDone(570, 70);
            _bgDone.touchable = false;
            _bgDone.y = -_bgDone.height/2;
            addChild(_bgDone);
        } else {
            _bg = new BackgroundQuest(570, 70);
            _bg.touchable = false;
            _bg.y = -_bg.height/2;
            addChild(_bg);
        }
            _txt = new CTextField(350, 60, _task.description);
            _txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
            _txt.x = 85;
            _txt.y = -42;


        switch (_task.typeAction) {
            case ManagerQuest.ADD_LEFT_MENU:
                break;
            case ManagerQuest.ADD_TO_GROUP:
                break;
            case ManagerQuest.POST:
                break;
            case ManagerQuest.CRAFT_PLANT:
                _txt.text = String(g.managerLanguage.allTexts[1525]) + ' ' + g.allData.getResourceById(_task.resourceId).name;
                break;
            case ManagerQuest.RAW_PLANT:
                _txt.text = String(g.managerLanguage.allTexts[1678]) + ' ' + g.allData.getResourceById(_task.resourceId).name;
                break;
            case ManagerQuest.BUILD_BUILDING:
                _txt.text = String(g.managerLanguage.allTexts[1682]) + ' ' + g.allData.getBuildingById(_task.resourceId).name;
                break;
            case ManagerQuest.RAW_PRODUCT:
                _txt.text = String(g.managerLanguage.allTexts[1526]) + ' ' + g.allData.getResourceById(_task.resourceId).name;
                break;
            case ManagerQuest.INVITE_FRIENDS:
                break;
            case ManagerQuest.KILL_LOHMATIC:
                break;
            case ManagerQuest.CRAFT_PRODUCT:
                _txt.text = _task.description +' ' + g.allData.getResourceById(_task.resourceId).name;
                break;
            case ManagerQuest.RELEASE_ORDER:
                _txt.text = String(g.managerLanguage.allTexts[1676]);
                break;
            case ManagerQuest.BUY_ANIMAL:
                _txt.text = String(g.managerLanguage.allTexts[1677]) + ' ' + g.allData.getAnimalById(_task.resourceId).name;
                break;
            case ManagerQuest.FEED_ANIMAL:
                _txt.text = String(g.managerLanguage.allTexts[1679]) + ' ' + g.allData.getAnimalById(_task.resourceId).name;
                break;
            case ManagerQuest.OPEN_TERRITORY:
                break;
            case ManagerQuest.BUY_PAPER:
                _txt.text = String(g.managerLanguage.allTexts[1680]);
                break;
            case ManagerQuest.SET_IN_PAPER:
                _txt.text = String(g.managerLanguage.allTexts[1675]);
                break;
            case ManagerQuest.REMOVE_WILD:
                _txt.text = String(g.managerLanguage.allTexts[1681]) + ' ' + g.allData.getBuildingById(_task.resourceId).name;
                break;
            case ManagerQuest.KILL_MOUSE:
                break;
            case ManagerQuest.NIASH_BUYER:
                    _txt.text = String(g.managerLanguage.allTexts[1674]);
                break;
            case ManagerQuest.OPEN_BUILD:
                _txt.text = String(g.managerLanguage.allTexts[1682]) + ' ' + g.allData.getBuildingById(_task.resourceId).name;
                break;
            case ManagerQuest.CRAFT_TREE:
                break;
        }
        _txt.touchable = false;

        addChild(_txt);
        if (_countTxt) {
            _countTxt.text = String(_task.countDone) + '/' + String(_task.countNeed);
            _countTxt.touchable = false;
            addChild(_countTxt);
        }

        if (_btn) {
            addChild(_btn);
            _btn.clickCallback = onClick;
            if (_task.typeAction == ManagerQuest.POST) {
                _btn.text = g.managerLanguage.allTexts[291];
                _countTxt.visible = false;
            } else if (_task.typeAction == ManagerQuest.ADD_LEFT_MENU) {
                _btn.text = g.managerLanguage.allTexts[624];
                _countTxt.visible = false;
            } else if (_task.typeAction == ManagerQuest.INVITE_FRIENDS) {
                _btn.text = g.managerLanguage.allTexts[415];
                _countTxt.visible = false;
            } else if (_task.typeAction == ManagerQuest.ADD_TO_GROUP) {
                _btn.text = g.managerLanguage.allTexts[625];
                _countTxt.visible = false;
            }
        }
        if (_countTxt && _countTxt.visible) {
            _txt.y = -55;
        }
        if (_galo4ka) addChild(_galo4ka);
        var st:String = _task.icon;
        if (st == '0') {
            addIm(_task.iconImageFromAtlas);
        } else {
            g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
        }
    }

    private function onLoadIcon(bitmap:Bitmap):void {
        addIm(new Image(Texture.fromBitmap(bitmap)));
    }

    private function addIm(im:Image):void {
        if (!im) return;
//        if (_c == 1) {
            MCScaler.scale(im, 90, 90);
            im.alignPivot();
            im.x = 45;
            im.y = -5;
//        } else if (_c == 2) {
//            MCScaler.scale(im, 70, 70);
//            im.alignPivot();
//            im.x = 45;
//        } else {
//            MCScaler.scale(im, 50, 50);
//            im.alignPivot();
//            im.x = 30;
//        }
        im.touchable = false;
        addChild(im);
    }

    private function onClick():void {
        if (_task.typeAction == ManagerQuest.POST) _btn.clickCallback = null;
        g.managerQuest.checkOnClickAtWoQuestItem(_task);
    }

    public function deleteIt():void {
        if (_btn) {
//            removeChild(_btn);
            _btn.deleteIt();
        }
        if (_bg) {
            removeChild(_bg);
            _bg.deleteIt();
        } else {
            removeChild(_bgDone);
            _bgDone.deleteIt();
        }
        dispose();
    }
}
