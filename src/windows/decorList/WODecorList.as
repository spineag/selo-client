/**
 * Created by user on 7/4/18.
 */
package windows.decorList {
import data.BuildType;

import manager.ManagerFilters;

import social.SocialNetworkEvent;

import starling.animation.Tween;

import starling.display.Image;

import starling.display.Quad;

import starling.display.Sprite;
import starling.utils.Align;
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

public class WODecorList extends WindowMain {
    private var _nameTxt:CTextField;
    private var _descriptionTxt:CTextField;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrItem:Array;
    private var _contClipRect:Sprite;
    private var _contItem:Sprite;
    private var _bgY:BackgroundYellowOut;
    private var _tabs:CoinsTabs;
    private var _isAll:Boolean;
    private var _arrDecorOnMap:Array;
    private var _arrDecorOnInventory:Array;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _shift:int;
    private var _txtPage:CTextField;
    private var _txtYellowPanel:CTextField;

    public function WODecorList() {
        super();
        _windowType = WindowsManager.WO_DECOR_LIST;
        _woWidth = 680;
        _woHeight = 560;

        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBGNew);
        _bgY = new BackgroundYellowOut(540, 280);
        _bgY.x = -270;
        _bgY.y = -40;
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
        _descriptionTxt.y = -165;
        _source.addChild(_descriptionTxt);

        _contClipRect = new Sprite();
        _contClipRect.mask = new Quad(524,300);
        _contClipRect.x = -_woWidth / 2 + 101;
        _contClipRect.y = -_woHeight / 2 + 140;
        _source.addChild(_contClipRect);
        _contItem = new Sprite();
        _contClipRect.addChild(_contItem);
        _contClipRect.x = -265;
        _contClipRect.y = -20;
        _arrItem = [];
        _isAll = true;
        _txtPage = new CTextField(300, 60, '5/10');
        _txtPage.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtPage.alignH = Align.LEFT;
        _txtPage.x = -25;
        _txtPage.y = 225;
        _source.addChild(_txtPage);

        _txtYellowPanel = new CTextField(500, 60, 'Пока нет Декора');
        _txtYellowPanel.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtYellowPanel.alignH = Align.LEFT;
        _txtYellowPanel.x = -180;
        _txtYellowPanel.y = 50;
        _source.addChild(_txtYellowPanel);
        createArrows();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _tabs.activate(_isAll);
        _arrDecorOnMap = g.townArea.getCityObjectsAllDecor();
        _arrDecorOnInventory = g.userInventory.getArraDecorInventory();
        show(true);
    }

    private function onTabClick():void {
        _isAll = !_isAll;
        _tabs.activate(_isAll);
        _arrItem = [];
        _contItem.removeChildren();
        show();
    }

    private function show(needShow:Boolean = false):void {
        var decorListItem:WODecorListItem;
        var i:int;
        _shift = 0;
        animList();
        if (_isAll) {
            for (i = 0; i < _arrDecorOnMap.length; i++) {
                decorListItem = new WODecorListItem(_arrDecorOnMap[i].id, _arrDecorOnMap[i].count, _isAll);
                decorListItem.source.x = 5 + (i) * 173;
//                decorListItem.source.y = 229;
                _contItem.addChild(decorListItem.source);
                _arrItem.push(decorListItem);
            }
            if (_arrItem.length <= 0) {
                _txtYellowPanel.visible = true;
                _txtYellowPanel.text = 'Пока нет Декора';
            }
            else _txtYellowPanel.visible = false;
        } else {
            for (i = 0; i < _arrDecorOnInventory.length; i++) {
                decorListItem = new WODecorListItem(int(_arrDecorOnInventory[i].id), _arrDecorOnInventory[i].count, _isAll);
                decorListItem.source.x = 5 + i * 173;
//                decorListItem.source.y = 229;
                _contItem.addChild(decorListItem.source);
                _arrItem.push(decorListItem);
            }
            if (_arrItem.length <= 0) {
                _txtYellowPanel.visible = true;
                _txtYellowPanel.text = 'Пока нет Декора в Инвентаре';
            }
            else _txtYellowPanel.visible = false;
        }

        checkArrows();
        if (needShow) super.showIt();
    }

    private function createArrows():void {
        _leftArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.alignPivot();
        _leftArrow.addChild(im);
        _leftArrow.clickCallback = onClickLeft;
        _source.addChild(_leftArrow);
        _leftArrow.x = -300;
        _leftArrow.y = 100;
//        _leftArrow.visible = false;
        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX = -1;
        im.alignPivot();
        _rightArrow.addChild(im);
        _rightArrow.clickCallback = onClickRight;
        _source.addChild(_rightArrow);
        _rightArrow.x = 300;
        _rightArrow.y = 100;
//        _rightArrow.visible = false;
        checkArrows();
    }

    private function checkArrows():void {
        if ((_shift+1)*3 >= int(_arrItem.length)) _rightArrow.visible = false;
        else _rightArrow.visible = true;
        if (_shift <= 0) _leftArrow.visible = false;
        else _leftArrow.visible = true;
        updateTxtPages();
    }

    private function updateTxtPages():void {
        if (_arrItem.length <= 0) _txtPage.visible = false;
        else  _txtPage.visible = true;
        var maxPage:int = int(_arrItem.length / 3);
        if (_arrItem.length % 3) maxPage++;
        _txtPage.text = String(_shift+1) + "/" + String(maxPage);
    }

    private function onClickRight():void {
        _shift++;
        animList();
    }

    private function onClickLeft():void {
        if (_shift <=0 ) return;
        _shift--;
        animList();
    }

    private function animList():void {
        var tween:Tween = new Tween(_contItem, .5);
        tween.moveTo(-_shift*524,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);
        checkArrows();
    }

    override protected function deleteIt():void {
        super.deleteIt();
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
        _imActiveAmbar.x = 203;
        _imActiveAmbar.y = 10;
        bg.addChild(_imActiveAmbar);
        _txtActiveAmbar = new CTextField(154, 48, g.managerLanguage.allTexts[332]);
        _txtActiveAmbar.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtActiveAmbar.x = 127;
        _txtActiveAmbar.y = -50;
        bg.addChild(_txtActiveAmbar);

        _unactiveAmbar = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_small'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        _unactiveAmbar.addChild(im);
        _unactiveAmbar.x = 203;
        _unactiveAmbar.y = 10;
        bg.addChildAt(_unactiveAmbar, 0);
        _unactiveAmbar.endClickCallback = onClick;
        _txtUnactiveAmbar = new CTextField(154, 48, g.managerLanguage.allTexts[332]);
        _txtUnactiveAmbar.setFormat(CTextField.BOLD24, 22, ManagerFilters.BROWN_COLOR, Color.WHITE);
        _txtUnactiveAmbar.x = 127;
        _txtUnactiveAmbar.y = -42;
        bg.addChild(_txtUnactiveAmbar);

        _imActiveSklad = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_big'));
        _imActiveSklad.pivotX = _imActiveSklad.width/2;
        _imActiveSklad.pivotY = _imActiveSklad.height;
        _imActiveSklad.x = 367;
        _imActiveSklad.y = 10;
        bg.addChild(_imActiveSklad);
        _txtActiveSklad = new CTextField(154, 48, g.managerLanguage.allTexts[1684]);
        _txtActiveSklad.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtActiveSklad.x = 287;
        _txtActiveSklad.y = -50;
        bg.addChild(_txtActiveSklad);

        _unactiveSklad = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_small'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        _unactiveSklad.addChild(im);
        _unactiveSklad.x = 367;
        _unactiveSklad.y = 10;
        bg.addChildAt(_unactiveSklad, 0);
        _unactiveSklad.endClickCallback = onClick;
        _txtUnactiveSklad = new CTextField(154, 48, g.managerLanguage.allTexts[1684]);
        _txtUnactiveSklad.setFormat(CTextField.BOLD24, 22, ManagerFilters.BROWN_COLOR, Color.WHITE);
        _txtUnactiveSklad.x = 287;
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