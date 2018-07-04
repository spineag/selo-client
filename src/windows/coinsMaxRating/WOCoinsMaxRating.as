/**
 * Created by user on 7/3/18.
 */
package windows.coinsMaxRating {
import manager.ManagerFilters;

import social.SocialNetworkEvent;

import starling.display.Sprite;
import starling.utils.Color;

import user.Someone;

import utils.CButton;

import utils.CTextField;

import windows.WOComponents.BackgroundWhiteIn;

import windows.WOComponents.BackgroundYellowOut;

import windows.WOComponents.DefaultVerticalScrollSprite;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOCoinsMaxRating extends WindowMain {
    private var _nameTxt:CTextField;
    private var _descriptionTxt:CTextField;
    private var _arrRating:Array;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrItem:Array;
    private var _srcEvent:Sprite;
    private var _bgY:BackgroundYellowOut;
    private var _tabs:CoinsTabs;
    private var _isAll:Boolean;

    public function WOCoinsMaxRating() {
        super();
        _windowType = WindowsManager.WO_COINS_MAX_RATING;
        _woWidth = 680;
        _woHeight = 600;

        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBGNew);
        _bgY = new BackgroundYellowOut(660, 350);
        _bgY.x = -330;
        _bgY.y = -65;
        _bgY.source.touchable = true;
        _source.addChild(_bgY);
        _tabs = new CoinsTabs(_bgY, onTabClick);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

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
        _isAll = true;
    }

    override public function showItParams(callback:Function, params:Array):void {
        var arr:Array = g.managerCafe.getFriendArrayUsers();
        g.server.getUserCoinsMaxFriendRating(arr, null);

        g.server.getUserCoinsMaxRating(showAll);
        _tabs.activate(_isAll);
    }

    private function onTabClick():void {
        _isAll = !_isAll;
        _tabs.activate(_isAll);
        _arrItem = [];
        _scrollSprite.resetAll();
        if (_isAll) {
            showAll(false);
        }
       else {
            showFriend(false);
        }
    }

    private function showFriend(needShow:Boolean = false):void {
        var cafeItem:WOCoinsMaxRatingItem;
        for (var i:int =0; i < g.managerFarmStandCoinsMaxRating.arrCoinsMaxRatingFriend.length; i ++) {
            cafeItem = new WOCoinsMaxRatingItem(i+1, g.managerFarmStandCoinsMaxRating.arrCoinsMaxRatingFriend[i].userId, g.managerFarmStandCoinsMaxRating.arrCoinsMaxRatingFriend[i].count, g.managerFarmStandCoinsMaxRating.arrCoinsMaxRatingFriend[i].userSocialId);
            _scrollSprite.addNewCell(cafeItem.source);
            _arrItem.push(cafeItem);
        }
        checkSocialInfoForArray();
        if (needShow) super.showIt();
    }

    private function showAll(needShow:Boolean = false):void {
        var cafeItem:WOCoinsMaxRatingItem;
        for (var i:int =0; i < g.managerFarmStandCoinsMaxRating.arrCoinsMaxRating.length; i ++) {
            cafeItem = new WOCoinsMaxRatingItem(i+1,g.managerFarmStandCoinsMaxRating.arrCoinsMaxRating[i].userId, g.managerFarmStandCoinsMaxRating.arrCoinsMaxRating[i].count, g.managerFarmStandCoinsMaxRating.arrCoinsMaxRating[i].userSocialId);
            _scrollSprite.addNewCell(cafeItem.source);
            _arrItem.push(cafeItem);
        }
        checkSocialInfoForArray();
        if (needShow) super.showIt();
    }

    override protected function deleteIt():void {
        if (_nameTxt) {
            _nameTxt.deleteIt();
            _nameTxt.dispose();
        }
        super.deleteIt();
    }

    private function checkSocialInfoForArray():void {
        var userIds:Array = [];
        var p:Someone;
        var arr:Array;
        if (_isAll) arr = g.managerFarmStandCoinsMaxRating.arrCoinsMaxRating.slice();
        else arr = g.managerFarmStandCoinsMaxRating.arrCoinsMaxRatingFriend.slice();
        for (var i:int=0; i < arr.length; i++) {
            p = g.user.getSomeoneBySocialId(arr[i].userSocialId);
            if (!p.photo && userIds.indexOf(arr[i].userSocialId) == -1 && arr[i].userSocialId != g.user.userSocialId) userIds.push(arr[i].userSocialId);
            else if (p.photo && arr[i].userSocialId != g.user.userSocialId) userIds.push(arr[i].userSocialId);
        }
        if (userIds.length) {
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingInfo);
            g.socialNetwork.getTempUsersInfoById(userIds);
        }
    }

    private function onGettingInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingInfo);
        for (var i:int = 0; i < _arrItem.length; i++) {
            (_arrItem[i] as WOCoinsMaxRatingItem).updateAvatar();
        }
    }
}
}


