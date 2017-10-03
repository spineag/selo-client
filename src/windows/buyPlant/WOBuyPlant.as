/**
 * Created by user on 6/2/15.
 */
package windows.buyPlant {
import build.ridge.Ridge;

import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.StructureDataResource;

import flash.geom.Point;

import media.SoundConst;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

import tutorial.managerCutScenes.ManagerCutScenes;

import utils.CButton;

import windows.WOComponents.BackgroundPlant;

import windows.WOComponents.Birka;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyPlant extends WindowMain {
    private var _ridge:Ridge;
    private var _callback:Function;
    private var _bgPlant:BackgroundPlant;
    private var _shift:int;
    private var _arrPlantItems:Array;
    private var _arrAllPlants:Array;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _cont:Sprite;
    private var _mask:Sprite;
    private var _isAnim:Boolean;

    public function WOBuyPlant() {
        super();
        _blackAlpha = 0;
        _isAnim = false;
        _arrAllPlants = [];
        _arrPlantItems = [];
        _windowType = WindowsManager.WO_BUY_PLANT;
        _woWidth = 592;
        _woHeight = 120;
        _bgPlant = new BackgroundPlant(_woWidth, _woHeight);
        _bgPlant.x = -_woWidth/2;
        _bgPlant.y = -_woHeight/2;
        _source.addChild(_bgPlant);
        _callbackClickBG = onClickExit;
        _mask = new Sprite();
        _mask.mask = new Quad(_woWidth, _woHeight);
        _cont = new Sprite();
        _mask.addChild(_cont);
        _mask.x = -_woWidth/2;
        _mask.y = -_woHeight/2;
        _source.addChild(_mask);
        createArrows();
    }

    private function onClickExit(e:Event=null):void {
        if (g.tuts.isTuts) return;
        if (g.managerCutScenes.isCutScene) return;
        hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        _ridge = params[0];
        _callback = callback;
        fillPlantArray();
        fillPlantItems();
        checkArrows();
        super.showIt();
    }

    private function fillPlantArray():void {
        _arrAllPlants.length = 0;
        var arR:Array = g.allData.resource;
        for (var i:int = 0; i < arR.length; i++) {
            if (arR[i].buildType == BuildType.PLANT && arR[i].blockByLevel <= g.user.level + 1) {
//                if (arR[i].id != 168) _arrAllPlants.push(arR[i]);
//                else if (g.userTimer.partyToEndTimer > 0) _arrAllPlants.push(arR[i]);
                _arrAllPlants.push(arR[i]);
            }
        }
        _arrAllPlants.sortOn('blockByLevel', Array.NUMERIC);
    }

    private function fillPlantItems():void {
        var item:WOBuyPlantItem;
        for (var i:int=0; i<_arrAllPlants.length; i++) {
            item = new WOBuyPlantItem();
            item.setCoordinates(66 + i*116, 60);
            _cont.addChild(item.source);
            _arrPlantItems.push(item);
            item.fillData(_arrAllPlants[i], onClickItem);
        }
    }

    private function onClickItem(d:StructureDataResource, r:Ridge = null,calllback:Function = null):void {
        if (g.userInventory.getCountResourceById(d.id) <= 0) {
            var ob:Object = {};
            ob.data = d;
            ob.count = 1;
            ob.ridge = _ridge;
            ob.callback = _callback;
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClickItem, 'menu', ob);
            return;
        }
        if (!_ridge) _ridge = r;
        if (_callback == null) _callback = calllback;
        g.soundManager.playSound(SoundConst.CRAFT_RAW_PLANT);
        _ridge.fillPlant(d);
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
        super.hideIt();
    }

    private function createArrows():void {
        _leftArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plants_factory_arrow_red'));
        im.alignPivot();
        _leftArrow.addChild(im);
        _leftArrow.clickCallback = onClickLeft;
        _leftArrow.x = -_woWidth/2 - 25;
        _leftArrow.y = 0;
        _source.addChild(_leftArrow);

        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plants_factory_arrow_red'));
        im.scaleX = -1;
        im.alignPivot();
        _rightArrow.addChild(im);
        _rightArrow.clickCallback = onClickRight;
        _rightArrow.x = _woWidth/2 + 25;
        _rightArrow.y = 0;
        _source.addChild(_rightArrow);
    }

    private function onClickLeft():void {
        if (_isAnim) return;
        _shift -= 5;
        if (_shift < 0) _shift = 0;
        _isAnim = true;
        TweenMax.to(_cont, .3, {x: -_shift*116, onComplete: function():void {_isAnim = false; checkArrows();} });
    }

    private function onClickRight():void {
        if (_isAnim) return;
        _shift += 5;
        if (_shift > _arrPlantItems.length - 5) _shift = _arrPlantItems.length - 5;
        _isAnim = true;
        TweenMax.to(_cont, .3, {x: -_shift*116, onComplete: function():void {_isAnim = false; checkArrows();} });
    }

    private function checkArrows():void {
        _leftArrow.visible = _shift > 0;
        _rightArrow.visible = _shift < _arrPlantItems.length - 5;
    }

    override protected function deleteIt():void {
        if (!_source) return;
        for (var i:int = 0; i < _arrPlantItems.length; i++) {
            _source.removeChild(_arrPlantItems[i].source);
            (_arrPlantItems[i] as WOBuyPlantItem).deleteIt();
        }
        _arrAllPlants.length = 0;
        _arrPlantItems.length = 0;
        _callback = null;
        _ridge = null;
        super.deleteIt();
    }

}
}
