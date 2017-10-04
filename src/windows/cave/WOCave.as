
package windows.cave {
import com.junkbyte.console.Cc;
import starling.display.Image;
import starling.display.Sprite;

import windows.WOComponents.BackgroundPlant;
import windows.WindowMain;
import windows.WindowsManager;

public class WOCave extends WindowMain {
    private var _arrItems:Array;
    private var _topBG:Sprite;
    private var _bgPlant:BackgroundPlant;

    public function WOCave() {
        super();
        _windowType = WindowsManager.WO_CAVE;
        _woWidth = 380;
        _woHeight = 134;
//        createBG();
        _bgPlant = new BackgroundPlant(_woWidth, _woHeight);
        _bgPlant.x = -_woWidth/2;
        _bgPlant.y = -_woHeight/2;
        _source.addChild(_bgPlant);
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
            item.setCoordinates(-_woWidth/2 + 88 + i*107, -_woHeight/2 + 115);
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
