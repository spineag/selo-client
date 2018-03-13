/**
 * Created by user on 1/27/16.
 */
package hint {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;

import utils.CTextField;

import utils.MCScaler;

import utils.TimeUtils;

import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class MarketHint {
    private var _source:Sprite;
    private var _txtName:CTextField;
    private var _txtText:CTextField;
    private var _txtCount:CTextField;
    private var _txtSklad:CTextField;
    private var _imageItem:Image;
    private var bg:HintBackground;
    private var objTrees:Array;
    private var objCave:Array;
    private var objRecipes:Object;
    private var objAnimals:Object;
    public var isShowed:Boolean;
    private var g:Vars = Vars.getInstance();

    public function MarketHint() {
        var obj:Object;
        _source = new Sprite();
        _source.touchable = false;
        isShowed = false;

        objTrees = [];
        objCave = [];
        var arR:Array = g.allData.building;
        for (var i:int = 0; i < arR.length; i++) {
            if (arR[i].buildType == BuildType.TREE)
                objTrees.push(arR[i]);
            else if (arR[i].buildType == BuildType.CAVE)
                objCave = arR[i].idResource;
        }

        objAnimals = [];
        arR = g.allData.animal;
        for (i = 0; i < arR.length; i++) {
            objAnimals[arR[i].idResource] = arR[i];
        }

        objRecipes = {};
        arR = g.allData.recipe;
        for (i = 0; i < arR.length; i++) {
           objRecipes[arR[i].idResource] = arR[i];
        }
    }

    public function showIt(_dataId:int, sX:int, sY:int, source:Sprite,noResource:Boolean = false): void {
        var wText:int = 0;
        var wName:int = 0;
        if (!g.allData.getResourceById(_dataId)) {
            Cc.error('MarketHint showIt:: empty g.dataResource.objectResources[_dataId]');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'MarketHint');
            return;
        }
//        isShowed = true;
        var start:Point;
        if (!noResource) {
            start = new Point(int(sX - 5), int(sY - 23));
            start = source.parent.localToGlobal(start);
        } else {
            start = new Point(int(sX-8), int(sY-5));
            start = source.parent.localToGlobal(start);
        }
        _source.x = int(start.x + source.width/2);
        _source.y = int(start.y + source.height);
        _source.scaleX = _source.scaleY = 0;
        var tween:Tween = new Tween(_source, 0.2);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);

        _txtName = new CTextField(200,50,'');
        _txtName.setFormat(CTextField.BOLD24, 24,Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtText = new CTextField(200,100,'');
        _txtText.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR);
        _txtText.leading = -1;
        _txtCount = new CTextField(200,50,'');
        _txtCount.setFormat(CTextField.BOLD18, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtSklad = new CTextField(200,50,'');
        _txtSklad.setFormat(CTextField.BOLD18, 20, ManagerFilters.BLUE_COLOR);
        
        if (g.allData.getResourceById(_dataId).buildType == BuildType.PLANT) {
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_dataId).imageShop + '_icon'));
            MCScaler.scale(_imageItem,30,30);
            if (noResource) {
                _txtName.text = g.allData.getResourceById(_dataId).name;
                _txtName.x = -100;
                _txtName.y = -105;
                _txtText.text = String(g.managerLanguage.allTexts[608]);
                _txtText.x = -100;
                _txtText.y = -104;
                wText = int(_txtText.textBounds.width + 20);
                wName = int(_txtName.textBounds.width + 40);
                if (wText > wName) bg = new HintBackground(wText, 75, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                else bg = new HintBackground(wName, 75, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
            } else {
                _imageItem.y = 80;
                _imageItem.x = 10;
                _txtName.text = g.allData.getResourceById(_dataId).name;
                _txtName.x = -100;
                _txtName.y = 15;
                _txtText.text = String(g.managerLanguage.allTexts[608]);
                _txtText.x = -100;
                _txtText.y = 15;
                _txtSklad.text = String(g.managerLanguage.allTexts[612]);//+ ' ' + String(g.userInventory.getCountResourceById(_dataId));
                _txtSklad.alignH = Align.LEFT;
                _txtSklad.x = -50;
                _txtSklad.y = 65;
                _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                _txtCount.alignH = Align.LEFT;
                _txtCount.x = _txtSklad.x + _txtSklad.textBounds.width;
                _txtCount.y = 65;
                _source.x = int(start.x + source.width/2);
                _source.y = int(start.y + source.height + 5);
                wText = int(_txtText.textBounds.width + 40);
                wName = int(_txtName.textBounds.width + 40);
                if (wText > wName) bg = new HintBackground(wText, 90, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 90, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            }
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            if (!noResource) {
//                _source.addChild(_imageItem);
                _source.addChild(_txtCount);
                _source.addChild(_txtSklad);
            }
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (g.allData.getResourceById(_dataId).buildType == BuildType.INSTRUMENT) {
            _txtName.text = String(g.allData.getResourceById(_dataId).name);
            _txtName.x = -100;
            _txtName.y = 15;
            _imageItem = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(_dataId).imageShop));
            MCScaler.scale(_imageItem,30,30);
            if (noResource) {
                if (_dataId == 6 || _dataId == 5 || _dataId == 125) {
                    _txtName.text = g.allData.getResourceById(_dataId).name;
                    _txtName.x = -100;
                    _txtName.y = -167;
                    _txtText.text = String(g.allData.getResourceById(_dataId).opys);
                    _txtText.x = -100;
                    _txtText.y = -125;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 150, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                    else bg = new HintBackground(wName, 150, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                } else {
                    _txtName.text = g.allData.getResourceById(_dataId).name;
                    _txtName.x = -100;
                    _txtName.y = -123;
                    _txtText.text = String(g.allData.getResourceById(_dataId).opys);
                    _txtText.x = -100;
                    _txtText.y = -114;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 90, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                    else bg = new HintBackground(wName, 90, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                }
            } else {
                if (_dataId == 2 || _dataId == 3 || _dataId == 7) {
                    _txtText.text = String(g.allData.getResourceById(_dataId).opys);
                    _txtText.x = -100;
                    _txtText.y = 32;
                    _txtSklad.text = String(g.managerLanguage.allTexts[612]);
                    _txtSklad.alignH = Align.LEFT;
                    _txtSklad.x = -50;
                    _txtSklad.y = 97;
                    _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                    _txtCount.alignH = Align.LEFT;
                    _txtCount.x = _txtSklad.x + _txtSklad.textBounds.width;
                    _txtCount.y = 97;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 80);
                    if (wText > wName) bg = new HintBackground(wText, 120, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 120, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                } else {
//                _imageItem.y = 80;
//                _imageItem.x = 10;
                    _txtText.text = String(g.allData.getResourceById(_dataId).opys);
                    _txtText.x = -100;
                    _txtText.y = 23;
                    _txtSklad.text = String(g.managerLanguage.allTexts[612]);
                    _txtSklad.alignH = Align.LEFT;
                    _txtSklad.x = -50;
                    _txtSklad.y = 79;
                    _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                    _txtCount.alignH = Align.LEFT;
                    _txtCount.x = _txtSklad.x + _txtSklad.textBounds.width;
                    _txtCount.y = 79;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 80);
                    if (wText > wName) bg = new HintBackground(wText, 105, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 105, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                }
            }
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
//            _source.addChild(_imageItem);
            _source.addChild(_txtCount);
            _source.addChild(_txtSklad);
            g.cont.hintCont.addChild(_source);
            return;
        }
        for (var i:int=0; i<objTrees.length; i++) {
            if (_dataId == objTrees[i].craftIdResource) {
//                _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_dataId).imageShop));
//                MCScaler.scale(_imageItem,30,30);
//                _imageItem.y = 70;
//                _imageItem.x = 10;
                if (noResource) {
                    _txtName.text = g.allData.getResourceById(_dataId).name;
                    _txtName.x = -100;
                    _txtName.y = -105;
                    _txtText.text = String(g.managerLanguage.allTexts[609]) + objTrees[i].name;
                    _txtText.x = -100;
                    _txtText.y = -104;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 75, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                    else bg = new HintBackground(wName, 75, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                } else {
                    _txtName.text = g.allData.getResourceById(_dataId).name;
                    _txtName.x = -100;
                    _txtName.y = 15;
                    _txtText.text = String(g.managerLanguage.allTexts[609]) + objTrees[i].name;
                    _txtText.x = -100;
                    _txtText.y = 20;
                    _txtSklad.text = String(g.managerLanguage.allTexts[612]);
                    _txtSklad.alignH = Align.LEFT;
                    _txtSklad.x = -60;
                    _txtSklad.y = 76;
                    _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                    _txtCount.alignH = Align.LEFT;
                    _txtCount.x = _txtSklad.x + _txtSklad.textBounds.width;
                    _txtCount.y = 78;
                    wText = int(_txtText.textBounds.width + 40);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 105, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 105, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                }
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                if (!noResource) {
//                    source.addChild(_imageItem);
                    _source.addChild(_txtCount);
                    _source.addChild(_txtSklad);
                }
                g.cont.hintCont.addChild(_source);
                return;
            }
        }
        for (i=0; i<objCave.length; i++) {
            if (_dataId == int(objCave[i])) {
                if (noResource) {
                    _txtName.text = g.allData.getResourceById(_dataId).name;
                    _txtName.x = -100;
                    _txtName.y = -115;
                    _txtText.text = String(g.managerLanguage.allTexts[610]);
                    _txtText.x = -100;
                    _txtText.y = -104;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 85, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                    else bg = new HintBackground(wName, 85, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                } else {
                    _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_dataId).imageShop));
                    MCScaler.scale(_imageItem, 30, 30);
                    _imageItem.y = 70;
                    _imageItem.x = 15;
                    _txtName.text = String(g.allData.getResourceById(_dataId).name);
                    _txtName.x = -100;
                    _txtName.y = _txtName.textBounds.height/2;
                    _txtText.text = String(g.managerLanguage.allTexts[610]);
                    _txtText.x = -100;
                    _txtText.y = _txtName.textBounds.height + 4;
                    _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                    _txtCount.x = -40;
                    _txtCount.y = _txtName.textBounds.height + _txtText.textBounds.height + 10;
                    _txtSklad.text = String(g.managerLanguage.allTexts[612]);
                    _txtSklad.x = -105;
                    _txtSklad.y = _txtName.textBounds.height + _txtText.textBounds.height + 10;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, _txtCount.textBounds.height + _txtSklad.textBounds.height + _txtName.textBounds.height + 50, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, _txtCount.textBounds.height + _txtSklad.textBounds.height + _txtName.textBounds.height + 50, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                }
                    _source.addChild(bg);
                    _source.addChild(_txtName);
                    _source.addChild(_txtText);
//                _source.addChild(_imageItem);
                if (!noResource) {
                    _source.addChild(_txtCount);
                    _source.addChild(_txtSklad);
                }
                    g.cont.hintCont.addChild(_source);
                    return;
            }
        }

        if (objRecipes[_dataId]) {
            _imageItem = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_dataId).imageShop));
            MCScaler.scale(_imageItem,30,30);
            _imageItem.y = 74;
            _imageItem.x = 15;
            if (noResource) {
                _txtName.text = String(g.allData.getResourceById(_dataId).name);
                if (_txtName.textBounds.height >= 40) {
                    _txtName.x = -100;
                    _txtName.y = -152;
                    if (g.allData.getBuildingById(objRecipes[_dataId].buildingId)) _txtText.text = String(g.managerLanguage.allTexts[611]) + g.allData.getBuildingById(objRecipes[_dataId].buildingId).name;
                    else _txtText.text = String(g.managerLanguage.allTexts[611]) + ' UNKNOWN BUILDING';
                    _txtText.x = -100;
                    _txtText.y = -120;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 135, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                    else bg = new HintBackground(wName, 135, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                } else {
                    _txtName.x = -100;
                    _txtName.y = -135;
                    if (g.allData.getBuildingById(objRecipes[_dataId].buildingId)) _txtText.text = String(g.managerLanguage.allTexts[611]) + g.allData.getBuildingById(objRecipes[_dataId].buildingId).name;
                    else _txtText.text = String(g.managerLanguage.allTexts[611]) + ' UNKNOWN BUILDING';
                    _txtText.x = -100;
                    _txtText.y = -114;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 105, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                    else bg = new HintBackground(wName, 105, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                }
            } else {
                _txtName.text = String(g.allData.getResourceById(_dataId).name);
                if (_txtName.textBounds.height >= 40) {
                    _txtName.x = -100;
                    _txtName.y = 29;
                    if (g.allData.getBuildingById(objRecipes[_dataId].buildingId)) _txtText.text = String(g.managerLanguage.allTexts[611]) + g.allData.getBuildingById(objRecipes[_dataId].buildingId).name;
                    else _txtText.text = String(g.managerLanguage.allTexts[611]) + ' UNKNOWN BUILDING';
                    _txtText.x = -100;
                    _txtText.y = 59;
                    _txtSklad.text = String(g.managerLanguage.allTexts[612]);
                    _txtSklad.alignH = Align.LEFT;
                    _txtSklad.x = -50;
                    _txtSklad.y = 123;
                    _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                    _txtCount.alignH = Align.LEFT;
                    _txtCount.x = _txtSklad.x + _txtSklad.textBounds.width;
                    _txtCount.y = 123;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 146, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 146, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                } else {
                    _txtName.x = -100;
                    _txtName.y = 15;
                    if (g.allData.getBuildingById(objRecipes[_dataId].buildingId)) _txtText.text = String(g.managerLanguage.allTexts[611]) + g.allData.getBuildingById(objRecipes[_dataId].buildingId).name;
                    else _txtText.text = String(g.managerLanguage.allTexts[611]) + ' UNKNOWN BUILDING';
                    _txtText.x = -100;
                    _txtText.y = 37;
                    _txtSklad.text = String(g.managerLanguage.allTexts[612]);
                    _txtSklad.alignH = Align.LEFT;
                    _txtSklad.x = -50;
                    _txtSklad.y = 105;
                    _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                    _txtCount.alignH = Align.LEFT;
                    _txtCount.x = _txtSklad.x + _txtSklad.textBounds.width;
                    _txtCount.y = 105;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 129, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 129, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                }
            }
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            if (!noResource) {
                _source.addChild(_txtCount);
                _source.addChild(_txtSklad);
            }
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (objAnimals[_dataId]) {
            if (noResource) {
                _txtName.text = g.allData.getResourceById(_dataId).name;
                _txtName.x = -100;
                _txtName.y = -135;
                _txtText.text = String(g.managerLanguage.allTexts[611]) + g.allData.getBuildingById(objAnimals[_dataId].buildId).name;
                _txtText.x = -100;
                _txtText.y = -114;
                wText = int(_txtText.textBounds.width + 20);
                wName = int(_txtName.textBounds.width + 40);
                if (wText > wName) bg = new HintBackground(wText, 105, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                else bg = new HintBackground(wName, 105, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
            } else {
                _txtName.text = g.allData.getResourceById(_dataId).name;
                _txtName.x = -100;
                _txtName.y = 15;
                _txtText.text = String(g.managerLanguage.allTexts[611]) + g.allData.getBuildingById(objAnimals[_dataId].buildId).name;
                _txtText.x = -100;
                _txtText.y = 28;
                _txtSklad.text = String(g.managerLanguage.allTexts[612]);
                _txtSklad.alignH = Align.LEFT;
                _txtSklad.x = -50;
                _txtSklad.y = 90;
                _txtCount.text = String(g.userInventory.getCountResourceById(_dataId));
                _txtCount.alignH = Align.LEFT;
                _txtCount.x = _txtSklad.x + _txtSklad.textBounds.width;
                _txtCount.y = 90;
                wText = int(_txtText.textBounds.width + 20);
                wName = int(_txtName.textBounds.width + 40);
                if (wText > wName) bg = new HintBackground(wText, 111, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 111, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            }
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            if (!noResource) {
                _source.addChild(_txtCount);
                _source.addChild(_txtSklad);
            }
            g.cont.hintCont.addChild(_source);
            return;
        }

        Cc.error('Market Hint:: can"t find for resourceId= ' + _dataId);
    }

    public function hideIt():void {
        if (bg) bg.deleteIt();
        while (_source.numChildren) {
            _source.removeChildAt(0);
        }
        g.cont.hintCont.removeChild(_source);
        isShowed = false;
    }
}
}
