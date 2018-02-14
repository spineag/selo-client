/**
 * Created by user on 12/15/17.
 */
package windows.levelUp {
import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;

import data.StructureDataBuilding;

import data.StructureDataResource;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import resourceItem.newDrop.DropObject;

import starling.display.Image;
import starling.utils.Align;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WindowsManager;

public class WOLevelUpGift {
    public var source:CSprite;
    public var widthSource:int;
    private var _txtCount:CTextField;
    private var _imItem:Image;
    private var g:Vars = Vars.getInstance();
    private var _data:Object;
    private var _onHover:Boolean;

    public function WOLevelUpGift(ob:Object, boNew:Boolean, boCount:Boolean, count:int = 0, wallNew:Boolean = false) {
        if (!ob) {
            Cc.error('WOLevelUpItem:: ob == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woLevelUpItem');
            return;
        }
        var d:DropObject;
        var p:Point;
        source = new CSprite();
        _txtCount = new CTextField(80,20,' ');
        _txtCount.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtCount.cacheIt = false;
        _txtCount.alignH = Align.LEFT;
        _txtCount.x = 37;
        _txtCount.y = 3;

        if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && ob.coins) {
            _imItem = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
            MCScaler.scale(_imItem, 40, 40);
            _txtCount.text = String(ob.countSoft);
            d = new DropObject();
            p = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
            p = _imItem.localToGlobal(p);
            d.addDropMoney(DataMoney.SOFT_CURRENCY, ob.countSoft, p);
            d.releaseIt(null, false);

        }
        if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding) && ob.hard) {
            _imItem = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            MCScaler.scale(_imItem, 40, 40);
            _txtCount.text = String(ob.countHard);
            d = new DropObject();
            p = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
            p = _imItem.localToGlobal(p);
            d.addDropMoney(DataMoney.HARD_CURRENCY, ob.countHard, p);
//            g.userInventory.addMoney(1,ob.countHard)
            d.releaseIt(null, false);
        }
        
        if (!(ob is StructureDataResource) && !(ob is StructureDataBuilding)&& ob.resourceData) {
            if (g.allData.getResourceById(ob.id).buildType == BuildType.PLANT) {
                _imItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(ob.id).imageShop + '_icon'));
            } else {
                _imItem = new Image(g.allData.atlas[g.allData.getResourceById(ob.id).url].getTexture(g.allData.getResourceById(ob.id).imageShop));
            }
            MCScaler.scale(_imItem, 40, 40);
            if (g.user.level == 2) _txtCount.text = String(4);
                else _txtCount.text = String(ob.count);
            if (g.allData.getResourceById(ob.id).buildType != BuildType.PLANT) g.userInventory.addResource(ob.id,ob.count);
            _onHover = false;
            _data = g.allData.getResourceById(ob.id);
            source.hoverCallback = onHover;
            source.outCallback = onOut;
            _imItem.y = -5;
        }

        source.addChild(_txtCount);
        widthSource = 50 + _txtCount.textBounds.width;
        if (_imItem) {
//            MCScaler.scale(_imItem, 40, 40);
            source.addChild(_imItem);
            if (!wallNew) source.addChild(_txtCount);
        } else {
            Cc.error('WOLevelUpItem:: no such image: ' + count);
        }
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        g.hint.showIt(String(_data.name));
    }

    private function onOut():void {
        _onHover = false;
        g.hint.hideIt();
    }

    public function deleteIt():void {
        source.deleteIt();
        _imItem = null;
        source = null;
    }
}
}
