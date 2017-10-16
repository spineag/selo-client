/**
 * Created by user on 7/23/15.
 */
package hint {
import com.junkbyte.console.Cc;
import data.BuildType;
import flash.geom.Point;
import flash.utils.getTimer;
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

public class ResourceHint {
    private var _source:Sprite;
    private var _imageClock:Image;
    private var _txtName:CTextField;
    private var _txtTime:CTextField;
    private var _txtText:CTextField;
    public var isShowed:Boolean;
    private var bg:HintBackground;
    private var objTrees:Array;
    private var objCave:Array;
    private var objRecipes:Object;
    private var objAnimals:Object;
    private var _timer:int;
    private var _id:int;
    private var _newY:int;
    private var _newX:int;
    private var _newSource:Sprite;
    private var _fabrickBoo:Boolean;
    private var _bool:Boolean;
    private var g:Vars = Vars.getInstance();

    public function ResourceHint() {
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

        objRecipes = [];
        arR = g.allData.recipe;
        for (i = 0; i < arR.length; i++) {
           objRecipes[arR[i].idResource] = arR[i];
        }
    }

    public function showIt(_dataId:int, sX:int, sY:int, source:Sprite, bol:Boolean = false, fabr:Boolean = false):void {
        if (_dataId == 0) return;
        _id = _dataId;
        _newX = sX;
        _newY = sY;
        _newSource = source;
        _bool = bol;
        _fabrickBoo = fabr;
        _timer --;
        var wText:int = 0;
        var wName:int = 0;
        var hText:int = 0;
        var start:Point = new Point(int(_newX-2), int(_newY - 20));
        start = _newSource.parent.localToGlobal(start);
        _source.x = int(start.x + _newSource.width/2);
        _source.y = int(start.y + _newSource.height);

        _source.scaleX = _source.scaleY = 0;
        var tween:Tween = new Tween(_source, 0.2);
        tween.scaleTo(1);
        tween.onComplete = function ():void {  g.starling.juggler.remove(tween); };
        g.starling.juggler.add(tween);

        _txtText = new CTextField(200,100,'');
        _txtText.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR);
        _txtText.leading = -2;
        _txtName = new CTextField(200, 50, '');
        _txtName.setFormat(CTextField.BOLD24, 24,Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtTime = new CTextField(100, 50, '');
        _txtTime.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txtTime.alignH = Align.LEFT;
        
        if (_fabrickBoo) {
            _txtText.text = String(g.managerLanguage.allTexts[607]) + " " + g.allData.getRecipeById(_id).blockByLevel + ' ' + String(g.managerLanguage.allTexts[343]);
            _txtText.x = -100;
            _txtText.y = -10;
            wName = _txtText.textBounds.width + 40;
            bg = new HintBackground(wName, 67, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            _source.x = start.x;
            _source.y = start.y;
            return;
        }
        if (g.allData.getResourceById(_id).blockByLevel > g.user.level) {
            _txtText.text = String(g.managerLanguage.allTexts[607]) + " " + g.allData.getResourceById(_id).blockByLevel + ' ' + String(g.managerLanguage.allTexts[343]);
            _txtText.x = -100;
            _txtText.y = -2;
            wName = _txtText.textBounds.width + 40;
            bg = new HintBackground(wName, 67, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            _source.x = start.x;
            _source.y = start.y;
            return;
        }
        if (g.allData.getResourceById(_id).buildType == BuildType.PLANT) {
            _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("clock"));
            MCScaler.scale(_imageClock, 25, 25);
            _imageClock.y = 65;
            _txtName.text = String(g.allData.getResourceById(_id).name);
            _txtName.x = -103;
            _txtName.y = 15;
            _txtTime.text = TimeUtils.convertSecondsForHint(g.allData.getResourceById(_id).buildTime);
            _txtTime.y = 52;
            _txtText.x = -100;
            _txtText.y = 20;
            if (_bool) {
                _source.x = int(start.x);
                _source.y = int(start.y);
//                _txtText.text = String(g.managerLanguage.allTexts[613]);
                wText = _txtName.textBounds.width + 20;
                wName = _txtName.textBounds.width + 40;
            } else {
                _txtText.text = String(g.managerLanguage.allTexts[608]);
                _source.x = int(start.x + _newSource.width/2);
                _source.y = int(start.y + _newSource.height) + 5;
                wText = _txtText.textBounds.width + 20;
                wName = _txtName.textBounds.width + 40;
            }
            if (wText > wName) bg = new HintBackground(wText, 80, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 80, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _imageClock.x = -bg.width/2 + (bg.width - (_imageClock.width + _txtTime.textBounds.width + 5))/2;
            _txtTime.x = _imageClock.x +_imageClock.width + 5;
            _source.addChild(bg);
            _source.addChild(_txtName);
            if (!_bool) _source.addChild(_txtText);
            if (_bool) {
                _source.addChild(_imageClock);
                _source.addChild(_txtTime);
            }
            g.cont.hintCont.addChild(_source);
            return;
        }
        if (g.allData.getResourceById(_id).buildType == BuildType.INSTRUMENT) {
            _txtName.text = String(g.allData.getResourceById(_id).name);
            _txtName.x = -103;
            _txtName.y = 15;
            _txtName.leading = -5;
            _txtText.text = String(g.allData.getResourceById(_id).opys);
            _txtText.x = -100;
            _txtText.y = 22;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (_bool) {
                if (wText > wName) {
                    if (_id == 2 || _id == 3 || _id == 7) {
                        bg = new HintBackground(wText, 105, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
//                        _txtText.y = 30;
                        _txtName.x = -100;
                        _txtName.y = -134;
                        _txtText.x = -100;
                        _txtText.y = -118;
                    } else {
                        bg = new HintBackground(wText, 85, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                        _txtName.x = -100;
                        _txtName.y = -115;
                        _txtText.x = -100;
                        _txtText.y = -106;
                    }

                } else {
                    bg = new HintBackground(wName, 85, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
                    _txtName.x = -100;
                    _txtName.y = -115;
                    _txtText.x = -100;
                    _txtText.y = -106;
                }
                _source.x = int(start.x + _newSource.width/2);
                _source.y = int(start.y) + 30;

            } else {
                if (wText > wName) {
                    if (_id == 5 || _id == 6 || _id == 125) {
                        bg = new HintBackground(wText, 114, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                        _txtText.y = 41;
                    } else if (_id == 2 || _id == 3 || _id == 7) {
                        bg = new HintBackground(wText, 100, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                        _txtText.y = 30;
                    } else bg = new HintBackground(wText, 85, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                }
                else bg = new HintBackground(wName, 85, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            }
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
            g.cont.hintCont.addChild(_source);
            return;
        }

        for (var i:int=0; i<objTrees.length; i++) {
            if (_id == objTrees[i].craftIdResource) {
                _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("clock"));
                MCScaler.scale(_imageClock, 30, 30);
                _imageClock.y = 70;
                _txtName.text = String(g.allData.getResourceById(_id).name);
                _txtName.x = -103;
                _txtName.y = 15;
                _txtTime.text = TimeUtils.convertSecondsForHint(g.allData.getResourceById(_id).buildTime);
                _txtTime.y = 57;
                _txtText.text = String(g.managerLanguage.allTexts[609]) + objTrees[i].name;
                _txtText.x = -100;
                _txtText.y = 20;
                wText = _txtText.textBounds.width + 20;
                wName = _txtName.textBounds.width + 40;
                if (wText > wName) bg = new HintBackground(wText, 80, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 80, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _imageClock.x = -bg.width/2 + (bg.width - (_imageClock.width + _txtTime.textBounds.width + 5))/2;
                _txtTime.x = _imageClock.x +_imageClock.width + 5;
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
//                _source.addChild(_txtTime);
//                _source.addChild(_imageClock);
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        for (i=0; i<objCave.length; i++) {
            if (_id == int(objCave[i])) {
                _txtName.text = String(g.allData.getResourceById(_id).name);
                _txtName.x = -103;
                _txtName.y = 15;
                _txtText.text = String(g.managerLanguage.allTexts[610]) ;
                _txtText.x = -100;
                _txtText.y = 35;
                wText = _txtText.textBounds.width + 20;
                wName = _txtName.textBounds.width + 40;
                if (wText > wName) bg = new HintBackground(wText, 100, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                else bg = new HintBackground(wName, 100, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _source.addChild(bg);
                _source.addChild(_txtName);
                _source.addChild(_txtText);
                g.cont.hintCont.addChild(_source);
                return;
            }
        }

        if (objRecipes[_id]) {
            _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("clock"));
            MCScaler.scale(_imageClock, 30, 30);
            _imageClock.x = -30;
            _txtName.text = String(g.allData.getResourceById(_id).name);
            _txtName.x = -103;
            _txtTime.text = TimeUtils.convertSecondsForHint(g.allData.getResourceById(_id).buildTime);
            _txtTime.x = 20;
            _txtText.text = String(g.managerLanguage.allTexts[611])  + g.allData.getBuildingById(objRecipes[_id].buildingId).name;
            _txtText.x = -100;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            hText = _txtText.textBounds.height;
            if (hText >= 25) {
                if (_txtName.textBounds.height >= 40) {
                    if (wText > wName) bg = new HintBackground(wText, 130, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 130, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    _imageClock.x = -45;
                    _imageClock.y = 75;
                    _txtTime.x = 0;
                    _txtTime.y = 67;
                    _txtText.y = 60;
                    _txtName.y = 27;
                } else {
                    if (wText > wName) bg = new HintBackground(wText, 100, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 100, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    _imageClock.x = -45;
                    _imageClock.y = 75;
                    _txtTime.x = 0;
                    _txtTime.y = 65;
                    _txtText.y = 35;
                    _txtName.y = 15;
                }
            } else {
                if (wText > wName) bg = new HintBackground(wText, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                    else bg = new HintBackground(wName, 95, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
                _imageClock.y = 60;
                _txtTime.y = 50;
                _txtText.y = 0;
            }

            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
//            if (!_bool) _source.addChild(_txtTime);
//            if (!_bool) _source.addChild(_imageClock);
            g.cont.hintCont.addChild(_source);
            return;
        }

        if (objAnimals[_id]) {
            _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("clock"));
            MCScaler.scale(_imageClock, 30, 30);
            _imageClock.y = 74;
            _imageClock.x = -30;
            _txtName.text = String(g.allData.getResourceById(_id).name);
            _txtName.x = -103;
            _txtName.y = 15;
            _txtTime.text = TimeUtils.convertSecondsForHint(g.allData.getResourceById(_id).buildTime);
            _txtTime.y = 62;
            _txtText.text = String(g.managerLanguage.allTexts[611]) + g.allData.getBuildingById(objAnimals[_id].buildId).name;
            _txtText.x = -100;
            _txtText.y = 34;
            wText = _txtText.textBounds.width + 20;
            wName = _txtName.textBounds.width + 40;
            if (wText > wName) bg = new HintBackground(wText, 100, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            else bg = new HintBackground(wName, 100, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
            _source.addChild(bg);
            _source.addChild(_txtName);
            _source.addChild(_txtText);
//            if (!_bool) _source.addChild(_txtTime);
//            if (!_bool) _source.addChild(_imageClock);
            g.cont.hintCont.addChild(_source);
            return;
        }
        Cc.error('Resource hint:: can"t find for resourceId= ' + _id);
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
