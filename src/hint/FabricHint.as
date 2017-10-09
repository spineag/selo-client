/**
 * Created by user on 7/13/15.
 */
package hint {
import com.junkbyte.console.Cc;
import data.BuildType;
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

public class FabricHint {
    private var _txtName:CTextField;
//    private var _txtTimeCreate:CTextField;
//    private var _txtOnSklad:CTextField;
//    private var _txtCount:CTextField;
//    private var _txtTime:CTextField;
    private var _source:Sprite;
    private var _arrCells:Array;
    private var _contImage:Sprite;
    private var _data:Object;
    private var _newX:int;
    private var _newY:int;
    private var _bigTxt:CTextField;

    private var g:Vars = Vars.getInstance();

    public function FabricHint() {
        _source = new Sprite();
        _arrCells = [];
        var bg:HintBackground = new HintBackground(200, 140, HintBackground.BIG_TRIANGLE, HintBackground.BOTTOM_CENTER);
        bg.x = 100;
        _source.addChild(bg);

        _txtName = new CTextField(180,30,'');
        _txtName.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.LIGHT_BLUE_COLOR);
        _txtName.y = -165;
        _txtName.x = 10;
        _source.addChild(_txtName);

//        _txtTimeCreate = new CTextField(50, 30 ,String(g.managerLanguage.allTexts[990]) + ':');
//        _txtTimeCreate.setFormat(CTextField.BOLD18, 14, ManagerFilters.BLUE_COLOR);
//        _txtTimeCreate.x = 8;
//        _txtTimeCreate.y = -66;
//        _txtOnSklad = new CTextField(100, 30 ,String(g.managerLanguage.allTexts[991]) + ':');
//        _txtOnSklad.setFormat(CTextField.BOLD18, 14, ManagerFilters.BLUE_COLOR);
//        _txtOnSklad.x = 87;
//        _txtOnSklad.y = -66;
//        _txtCount = new CTextField(50, 40 ,'');
//        _txtCount.setFormat(CTextField.BOLD18, 16, ManagerFilters.BLUE_COLOR);
//        _txtCount.alignH = Align.LEFT;
//        _txtCount.x = 171;
//        _txtCount.y = -72;
//        _txtTime = new CTextField(40, 23 ,'');
//        _txtTime.setFormat(CTextField.BOLD18, 16, ManagerFilters.BLUE_COLOR);
//        _txtTime.alignH = Align.LEFT;
//        _txtTime.border = true;
//        _txtTime.x = 58;
//        _txtTime.y = -72;
//        _source.addChild(_txtTimeCreate);
//        _source.addChild(_txtOnSklad);
//        _source.addChild(_txtCount);
//        _source.addChild(_txtTime);
        _bigTxt = new CTextField(190, 22, '');
        _bigTxt.setFormat(CTextField.BOLD18, 16, ManagerFilters.BLUE_COLOR);
        _bigTxt.x = 6;
        _bigTxt.y = -65;
        _source.addChild(_bigTxt);

        _contImage = new Sprite();
        _contImage.y = 50;
        _source.addChild(_contImage);
        _source.pivotX = bg.width/2;
        _source.touchable = false;
    }

    public function showIt(da:Object, sX:int, sY:int):void {
        _data = da;
        _newX = sX;
        _newY = sY;
        if (_data && g.allData.getResourceById(_data.idResource)) {
            _txtName.text = String(g.allData.getResourceById(int(_data.idResource)).name);
            _txtName.visible = false;
            var st:String = String(g.managerLanguage.allTexts[990]) + ': ' + String(TimeUtils.convertSecondsForHint(g.allData.getResourceById(_data.idResource).buildTime)) +
                    '   ' + String(g.managerLanguage.allTexts[991]) + ': ' + String(g.userInventory.getCountResourceById(_data.idResource));
//            _txtTime.text = String(TimeUtils.convertSecondsForHint(g.allData.getResourceById(_data.idResource).buildTime));
//            _txtCount.text = String(g.userInventory.getCountResourceById(_data.idResource));
            _bigTxt.text = st;
            createList();
            _source.x = _newX + 50;
            _source.y = _newY + 80;
            g.cont.hintCont.addChild(_source);

            _source.scaleX = _source.scaleY = 0;
            var tween:Tween = new Tween(_source, 0.15);
            tween.scaleTo(1);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
                _txtName.visible = true;
            };
            g.starling.juggler.add(tween);
        } else {
            Cc.error('FabricHint showIt with empty data or g.dataResource.objectResources[data.idResource] = null');
        }
    }
    
    public function updateItem():void {
        for (var i:int = 0; i < _arrCells.length; i++) {
            (_arrCells[i] as FabricHintItem).updateCount();
        }
    }

    private function createList():void {
        if (!_data) {
            Cc.error('FabricHint createList:: empty data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'fabricHint');
            return;
        }
        var im:FabricHintItem;
        for (var i:int = 0; i < _data.ingridientsId.length; i++) {
            im = new FabricHintItem(int(_data.ingridientsId[i]), int(_data.ingridientsCount[i]), Boolean(i>0));
            im.source.x = int (i * 45);
            _arrCells.push(im);
            _contImage.addChild(im.source);
            switch (_data.ingridientsId.length) {
                case 1: _contImage.x = 50; break;
                case 2: _contImage.x = 30; break;
                case 3: _contImage.x = 10; break;
                case 4: _contImage.x = -20; break;
            }
        }
        _contImage.y = -158;
    }

    public function hideIt():void {
        g.cont.hintCont.removeChild(_source);
        for (var i:int=0; i<_arrCells.length; i++) {
           _contImage.removeChild(_arrCells[i].source);
           (_arrCells[i] as FabricHintItem).deleteIt();
        }
        _arrCells.length = 0;
//        _txtCount.text = _txtName.text = _txtTime.text = '';
        _bigTxt.text = '';
    }
}
}

