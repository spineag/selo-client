
package windows.cave {
import com.junkbyte.console.Cc;

import manager.ManagerFilters;
import manager.ManagerLanguage;

import starling.display.Image;
import starling.display.Sprite;

import utils.CTextField;

import windows.WOComponents.BackgroundPlant;
import windows.WOComponents.WindowBackgroundFabrica;
import windows.WindowMain;
import windows.WindowsManager;

public class WOCave extends WindowMain {
    private var _arrItems:Array;
    private var _topBG:Sprite;
    private var _bgPlant:WindowBackgroundFabrica;
    private var _txtWindowName:CTextField;

    public function WOCave() {
        super();
        _windowType = WindowsManager.WO_CAVE;
        _woWidth = 380;
        _woHeight = 200;
//        createBG();
        _bgPlant = new WindowBackgroundFabrica(_woWidth, _woHeight,60);
//        _bgPlant.x = -_woWidth/2;
//        _bgPlant.y = -_woHeight/2;
        _source.addChild(_bgPlant);
        _txtWindowName = new CTextField(380, 50, String(g.managerLanguage.allTexts[160]));
        _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        if (g.user.language == ManagerLanguage.ENGLISH) _txtWindowName.x = -_txtWindowName.textBounds.width-80;
        else _txtWindowName.x = -_txtWindowName.textBounds.width-50;
        _txtWindowName.y = -100;
        _source.addChild(_txtWindowName);
        createCaveItems();
        _callbackClickBG = hideIt;
    }

    private function createBG():void {
        _topBG = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_l'));
        _topBG.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_r'));
        im.x = _woWidth - im.width;
        _topBG.addChild(im);
        for (var i:int=0; i<6; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_c'));
            im.x = 50*(i+1);
            _topBG.addChildAt(im, 0);
        }
        _topBG.x = -_woWidth/2;
        _topBG.y = -_woHeight/2 + 80;
        _source.addChild(_topBG);
    }

    private function createCaveItems():void {
        var item:CaveItem;
        _arrItems = [];
        for (var i:int = 0; i < 3; i++) {
            item = new CaveItem(this);
            item.setCoordinates(-_woWidth/2 + 84 + i*107, -_woHeight/2 + 180);
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        try {
            var f1:Function = function (id:int):void {
                if (callback != null) {
                    callback.apply(null, [id]);
                }
//                isCashed = false;
                g.windowsManager.uncasheWindow();
                hideIt();
            };
            var arrIds:Array = params[0];
            var delay:Number = .1;
            for (var i:int = 0; i < arrIds.length; i++) {
                _arrItems[i].fillData(g.allData.getResourceById(arrIds[i]), f1);
                _arrItems[i].showAnimateIt(delay);
                delay += .1;
            }
            super.showIt();
        } catch(e:Error) {
            Cc.error('WOCave fillIt error: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woCave');
        }
    }
    
    override protected function deleteIt():void {
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        super.deleteIt();
    }
}
}
