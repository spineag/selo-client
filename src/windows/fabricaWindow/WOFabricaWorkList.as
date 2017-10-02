/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import build.fabrica.Fabrica;
import com.junkbyte.console.Cc;
import resourceItem.ResourceItem;
import manager.Vars;
import starling.display.Sprite;
import windows.WindowsManager;

public class WOFabricaWorkList {
    public var maxCount:int;
    private var _arrItems:Array;
    public var arrRecipes:Array;
    private var _parent:Sprite;
    private var _fabrica:Fabrica;
    private var _woFabrica:WOFabrica;

    private var g:Vars = Vars.getInstance();

    public function WOFabricaWorkList(s:Sprite, woFabrica:WOFabrica = null) {
        _woFabrica = woFabrica;
        _parent = s;
        _arrItems = [];
        arrRecipes = [];
        createItems();
    }

    private function createItems():void {
        var item:WOFabricaWorkListItem;
        item = new WOFabricaWorkListItem(WOFabricaWorkListItem.BIG_CELL, 0, _woFabrica);
        item.source.y = 25;
        _parent.addChild(item.source);
        _arrItems.push(item);
        for (var i:int = 0; i < 8; i++) {
            item = new WOFabricaWorkListItem(WOFabricaWorkListItem.SMALL_CELL, i+1, _woFabrica);
            item.source.x = 120 + (i%4)*94;
            item.source.y = 25 + int(i/4)*94;
            _parent.addChild(item.source);
            _arrItems.push(item);
        }
    }

    public function fillIt(arrCurList:Array, fabrica:Fabrica):void {
        try {
            for (var i:int = 0; i < arrCurList.length; i++) { addResource(arrCurList[i]); }
            _fabrica = fabrica;
            maxCount = _fabrica.dataBuild.countCell;
            if (maxCount < 9) {
                var price:int = 6 + (maxCount - g.allData.getBuildingById(_fabrica.dataBuild.id).startCountCell)*3;
                (_arrItems[maxCount] as WOFabricaWorkListItem).showBuyPropose(price, onBuyNewCell);
            }
            for (i=1; i<maxCount; i++) {
                _arrItems[i].source.visible = true;
            }
        } catch (e:Error) {
            Cc.error('WOFabricaWorkList fillit error: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woFabricaWorkList');
        }
    }
    
    public function butNewCellFromWO():void {
        (_arrItems[maxCount] as WOFabricaWorkListItem).removePropose();
        onBuyNewCell();
    }

    private function onBuyNewCell():void {
        maxCount++;
        _fabrica.onBuyNewCell();
        if (maxCount < 9) {
            var price:int = priceForNewCell;
            (_arrItems[maxCount] as WOFabricaWorkListItem).showBuyPropose(price, onBuyNewCell);
        }
    }

    public function onSkip():void {
        _fabrica.skipRecipe();
        var ar:Array = arrRecipes.slice(1); // don't use first recipe, because it was just skipped
        arrRecipes.length = 0;
        for (var i:int = 0; i < _arrItems.length; i++) {
            (_arrItems[i] as WOFabricaWorkListItem).unfillIt();
        }
        fillIt(ar, _fabrica);
    }

    private function onSkipSmall(number:int):void {
        _fabrica.skipSmallRecipe(number);
        arrRecipes.splice(number, 1);
        var ar:Array = arrRecipes.slice();
        arrRecipes.length = 0;
        for (var i:int = 0; i < _arrItems.length; i++) {
            (_arrItems[i] as WOFabricaWorkListItem).unfillIt();
        }
        fillIt(ar, _fabrica);
    }

    public function get isFull():Boolean { return arrRecipes.length >= maxCount; }
    public function get priceForNewCell():int { return 6 + (maxCount - g.allData.getBuildingById(_fabrica.dataBuild.id).startCountCell)*3; }
    private function activateTimer():void { (_arrItems[0] as WOFabricaWorkListItem).activateTimer(onFinishTimer); }

    public function addResource(resource:ResourceItem, buy:Boolean = false):void {
        (_arrItems[arrRecipes.length] as WOFabricaWorkListItem).fillData(resource, buy);
        arrRecipes.push(resource);
        if (arrRecipes.length == 1) {
            activateTimer();
            (_arrItems[0] as WOFabricaWorkListItem).skipCallback = onSkip;
        } else {
            for (var i:int = 1; i < arrRecipes.length; i++) {
                (_arrItems[i] as WOFabricaWorkListItem).skipSmallCallback = onSkipSmall;
            }
        }
    }

    private function onFinishTimer():void {
        var i:int;
        for (i=0; i<_arrItems.length; i++) {
            (_arrItems[i] as WOFabricaWorkListItem).unfillIt();
            visibleSource();
        }
        arrRecipes.shift();
        if (arrRecipes.length) {
            for (i=0; i<arrRecipes.length; i++) {
                (_arrItems[i] as WOFabricaWorkListItem).fillData(arrRecipes[i]);
            }
            activateTimer();
        }
    }

    private function visibleSource():void {
        if (maxCount < 9) {
            var price:int = 6 + (maxCount - g.allData.getBuildingById(_fabrica.dataBuild.id).startCountCell)*3;
            (_arrItems[maxCount] as WOFabricaWorkListItem).showBuyPropose(price, onBuyNewCell);
        }
        for (var i:int=1; i<maxCount; i++) {
            _arrItems[i].source.visible = true;
        }
    }

    public function deleteIt():void {
        arrRecipes.length = 0;
        for (var i:int = 0; i < _arrItems.length; i++) {
            _parent.removeChild(_arrItems[i].source);
            (_arrItems[i] as WOFabricaWorkListItem).deleteIt();
        }
        _arrItems.length = 0;
        _fabrica = null;
        _parent = null;
    }

    public function getSkipBtnProperties():Object {
        if (_arrItems.length)  return (_arrItems[0] as WOFabricaWorkListItem).getSkipBtnProperties();
        else return {};
    }
}
}
