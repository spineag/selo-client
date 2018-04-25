/**
 * Created by user on 4/18/18.
 */
package windows.cafe {
import manager.ManagerFilters;

import starling.display.Sprite;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;

import windows.WOComponents.BackgroundWhiteIn;

import windows.WOComponents.BackgroundYellowOut;

import windows.WOComponents.DefaultVerticalScrollSprite;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOCafeRating extends WindowMain {
    private var _nameTxt:CTextField;
    private var _descriptionTxt:CTextField;
    private var _arrRating:Array;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrItem:Array;
    private var _srcEvent:Sprite;
    private var _btnFriend:CButton;
    private var _btnAll:CButton;
    private var _bgY:BackgroundYellowOut;
    private var _bgWHite:BackgroundWhiteIn;

    public function WOCafeRating() {
        super();
        _windowType = WindowsManager.WO_CAFE_RATING;
        _woWidth = 680;
        _woHeight = 600;

        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBGNew);
        _bgY = new BackgroundYellowOut(660, 470);
        _bgY.x = -330;
        _bgY.y = -185;
        _source.addChild(_bgY);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        _bgWHite = new BackgroundWhiteIn(360, 68);
        _bgWHite.x = -180;
        _bgWHite.y = -115;
        _source.addChild(_bgWHite);


        _nameTxt = new CTextField(300, 60, g.managerLanguage.allTexts[1279]);
        _nameTxt.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _nameTxt.x = -150;
        _nameTxt.y = -_woHeight/2 + 25;
        _source.addChild(_nameTxt);

        _descriptionTxt = new CTextField(670, 60, g.managerLanguage.allTexts[764]);
        _descriptionTxt.setFormat(CTextField.BOLD72, 70, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _descriptionTxt.x = -335;
        _descriptionTxt.y = -185;
        _source.addChild(_descriptionTxt);

        _arrRating = [];
        _srcEvent = new Sprite();
        _source.addChild(_srcEvent);
        _srcEvent.x = -315;
        _srcEvent.y = -40;
        _scrollSprite = new DefaultVerticalScrollSprite(600, 315, 600, 105);
        _scrollSprite.createScoll(620, 0, 315, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        _srcEvent.addChild(_scrollSprite.source);
        _arrItem = [];

        _btnFriend = new CButton();
        _btnFriend.addButtonTexture(150, CButton.HEIGHT_55, CButton.YELLOW, true);
        _btnFriend.addTextField(150, 49, 0, 0, String(g.managerLanguage.allTexts[485]));
        _btnFriend.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _btnFriend.x = -100;
        _btnFriend.y = -80;
        _source.addChild(_btnFriend);
        _btnFriend.clickCallback = onClickFriend;

        _btnAll = new CButton();
        _btnAll.addButtonTexture(150, CButton.HEIGHT_55, CButton.YELLOW, true);
        _btnAll.addTextField(150, 49, 0, 0, String(g.managerLanguage.allTexts[332]));
        _btnAll.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _btnAll.x = 100;
        _btnAll.y = -80;
        _source.addChild(_btnAll);
        _btnAll.clickCallback = onClickAll;

        _btnFriend.colorBGFilter = ManagerFilters.SMALL_DISABLE_FILTER;
        _btnFriend.isTouchable = false;
        _btnAll.colorBGFilter = null;
        _btnAll.isTouchable = true;
    }

    override public function showItParams(callback:Function, params:Array):void {
        var arr:Array = g.managerCafe.getFriendArrayUsers();
        g.server.getUserCafeRatingFriend(arr, showFriend);
    }

    private function onClickFriend():void {
        _btnFriend.colorBGFilter = ManagerFilters.SMALL_DISABLE_FILTER;
        _btnFriend.isTouchable = false;
        _btnAll.colorBGFilter = null;
        _btnAll.isTouchable = true;
        _arrItem = [];
        _scrollSprite.resetAll();
        showFriend();
    }

    private function onClickAll():void {
        _btnAll.colorBGFilter = ManagerFilters.SMALL_DISABLE_FILTER;
        _btnAll.isTouchable = false;
        _btnFriend.colorBGFilter = null;
        _btnFriend.isTouchable = true;
        _arrItem = [];
        _scrollSprite.resetAll();
        showAll();
    }

    private function showFriend(needShow:Boolean = false):void {
        var cafeItem:WOCafeRatingItem;
        for (var i:int =0; i < g.managerCafe.arrRatingFriend.length; i ++) {
            cafeItem = new WOCafeRatingItem(i+1, g.managerCafe.arrRatingFriend[i].userId, g.managerCafe.arrRatingFriend[i].count);
            _scrollSprite.addNewCell(cafeItem.source);
            _arrItem.push(cafeItem);
        }
        if (needShow) super.showIt();
    }

    private function showAll(needShow:Boolean = false):void {
        var cafeItem:WOCafeRatingItem;
        for (var i:int =0; i < g.managerCafe.arrRating.length; i ++) {
            cafeItem = new WOCafeRatingItem(i+1,g.managerCafe.arrRating[i].userId, g.managerCafe.arrRating[i].count);
            _scrollSprite.addNewCell(cafeItem.source);
            _arrItem.push(cafeItem);
        }
        if (needShow) super.showIt();
    }

    override protected function deleteIt():void {
        if (_nameTxt) {
            _nameTxt.deleteIt();
            _nameTxt.dispose();
        }
        super.deleteIt();
    }
}
}
