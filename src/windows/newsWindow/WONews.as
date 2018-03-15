/**
 * Created by user on 2/20/18.
 */
package windows.newsWindow {
import manager.ManagerFilters;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;

import utils.CButton;

import utils.CTextField;

import windows.WOComponents.BackgroundYellowOut;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WONews extends WindowMain {
    private var _nameTxt:CTextField;
    private var _bigYellowBG:BackgroundYellowOut;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _txtPageNumber:CTextField;
    private var _contClipRect:Sprite;
    private var _contItem:Sprite;
    private var _arrItems:Array;
    private var _shift:int;
    private var _arrNews:Array;

    public function WONews() {
        super();
        _windowType = WindowsManager.WO_NEWS;
        _woWidth = 625;
        _woHeight = 600;

        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBGNew);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        _nameTxt = new CTextField(300, 60, g.managerLanguage.allTexts[1279]);
        _nameTxt.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _nameTxt.x = -150;
        _nameTxt.y = -_woHeight/2 + 25;
        _source.addChild(_nameTxt);

        _bigYellowBG = new BackgroundYellowOut(500, 450);
        _bigYellowBG.x = -_bigYellowBG.width/2+5;
        _bigYellowBG.y = -_woHeight / 2 + 115;

        _source.addChild(_bigYellowBG);

        _txtPageNumber = new CTextField(120, 30, '0/0');
        _txtPageNumber.setFormat(CTextField.BOLD18, 18, ManagerFilters.BROWN_COLOR);
        _txtPageNumber.cacheIt = false;
        _txtPageNumber.x = -60;
        _txtPageNumber.y = 262;
        _source.addChild(_txtPageNumber);
        _contClipRect = new Sprite();
        _contClipRect.mask = new Quad(500,450);
        _contClipRect.x = -_bigYellowBG.width/2+5;
        _contClipRect.y = -_woHeight / 2 + 115;
        _source.addChild(_contClipRect);
        _contItem = new Sprite();
        _contClipRect.addChild(_contItem);
    }

    override public function showItParams(callback:Function, params:Array):void {
        var newsItem:WONewsItem;
        _arrNews = g.managerNews.arrNews.slice();
        _arrItems = [];
        _shift = 0;
        _arrNews.sortOn("id", Array.DESCENDING | Array.NUMERIC);
        for (var i:int = 0; i < _arrNews.length; i++) {
            newsItem = new WONewsItem(_arrNews[i].name, String(_arrNews[i].image), _arrNews[i].textPrev, _arrNews[i].textMain, _arrNews[i].textPs, _arrNews[i].time, _arrNews[i].notification);
            newsItem.source.x = i*500;
            _contItem.addChild(newsItem.source);
            _arrItems.push(newsItem);
        }
        if (_arrNews[0].notification) g.managerNews.addArrNewsNew(_arrNews[0].id);
        if (_arrItems.length > 1) createArrows();
        updateTxtPages();
        super.showIt();

    }

    private function createArrows():void {
        _leftArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.alignPivot();
        _leftArrow.addChild(im);
        _leftArrow.clickCallback = onClickLeft;
        _source.addChild(_leftArrow);
        _leftArrow.x = -282;
        _leftArrow.y = 20;
        _leftArrow.visible = false;
        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX = -1;
        im.alignPivot();
        _rightArrow.addChild(im);
        _rightArrow.clickCallback = onClickRight;
        _source.addChild(_rightArrow);
        _rightArrow.x = 282;
        _rightArrow.y = 20;
        _rightArrow.visible = false;
        checkArrows();
    }

    private function checkArrows():void {
        if ((_shift+1) == _arrItems.length) _rightArrow.visible = false;
        else _rightArrow.visible = true;
        if (_shift == 0) _leftArrow.visible = false;
        else _leftArrow.visible = true;
        updateTxtPages();
    }

    private function updateTxtPages():void {
        if (_arrItems.length <= 0) _txtPageNumber.visible = false;
        _txtPageNumber.text = String(_shift+1) + "/" + String(_arrItems.length);
    }

    private function onClickRight():void {
        _shift++;
        animList();
        for (var i:int = 0; i < g.user.newsNew.length; i++) {
            if (g.user.newsNew[i] == _arrNews[_shift].id) return;
        }
        g.managerNews.addArrNewsNew(_arrNews[_shift].id);
//        var st:String = g.managerParty.userParty.tookGift[0] + '&' + g.managerParty.userParty.tookGift[1] + '&' + g.managerParty.userParty.tookGift[2] + '&'
//                + g.managerParty.userParty.tookGift[3] + '&' + g.managerParty.userParty.tookGift[4];
    }

    private function onClickLeft():void {
        _shift--;
        animList();
    }

    private function animList():void {
        var tween:Tween = new Tween(_contItem, .5);
        tween.moveTo(-_shift*500,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);
        checkArrows();
    }

    override protected function deleteIt():void {
       if (_nameTxt) {
           _nameTxt.deleteIt();
           _nameTxt.dispose();
       }

        if (_leftArrow) {
            _leftArrow.deleteIt();
            _leftArrow.dispose();
        }
        if (_rightArrow) {
            _rightArrow.deleteIt();
            _rightArrow.dispose();
        }
        if (_txtPageNumber) {
            _txtPageNumber.deleteIt();
            _txtPageNumber.dispose();
        }
        if (_contClipRect) {
            _contClipRect.dispose();
            _contClipRect = null;
        }
        if (_contItem) {
            _contItem.dispose();
            _contItem = null;
        }
        super.deleteIt();
    }
}
}
