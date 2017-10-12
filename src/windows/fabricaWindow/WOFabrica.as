/**
/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import build.fabrica.Fabrica;
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import resourceItem.ResourceItem;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import utils.CButton;
import utils.CTextField;
import windows.WOComponents.WindowBackgroundFabrica;
import windows.WindowMain;
import windows.WindowsManager;

public class WOFabrica extends WindowMain {
    private var _list:WOFabricaWorkList;
    private var _arrFabricaItems:Array;
    private var _callbackOnClick:Function;
    private var _topBG:WindowBackgroundFabrica;
    private var _shift:int;
    private var _arrAllRecipes:Array;
    private var _fabrica:Fabrica;
    private var _txtWindowName:CTextField;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _mask:Sprite;
    private var _cont:Sprite;
    private var _isAnim:Boolean;
    private var _listCont:Sprite;
    private var _imWhite:Image;

    public function WOFabrica() {
        super();
        _windowType = WindowsManager.WO_FABRICA;
        _woHeight = 532;
        _woWidth = 746;
        _blackAlpha = 0;
        _shift = 0;
        _callbackClickBG = onClickExit;
        _topBG = new WindowBackgroundFabrica(526, 164, 54);
        _topBG.y = -_woHeight/2 + 120;
        _source.addChild(_topBG);
        _txtWindowName = new CTextField(300, 50, '');
        _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtWindowName.x = -150;
        _txtWindowName.y = -_woHeight/2 + 32;
        _source.addChild(_txtWindowName);
        _mask = new Sprite();
        _mask.mask = new Quad(524,100 + 150);
        _mask.x = -268;
        _mask.y = -_woHeight/2 + 88 - 150;
        _cont = new Sprite();
        _mask.addChild(_cont);
        _source.addChild(_mask);
        createArrows();
        _listCont = new Sprite();
        _listCont.x = -_woWidth/2 + 135;
        _listCont.y = -_woHeight/2 + 320;
        _source.addChild(_listCont);
        _list = new WOFabricaWorkList(_listCont, this);
        _imWhite = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plants_factory_white_panel'));
        _imWhite.pivotX = _imWhite.width/2;
        _imWhite.y = 20;
        _source.addChildAt(_imWhite, 1);
    }

    private function createArrows():void {
        _leftArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plants_factory_arrow_red'));
        im.alignPivot();
        _leftArrow.addChild(im);
        _leftArrow.clickCallback = onClickLeft;
        _leftArrow.x = -_woWidth/2 + 84;
        _leftArrow.y = -_woHeight/2 + 148;
        _source.addChild(_leftArrow);

        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plants_factory_arrow_red'));
        im.scaleX = -1;
        im.alignPivot();
        _rightArrow.addChild(im);
        _rightArrow.clickCallback = onClickRight;
        _rightArrow.x = _woWidth/2 - 84;
        _rightArrow.y = -_woHeight/2 + 148;
        _source.addChild(_rightArrow);
    }

    private function onClickExit(e:Event = null):void {
        if (g.tuts.isTuts) return;
        hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        _fabrica = params[2];
        _callbackOnClick = callback;
        _arrAllRecipes = params[0];
        _shift = 0;
        fillFabricaItems();
        _list.fillIt(params[1], _fabrica);
        _txtWindowName.text = _fabrica.dataBuild.name;
        checkArrows();
        super.showIt();
        _source.alpha = 0;
        _source.scale = .1;
        _source.x = params[3].x;
        _source.y = params[3].y;
        TweenMax.to(_source, .3, {alpha:1, scale:1, x: int(g.managerResize.stageWidth/2), y: int(g.managerResize.stageHeight/2), onComplete: onShowingWindow});
    }

    private function fillFabricaItems():void {
        var item:WOItemFabrica;
        _arrFabricaItems = [];
        for (var i:int=0; i<_arrAllRecipes.length; i++) {
            item = new WOItemFabrica();
            item.fillData(_arrAllRecipes[i], onItemClick);
            item.setCoordinates(58 + i*106, 54 + 150);
            _cont.addChild(item.source);
            _arrFabricaItems.push(item);
        }
    }

    private function onClickLeft():void {
        if (_isAnim) return;
        _shift -= 4;
        if (_shift < 0) _shift = 0;
        _isAnim = true;
        TweenMax.to(_cont, .3, {x: -_shift*106, onComplete: function():void {_isAnim = false; checkArrows();} });
    }

    private function onClickRight():void {
        if (_isAnim) return;
        _shift += 4;
        if (_shift > _arrFabricaItems.length - 4) _shift = _arrFabricaItems.length - 4;
        _isAnim = true;
        TweenMax.to(_cont, .3, {x: -_shift*106, onComplete: function():void {_isAnim = false; checkArrows();} });
    }

    private function checkArrows():void {
        _leftArrow.visible = _shift > 0;
        _rightArrow.visible = _shift < _arrFabricaItems.length - 5;
    }

    public function getSkipBtnProperties():Object { return _list.getSkipBtnProperties(); }
    private function onBuyResource(obj:Object, lastRes:Boolean = false):void { onItemClick(obj, lastRes); }

    private function onItemClick(dataRecipe:Object, lastRes:Boolean = false):void {
        var obj:Object;
        if (!lastRes) {
            var fExit:Function = function():void {
                g.windowsManager.uncasheWindow();
            };
            if (_list.arrRecipes.length == 9) {
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_NO_PLACES, onBuyNewCellFromWO, g.managerTimerSkip.newCount(_list.arrRecipes[0].buildTime, _list.arrRecipes[0].leftTime, _list.arrRecipes[0].priceSkipHard),_list.arrRecipes[0].resourceID, fExit, true);
                return;
            } else if (_list.arrRecipes.length == _list.maxCount){
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_NO_PLACES, onBuyNewCellFromWO, _list.priceForNewCell, 0, fExit, false);
                return;
            }
            
            var count:int = 0;
            if (!dataRecipe || !dataRecipe.ingridientsId) {
                Cc.error('UserInventory checkRecipe:: bad _data');
                isCashed = false;
                super.hideIt();
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woFabrica');
                return;
            }
            var i:int;
            for (i = 0; i < dataRecipe.ingridientsId.length; i++) {
                count = g.userInventory.getCountResourceById(int(dataRecipe.ingridientsId[i]));
                if (count < int(dataRecipe.ingridientsCount[i])) {
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    obj = {};
                    obj.data = dataRecipe;
                    obj.count = int(dataRecipe.ingridientsCount[i]) - count;
                    g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onBuyResource, 'menu', obj);
                    return;
                }
            }

            for (i = 0; i < dataRecipe.ingridientsId.length; i++) {
                count = g.userInventory.getCountResourceById(int(dataRecipe.ingridientsId[i]));
                if (g.allData.getResourceById(dataRecipe.ingridientsId[i]).buildType == BuildType.PLANT && count == int(dataRecipe.ingridientsCount[i]) && !g.userInventory.checkLastResource(dataRecipe.ingridientsId[i])) {
                    obj = {};
                    obj.data = dataRecipe;
                    obj.fabrica = _fabrica;
                    obj.callback = _callbackOnClick;
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, onBuyResource, dataRecipe, 'fabrica', obj);
                    return;
                }
            }
        }
        var resource:ResourceItem = new ResourceItem();
        resource.fillIt(g.allData.getResourceById(dataRecipe.idResource));
        _list.addResource(resource, true);
        g.fabricHint.updateItem();
        if (_callbackOnClick != null) {
            _callbackOnClick.apply(null, [resource, dataRecipe]);
        }
    }

    private function onBuyNewCellFromWO():void { // or skip first cell if we can't buy cell
        if (_fabrica.dataBuild.countCell >= 9)  _list.onSkip();
        else  _list.butNewCellFromWO();
    }

    public function addArrowForPossibleRawItems(id:int = 0):void {
        for (var i:int=0; i<_arrFabricaItems.length; i++) {
            if (_arrFabricaItems[i].dataRecipe && _arrFabricaItems[i].dataRecipe.idResource == id || id == 0)(_arrFabricaItems[i] as WOItemFabrica).addArrowIfPossibleToRaw();
        }
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        if (!_source) return;
        for (var i:int = 0; i < _arrFabricaItems.length; i++) {
            _source.removeChild(_arrFabricaItems[i].source);
            (_arrFabricaItems[i] as WOItemFabrica).deleteIt();
        }
        _arrFabricaItems.length = 0;
        if (_list) _list.deleteIt();
        _list = null;
        _fabrica = null;
        _topBG = null;
        _callbackOnClick = null;
        _arrAllRecipes.length = 0;
        _source.removeChild(_leftArrow);
        _leftArrow.deleteIt();
        _source.removeChild(_rightArrow);
        _rightArrow.deleteIt();
        _source.removeChild(_txtWindowName);
        _txtWindowName.deleteIt();
        super.deleteIt();
    }
}
}