import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

internal class FabricHintItem {
    public var source:Sprite;
    private var _image:Image;
    private var _txtOrange:CTextField;
    private var _txtWhite:CTextField;
    private var _needCount:int;
    private var _id:int;
    private var _txtPlus:CTextField;
    private var g:Vars = Vars.getInstance();

    public function FabricHintItem(obId:int, needCount:int, showPlus:Boolean) {
        source = new Sprite();
        _needCount = needCount;
        _id = obId;
        _txtWhite = new CTextField(50,50,String("/" + String(_needCount)));
        _txtWhite.setFormat(CTextField.BOLD18, 16,  ManagerFilters.BLUE_COLOR);
        _txtWhite.alignH = Align.LEFT;
        _txtOrange = new CTextField(50,50,'');
        _txtOrange.setFormat(CTextField.BOLD18, 16, ManagerFilters.RED_TXT_NEW);
        _txtOrange.alignH = Align.LEFT;
        source.addChild(_txtWhite);
        source.addChild(_txtOrange);
        var userCount:int = g.userInventory.getCountResourceById(g.allData.getResourceById(obId).id);
        _txtOrange.text = String(userCount);
        if (userCount >= needCount) _txtOrange.changeTextColor = ManagerFilters.BLUE_COLOR;
            else _txtOrange.changeTextColor = ManagerFilters.RED_TXT_NEW;
        _txtOrange.x = 36;
        _txtOrange.y = 55;
        _txtWhite.x = _txtOrange.x + _txtOrange.textBounds.width - 4;
        _txtWhite.y = 55;
        if (!g.allData.getResourceById(obId)) {
            Cc.error('FabricHintItem error: g.dataResource.objectResources[obId] = null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'fabricHintItem');
            return;
        }
        if (g.allData.getResourceById(obId).buildType == BuildType.PLANT)  _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(obId).imageShop + '_icon'));
        else if (g.allData.getResourceById(obId).buildType == BuildType.RESOURCE) _image = new Image(g.allData.atlas[g.allData.getResourceById(obId).url].getTexture(g.allData.getResourceById(obId).imageShop));
        if (_image) {
            source.addChild(_image);
            MCScaler.scale(_image, 40, 40);
            _image.x = 50 - _image.width / 2;
            _image.y = 50 - _image.height / 2;
        } else {
            Cc.error('no such image: ' + g.allData.getResourceById(obId).imageShop + ' for id: ' +  obId);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'fabricHintItem');
        }
        if (showPlus) {
            _txtPlus = new CTextField(20,20,String("+"));
            _txtPlus.setFormat(CTextField.BOLD24, 24,  ManagerFilters.BLUE_COLOR);
            _txtPlus.x = 14;
            _txtPlus.y = 38;
            source.addChild(_txtPlus);
        }
    }

    public function updateCount():void {
        var userCount:int = g.userInventory.getCountResourceById(g.allData.getResourceById(_id).id);
        userCount -= _needCount;
        if (userCount >= _needCount) _txtOrange.changeTextColor = ManagerFilters.GREEN_COLOR;
            else _txtOrange.changeTextColor = ManagerFilters.RED_TXT_NEW;
    }

    public function deleteIt():void {
        if (!source) return;
        source.removeChild(_txtOrange);
        _txtOrange.deleteIt();
        source.removeChild(_txtWhite);
        _txtWhite.deleteIt();
        if (_txtPlus) {
            source.removeChild(_txtPlus);
            _txtPlus.deleteIt();
        }
        source.dispose();
        source = null;
    }
}
