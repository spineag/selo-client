/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import com.junkbyte.console.Cc;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import media.SoundConst;
import quest.ManagerQuest;
import starling.display.Image;
import utils.SimpleArrow;
import tutorial.TutsAction;
import utils.CSprite;
import utils.MCScaler;
import windows.WindowsManager;

public class WOItemFabrica {
    public var source:CSprite;
    private var _icon:Image;
    private var _dataRecipe:Object;
    private var _clickCallback:Function;
    private var _arrow:SimpleArrow;
    private var _defaultY:int;
    private var _maxAlpha:Number;
    private var _isOnHover:Boolean;
    private var g:Vars = Vars.getInstance();

    public function WOItemFabrica() {
        source = new CSprite();
        source.nameIt = 'woItemFabrica';
        source.endClickCallback = onClick;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _isOnHover = false;
        source.isTouchable = false;
        source.visible = false;
    }

    public function setCoordinates(_x:int, _y:int):void {
        _defaultY = _y;
        source.x = _x;
        source.y = _y;
    }

    public function fillData(ob:Object, f:Function):void {
        _dataRecipe = ob;
        if (!_dataRecipe || !g.allData.getResourceById(_dataRecipe.idResource)) {
            Cc.error('WOItemFabrica:: empty _dataRecipe or g.dataResource.objectResources[_dataRecipe.idResource] == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woItemFabrica');
            return;
        }
        _clickCallback = f;
        if (_dataRecipe.blockByLevel == g.user.level + 1) _maxAlpha = .5;
            else if (_dataRecipe.blockByLevel <= g.user.level) _maxAlpha = 1;
            else _maxAlpha = 0;
        fillIcon(g.allData.getResourceById(_dataRecipe.idResource).imageShop);
        if (g.tuts && g.tuts.action == TutsAction.RAW_RECIPE && g.tuts.isTutsResource(_dataRecipe.id)) addArrow();
        if (g.managerQuest && g.managerQuest.activeTask && (g.managerQuest.activeTask.typeAction == ManagerQuest.RAW_PRODUCT || g.managerQuest.activeTask.typeAction == ManagerQuest.CRAFT_PRODUCT )
                && g.managerQuest.activeTask.resourceId == _dataRecipe.idResource) addArrow(3);
    }

    public function get dataRecipe():Object { return _dataRecipe; }

    private function fillIcon(s:String):void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(s));
        if (!_icon) {
            Cc.error('WOItemFabrica fillIcon:: no such image: ' + s);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woItemFabrica');
            return;
        }
//        MCScaler.scale(_icon, 80, 80);
        _icon.alignPivot();
        source.addChild(_icon);
        if (_maxAlpha) source.isTouchable = source.visible = true;
        source.alpha = _maxAlpha;
//        if (g.user.fabricItemNotification.length > 0) {
//            var arr:Array = g.user.fabricItemNotification;
//            var im:Image;
//            for (var i:int = 0; i < arr.length; i++){
//                if (arr[i].id == _dataRecipe.idResource) {
//                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
//                    im.x = _icon.width - im.width/2 + 3;
//                    im.y = _icon.y -14;
//                    source.addChild(im);
//                    g.user.fabricItemNotification.splice(i);
//                }
//            }
//        }
    }

    private function onClick():void {
        if (g.tuts.isTuts && g.tuts.action != TutsAction.RAW_RECIPE) return;
        if (!_dataRecipe) return;
        if (_dataRecipe.blockByLevel > g.user.level) return;

        g.soundManager.playSound(SoundConst.ON_BUTTON_CLICK);
        source.filter = null;
        if (_clickCallback != null)  _clickCallback.apply(null, [_dataRecipe]);
        g.resourceHint.hideIt();
        g.fabricHint.hideIt();
        if (g.tuts && g.tuts.action == TutsAction.RAW_RECIPE && g.tuts.isTutsResource(_dataRecipe.id)) {
            removeArrow();
            g.tuts.currentActionNone();
//            g.tuts.checkTutorialCallback();
        }
    }

    private function onHover():void {
        if (!_dataRecipe) return;
        if (_isOnHover) return;
        _isOnHover = true;
        g.soundManager.playSound(SoundConst.ON_BUTTON_HOVER);
        source.filter = ManagerFilters.YELLOW_STROKE;
        var point:Point = new Point(0, 0);
        var pointGlobal:Point = source.localToGlobal(point);
        if (_dataRecipe.blockByLevel > g.user.level) g.resourceHint.showIt(_dataRecipe.id,source.x - source.width/2, source.y-source.height/2, source, false, true);
            else g.fabricHint.showIt(_dataRecipe, pointGlobal.x - source.width/2, pointGlobal.y - source.height);
    }

    private function onOut():void {
        source.filter = null;
        if (!_dataRecipe) return;
        g.fabricHint.hideIt();
        g.resourceHint.hideIt();
        _isOnHover = false;
    }

    private function removeArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function addArrowIfPossibleToRaw():void {
        if (!_dataRecipe) return;
        removeArrow();
        if (_dataRecipe.blockByLevel > g.user.level) return;
        for (var l:int = 0; l < _dataRecipe.ingridientsId.length; l++) {
            if (g.userInventory.getCountResourceById(int(_dataRecipe.ingridientsId[l])) < int(_dataRecipe.ingridientsCount[l])) {
                break;
            }
        }
        addArrow(3);
    }

    private function addArrow(t:Number=0):void {
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, source);
        _arrow.animateAtPosition(0, -50);
        _arrow.scaleIt(.5);
        if (t>0) _arrow.activateTimer(t, removeArrow);
    }

    public function deleteIt():void {
        g.resourceHint.hideIt();
        g.fabricHint.hideIt();
        removeArrow();
        source.deleteIt();
        source = null;
    }
}
}
