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

public class LevelUpHint {
    private var _source:Sprite;
    private var _txtName:CTextField;
    private var _txtText:CTextField;
//    private var _txtCount:CTextField;
//    private var _txtSklad:CTextField;
    private var bg:HintBackground;
    private var objTrees:Array;
    private var objCave:Array;
    private var objRecipes:Object;
    private var objAnimals:Object;
    public var isShowed:Boolean;
    private var g:Vars = Vars.getInstance();

    public function LevelUpHint() {
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

    public function showIt(_data:Object, sX:int, sY:int, source:Sprite,noResource:Boolean = false): void {
        var wText:int = 0;
        var wName:int = 0;
        var start:Point;
        start = new Point(int(sX - 5), int(sY - 23));
        start = source.parent.localToGlobal(start);
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

        if (_data.buildType == BuildType.RIDGE || _data.buildType == BuildType.MARKET || _data.buildType == BuildType.ORDER || _data.buildType == BuildType.PAPER) {
            _txtName.text = _data.name;
            _txtName.x = -100;
            _txtName.y = 15;
            _txtText.text = String(g.managerLanguage.allTexts[608]);
            _txtText.x = -100;
            _txtText.y = 15;
            _source.x = int(start.x + source.width/2);
            _source.y = int(start.y + source.height + 5);
            wText = int(_txtText.textBounds.width + 40);
            wName = int(_txtName.textBounds.width + 40);
            if (wText > wName) bg = new HintBackground(wText, 35, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 35, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
//            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }

        if (_data.buildType == BuildType.FABRICA) {
            _txtName.text = _data.name;
            _txtName.x = -100;
            _txtName.y = 15;
            _txtText.text = String(g.managerLanguage.allTexts[429]);
            _txtText.x = -100;
            _txtText.y = 15;
            _source.x = int(start.x + source.width/2);
            _source.y = int(start.y + source.height + 5);
            wText = int(_txtText.textBounds.width + 40);
            wName = int(_txtName.textBounds.width + 40);
            if (wText > wName) bg = new HintBackground(wText, 35, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 35, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
//            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }

        if (_data.buildType == BuildType.DAILY_BONUS) {
            _txtName.text = _data.name;
            _txtName.x = -100;
            _txtName.y = 30;
            _txtText.text = String(g.managerLanguage.allTexts[608]);
            _txtText.x = -100;
            _txtText.y = 15;
            _source.x = int(start.x + source.width/2);
            _source.y = int(start.y + source.height + 5);
            wText = int(_txtText.textBounds.width + 40);
            wName = int(_txtName.textBounds.width + 40);
            if (wText > wName) bg = new HintBackground(wText, 72, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 72, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
//            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }

        if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_ANIMATION || _data.buildType == BuildType.DECOR_FULL_FENСE
                || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_FENCE_ARKA || _data.buildType == BuildType.DECOR_FENCE_GATE
                || _data.buildType == BuildType.DECOR_POST_FENCE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA) {
            if (_data.buildType == BuildType.FABRICA || _data.buildType == BuildType.TREE
                    || _data.buildType == BuildType.ANIMAL || _data.buildType == BuildType.CAT_HOUSE || _data.buildType == BuildType.CAVE || _data.buildType == BuildType.FARM
                    || _data.buildType == BuildType.PET_HOUSE || _data.buildType == BuildType.PET_HOUSE || _data.buildType == BuildType.TRAIN) _txtName.text = _data.name;
            else _txtName.text = String(g.managerLanguage.allTexts[351]);
            _txtName.x = -100;
            _txtName.y = 30;
            _txtText.text = String(g.managerLanguage.allTexts[608]);
            _txtText.x = -100;
            _txtText.y = 15;
            _source.x = int(start.x + source.width/2);
            _source.y = int(start.y + source.height + 5);
            wText = int(_txtText.textBounds.width + 40);
            wName = int(_txtName.textBounds.width + 40);
            if (wText > wName) bg = new HintBackground(wText, 72, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 72, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
//            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }

        if (_data.buildType == BuildType.PLANT) {
            _txtName.text = _data.name;
            _txtName.x = -100;
            _txtName.y = 15;
            _txtText.text = String(g.managerLanguage.allTexts[608]);
            _txtText.x = -100;
            _txtText.y = 15;
            _source.x = int(start.x + source.width/2);
            _source.y = int(start.y + source.height + 5);
            wText = int(_txtText.textBounds.width + 40);
            wName = int(_txtName.textBounds.width + 40);
            if (wText > wName) bg = new HintBackground(wText, 70, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 70, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (_data.buildType == BuildType.INSTRUMENT) {
            _txtName.text = String(_data.name);
            _txtName.x = -100;
            _txtName.y = 15;
            if (_data.id == 2 || _data.id == 3 || _data.id == 7) {
                _txtText.text = String(_data.opys);
                _txtText.x = -100;
                _txtText.y = 32;
                wText = int(_txtText.textBounds.width + 20);
                wName = int(_txtName.textBounds.width + 80);
                if (wText > wName) bg = new HintBackground(wText, 120, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 120, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            } else {
                _txtText.text = String(_data.opys);
                _txtText.x = -100;
                _txtText.y = 23;
                wText = int(_txtText.textBounds.width + 20);
                wName = int(_txtName.textBounds.width + 80);
                if (wText > wName) bg = new HintBackground(wText, 105, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 105, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            }
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }
        for (var i:int=0; i<objTrees.length; i++) {
            if (_data.id == objTrees[i].craftIdResource) {
                _txtName.text = _data.name;
                _txtName.x = -100;
                _txtName.y = 15;
                _txtText.text = String(g.managerLanguage.allTexts[609]) + objTrees[i].name;
                _txtText.x = -100;
                _txtText.y = 15;
                wText = int(_txtText.textBounds.width + 40);
                wName = int(_txtName.textBounds.width + 40);
                if (wText > wName) bg = new HintBackground(wText, 70, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 70, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                g.cont.hintCont.addChild(_source);
                return;
            }
        }
        for (i=0; i<objCave.length; i++) {
            if (_data.id == int(objCave[i])) {
                _txtName.text = String(_data.name);
                _txtName.x = -100;
                _txtName.y = 20;
                _txtText.text = String(g.managerLanguage.allTexts[610]);
                _txtText.x = -100;
                _txtText.y = 5;
                wText = int(_txtText.textBounds.width + 20);
                wName = int(_txtName.textBounds.width + 40);
                if (wText > wName) bg = new HintBackground(wText, 70, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 70, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        if (objRecipes[_data.id]) {
                _txtName.text = String(_data.name);
                if (_txtName.textBounds.height >= 40) {
                    _txtName.x = -100;
                    _txtName.y = 29;
                    if (g.allData.getBuildingById(objRecipes[_data.id].buildingId)) _txtText.text = String(g.managerLanguage.allTexts[611]) + g.allData.getBuildingById(objRecipes[_data.id].buildingId).name;
                    else _txtText.text = String(g.managerLanguage.allTexts[611]) + ' UNKNOWN BUILDING';
                    _txtText.x = -100;
                    _txtText.y = 59;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 126, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 126, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                } else {
                    _txtName.x = -100;
                    _txtName.y = 15;
                    if (g.allData.getBuildingById(objRecipes[_data.id].buildingId)) _txtText.text = String(g.managerLanguage.allTexts[611]) + g.allData.getBuildingById(objRecipes[_data.id].buildingId).name;
                    else _txtText.text = String(g.managerLanguage.allTexts[611]) + ' UNKNOWN BUILDING';
                    _txtText.x = -100;
                    _txtText.y = 37;
                    wText = int(_txtText.textBounds.width + 20);
                    wName = int(_txtName.textBounds.width + 40);
                    if (wText > wName) bg = new HintBackground(wText, 109, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 109, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                }
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (objAnimals[_data.id]) {
            _txtName.text = _data.name;
            _txtName.x = -100;
            _txtName.y = 15;
            _txtText.text = String(g.managerLanguage.allTexts[611]) + g.allData.getBuildingById(objAnimals[_data.id].buildId).name;
            _txtText.x = -100;
            _txtText.y = 34;
            wText = int(_txtText.textBounds.width + 20);
            wName = int(_txtName.textBounds.width + 40);
            if (wText > wName) bg = new HintBackground(wText, 105, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 105, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }

        Cc.error('Market Hint:: can"t find for resourceId= ' + _data.id);
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
