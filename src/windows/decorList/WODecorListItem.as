/**
 * Created by user on 7/4/18.
 */
package windows.decorList {
import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import manager.Vars;

import org.osmf.layout.HorizontalAlign;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;

import windows.WindowsManager;

import windows.shop_new.WOShop;

public class WODecorListItem {
    public var source:Sprite;
    private var _imItem:Image;
    private var _txtName:CTextField;
    private var _txtCount:CTextField;
    private var _txtCountRating:CTextField;
    private var _imBg:Image;
    private var _btn:CButton;
    private var _id:int;
    private var _map:Boolean;

    private var g:Vars = Vars.getInstance();

    public function WODecorListItem(id:int, count:int, map:Boolean) {
        _map = map;
        _id = id;
        source = new Sprite();
        _imBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_blue_cell'));
        source.addChild(_imBg);
        if (g.allData.getBuildingById(id).image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).image + '_icon');
            if (!texture) {
                if (g.allData.getBuildingById(id).buildType == BuildType.DECOR || g.allData.getBuildingById(id).buildType == BuildType.DECOR_FULL_FENСE || g.allData.getBuildingById(id).buildType == BuildType.DECOR_POST_FENCE || g.allData.getBuildingById(id).buildType == BuildType.DECOR_FENCE_ARKA
                        || g.allData.getBuildingById(id).buildType == BuildType.DECOR_FENCE_GATE || g.allData.getBuildingById(id).buildType == BuildType.DECOR_TAIL || g.allData.getBuildingById(id).buildType == BuildType.TREE || g.allData.getBuildingById(id).buildType == BuildType.DECOR_POST_FENCE_ARKA)
                    texture = g.allData.atlas[g.allData.getBuildingById(id).url].getTexture(g.allData.getBuildingById(id).image);
                else texture = g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).url + '_icon');
            }
            if (!texture) Cc.error('WODecorListItem:: no such texture: ' + g.allData.getBuildingById(id).url + ' for _data.id ' + g.allData.getBuildingById(id).id);
            else {
                _imItem = new Image(texture);
                _imItem.alignPivot();
                _imItem.x = 87;
                _imItem.y = 130;
                _imItem.touchable = false;
                source.addChild(_imItem);
            }
        }

        _txtName = new CTextField(170, 50, g.allData.getBuildingById(id).name);
        _txtName.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtName.y = 5;
        source.addChild(_txtName);
        _txtCount = new CTextField(54, 24, 'x'+String(count));
        _txtCount.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txtCount.alignH = HorizontalAlign.RIGHT;
        _txtCount.x = 95;
        _txtCount.y = 175;
        source.addChild(_txtCount);
        _txtCountRating = new CTextField(54, 24, String(g.allData.getBuildingById(id).ratingCount * count));
        _txtCountRating.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txtCountRating.alignH = HorizontalAlign.RIGHT;
        _txtCountRating.x = -25;
        _txtCountRating.y = 65;
        source.addChild(_txtCountRating);

        _btn = new CButton();
        _btn.addButtonTexture(160, CButton.HEIGHT_32, CButton.GREEN, true);
        _btn.addTextField(160, 30, 0, 0, String(g.managerLanguage.allTexts[312]));
        _btn.setTextFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btn.x = 86;
        _btn.y = 220;
        source.addChild(_btn);
        _btn.clickCallback = onClick;
    }

    private function onClick():void {
        g.windowsManager.closeAllWindows();
        if (_map) {
            var arr:Array = g.townArea.getCityObjectsById(_id);
            g.cont.moveCenterToPos(arr[0].posX, arr[0].posY, false, .5);
            for (var i:int = 0; i < arr.length; i++) {
                arr[i].showArrow(20);
            }
        } else {
            g.user.shiftShop = 0;
            g.user.decorShop = false;
            g.user.shopTab = WOShop.DECOR;
            var f1:Function = function():void {
                if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
                    (g.windowsManager.currentWindow as WOShop).openOnResource(_id, BuildType.DECOR);
                    (g.windowsManager.currentWindow as WOShop).addItemArrow(_id, 9, BuildType.DECOR);
                }
            };
            g.windowsManager.openWindow(WindowsManager.WO_SHOP, null, WOShop.DECOR);
            if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP)
                g.windowsManager.currentWindow.onWoShowCallback = f1;
        }
    }
}
}