import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import windows.WOComponents.BackgroundYellowOut;

internal class CoinsTabs {
    private var g:Vars = Vars.getInstance();
    private var _callback:Function;
    private var _imActiveAmbar:Image;
    private var _txtActiveAmbar:CTextField;
    private var _unactiveAmbar:CSprite;
    private var _txtUnactiveAmbar:CTextField;
    private var _imActiveSklad:Image;
    private var _txtActiveSklad:CTextField;
    private var _unactiveSklad:CSprite;
    private var _txtUnactiveSklad:CTextField;
    private var _bg:BackgroundYellowOut;

    public function CoinsTabs(bg:BackgroundYellowOut, f:Function) {
        _bg = bg;
        _callback = f;
        _imActiveAmbar = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_big'));
        _imActiveAmbar.pivotX = _imActiveAmbar.width/2;
        _imActiveAmbar.pivotY = _imActiveAmbar.height;
        _imActiveAmbar.x = 253;
        _imActiveAmbar.y = 10;
        bg.addChild(_imActiveAmbar);
        _txtActiveAmbar = new CTextField(154, 48, g.managerLanguage.allTexts[332]);
        _txtActiveAmbar.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtActiveAmbar.x = 177;
        _txtActiveAmbar.y = -50;
        bg.addChild(_txtActiveAmbar);

        _unactiveAmbar = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_small'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        _unactiveAmbar.addChild(im);
        _unactiveAmbar.x = 253;
        _unactiveAmbar.y = 10;
        bg.addChildAt(_unactiveAmbar, 0);
        _unactiveAmbar.endClickCallback = onClick;
        _txtUnactiveAmbar = new CTextField(154, 48, g.managerLanguage.allTexts[332]);
        _txtUnactiveAmbar.setFormat(CTextField.BOLD24, 24, ManagerFilters.BROWN_COLOR, Color.WHITE);
        _txtUnactiveAmbar.x = 177;
        _txtUnactiveAmbar.y = -42;
        bg.addChild(_txtUnactiveAmbar);

        _imActiveSklad = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_big'));
        _imActiveSklad.pivotX = _imActiveSklad.width/2;
        _imActiveSklad.pivotY = _imActiveSklad.height;
        _imActiveSklad.x = 417;
        _imActiveSklad.y = 10;
        bg.addChild(_imActiveSklad);
        _txtActiveSklad = new CTextField(154, 48, g.managerLanguage.allTexts[485]);
        _txtActiveSklad.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtActiveSklad.x = 337;
        _txtActiveSklad.y = -50;
        bg.addChild(_txtActiveSklad);

        _unactiveSklad = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_small'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        _unactiveSklad.addChild(im);
        _unactiveSklad.x = 417;
        _unactiveSklad.y = 10;
        bg.addChildAt(_unactiveSklad, 0);
        _unactiveSklad.endClickCallback = onClick;
        _txtUnactiveSklad = new CTextField(154, 48, g.managerLanguage.allTexts[485]);
        _txtUnactiveSklad.setFormat(CTextField.BOLD24, 24, ManagerFilters.BROWN_COLOR, Color.WHITE);
        _txtUnactiveSklad.x = 337;
        _txtUnactiveSklad.y = -42;
        bg.addChild(_txtUnactiveSklad);
    }

    private function onClick():void { if (_callback!=null) _callback.apply(); }

    public function activate(isAmbar:Boolean):void {
        _imActiveAmbar.visible = _unactiveSklad.visible = isAmbar;
        _imActiveSklad.visible = _unactiveAmbar.visible = !isAmbar;
        _txtActiveAmbar.visible = _txtUnactiveSklad.visible = isAmbar;
        _txtActiveSklad.visible = _txtUnactiveAmbar.visible = !isAmbar;
    }

    public function deleteIt():void {
        _bg.removeChild(_txtActiveAmbar);
        _bg.removeChild(_txtActiveSklad);
        _bg.removeChild(_txtUnactiveSklad);
        _bg.removeChild(_txtUnactiveAmbar);
        _bg.removeChild(_imActiveAmbar);
        _bg.removeChild(_imActiveSklad);
        _bg.removeChild(_unactiveAmbar);
        _bg.removeChild(_unactiveSklad);
        _txtActiveAmbar.deleteIt();
        _txtActiveSklad.deleteIt();
        _txtUnactiveAmbar.deleteIt();
        _txtUnactiveSklad.deleteIt();
        _imActiveAmbar.dispose();
        _imActiveSklad.dispose();
        _unactiveAmbar.deleteIt();
        _unactiveSklad.deleteIt();
        _bg = null;
    }

}
