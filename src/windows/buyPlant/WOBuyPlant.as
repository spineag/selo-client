/**
 * Created by user on 6/2/15.
 */
package windows.buyPlant {
import build.ridge.Ridge;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.StructureDataResource;

import flash.geom.Point;

import media.SoundConst;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

import tutorial.managerCutScenes.ManagerCutScenes;

import windows.WOComponents.Birka;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyPlant extends WindowMain {
    private var _ridge:Ridge;
    private var _callback:Function;
    private var _topBG:Sprite;
    private var _shift:int;
    private var _arrShiftBtns:Array;
    private var _arrPlantItems:Array;
    private var _arrAllPlants:Array;
    private var _birka:Birka;

    public function WOBuyPlant() {
        super();
        _windowType = WindowsManager.WO_BUY_PLANT;
        _woWidth = 580;
        _woHeight = 134;
        createBG();
        createPlantItems();
        _callbackClickBG = onClickExit;
        _arrAllPlants = [];

        _birka = new Birka(String(g.managerLanguage.allTexts[445]), _source, 455, 580);
        _birka.flipIt();
        _birka.source.rotation = Math.PI/2;
        _birka.source.x = 80;
        _birka.source.y = 150;
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
        if (!_ridge) {
            hideIt();
            Cc.error('WOBuyPlant showItWithParams: ridge == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woBuyPlant');
            return;
        }
        updatePlantArray();
        activateShiftBtn(g.user.lastVisitPlant, false);
        fillPlantItems();
        showAnimatePlantItems();
        super.showIt();
        g.managerCutScenes.isWOPlantCutSceneAvailable();
    }

    private function updatePlantArray():void {
        _arrAllPlants.length = 0;
        var arR:Array = g.allData.resource;
        for (var i:int = 0; i < arR.length; i++) {
            if (arR[i].buildType == BuildType.PLANT && arR[i].blockByLevel <= g.user.level + 1) {
                if (arR[i].id != 168) _arrAllPlants.push(arR[i]);
                else if (g.userTimer.partyToEndTimer > 0) _arrAllPlants.push(arR[i]);
            }
        }
        _arrAllPlants.sortOn('blockByLevel', Array.NUMERIC);
    }

    private function fillPlantItems():void {
        var arr:Array = [];
        for (var i:int=0; i<5; i++) {
            if (_arrAllPlants[_shift*5 + i]) {
                arr.push(_arrAllPlants[_shift*5 + i]);
            } else {
                break;
            }
        }
        for (i=0; i<arr.length; i++) {
            if (arr[i].blockByLevel <= g.user.level + 1)
                _arrPlantItems[i].fillData(arr[i], onClickItem);
        }
    }

    private function showAnimatePlantItems():void {
        var delay:Number = .1;
        for (var i:int = 0; i < _arrPlantItems.length; i++) {
            _arrPlantItems[i].showAnimateIt(delay);
            delay += .1;
        }
    }

    private function animateChangePlantItems():void {
        var arr:Array = [];
        for (var i:int=0; i<5; i++) {
            if (_arrAllPlants[_shift*5 + i]) {
                arr.push(_arrAllPlants[_shift*5 + i]);
            } else {
                break;
            }
        }
        var delay:Number = .1;
        for (i = 0; i < _arrPlantItems.length; i++) {
            if (arr[i]) {
                _arrPlantItems[i].showChangeAnimate(delay, arr[i], onClickItem);
            } else {
                _arrPlantItems[i].showChangeAnimate(delay, null, null);
            }
            delay += .1;
        }
    }

    private function onClickItem(d:StructureDataResource, r:Ridge = null,calllback:Function = null):void {
        if (g.userInventory.getCountResourceById(d.id) <= 0) {
//            g.windowsManager.cashWindow = this;
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
        if (_birka )super.hideIt();
    }

    private function createBG():void {
        _topBG = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_l'));
        _topBG.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_r'));
        im.x = _woWidth - im.width;
        _topBG.addChild(im);
        for (var i:int=0; i<10; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_c'));
            im.x = 50*(i+1);
            _topBG.addChildAt(im, 0);
        }
        _topBG.x = -_woWidth/2;
        _topBG.y = -_woHeight/2 + 80;
        _source.addChild(_topBG);
    }

    private function createPlantItems():void {
        var item:WOBuyPlantItem;
        _arrPlantItems = [];
        for (var i:int = 0; i < 5; i++) {
            item = new WOBuyPlantItem();
            item.setCoordinates(-_woWidth/2 + 70 + i*107, -_woHeight/2 + 115);
            _source.addChild(item.source);
            _arrPlantItems.push(item);
        }
    }

    private function activateShiftBtn(n:int, needUpdate:Boolean = true):void {
        if (g.managerCutScenes.isCutScene) {
            if (g.managerCutScenes.curCutSceneProperties.reason == ManagerCutScenes.REASON_OPEN_WO_PLANT && n == 2) {
                g.managerCutScenes.checkCutSceneCallback();
            } else return;
        }
        g.user.lastVisitPlant = n;
        if (needUpdate && _shift == n-1) return;
        for (var i:int=0; i<_arrShiftBtns.length; i++) {
            _arrShiftBtns[i].source.y = -_woHeight/2 + 117;
        }
        if (_arrShiftBtns[n-1]) _arrShiftBtns[n-1].source.y += 8;
        _shift = n-1;
        if (needUpdate) {
            animateChangePlantItems();
        }
    }

    override protected function deleteIt():void {
        for (var i:int=0; i<_arrShiftBtns.length; i++) {
            _source.removeChild(_arrShiftBtns[i].source);
            _arrShiftBtns[i].deleteIt();
        }
        _arrShiftBtns.length = 0;
        for (i = 0; i < _arrPlantItems.length; i++) {
            _source.removeChild(_arrPlantItems[i].source);
            _arrPlantItems[i].deleteIt();
        }
        _arrAllPlants.length = 0;
        _arrPlantItems.length = 0;
        _callback = null;
        _ridge = null;
        if (_source)_source.removeChild(_birka);
        if (_source)_birka.deleteIt();
        if (_source)_birka = null;
        super.deleteIt();
    }

    public function getBoundsProperties(s:String):Object {
        var obj:Object;
        var p:Point = new Point();
        switch (s) {
            case 'secondTab':
                if (_arrShiftBtns[1]) {
                    obj = {};
                    p.x = _arrShiftBtns[1].source.x + _arrShiftBtns[1].source.width/2;
                    p.y = _arrShiftBtns[1].source.y + _arrShiftBtns[1].source.height + 10;
                    p = _source.localToGlobal(p);
                    obj.x = p.x;
                    obj.y = p.y;
                }
                break;
        }
        return obj;
    }
}
}
