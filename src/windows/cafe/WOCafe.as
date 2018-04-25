/**
 * Created by user on 4/25/18.
 */
package windows.cafe {
import flash.display.Bitmap;

import manager.ManagerFilters;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;

import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;
import starling.display.Quad;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOCafe extends WindowMain{
    private var _nameTxt:CTextField;
    private var _bgImage:Image;
    private var _txtPage:CTextField;
    private var _contClipRect:Sprite;
    private var _contItem:Sprite;
    private var _arrItem:Array;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _shift:int;

    public function WOCafe() {
        super();
        _windowType = WindowsManager.WO_CAFE;
        _woWidth = 680;
        _woHeight = 620;
        _arrItem = [];
    }

    private function onLoadProgres(b:Bitmap):void {
        _bgImage = new Image(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'qui/caffee_window_back.png'].create() as Bitmap));
        _bgImage.x = -_bgImage.width/2;
        _bgImage.y = -_bgImage.height/2;
        _source.addChild(_bgImage);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _nameTxt  = new CTextField(300, 60, g.managerLanguage.allTexts[1279]);
        _nameTxt.setFormat(CTextField.BOLD72, 70, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _nameTxt.x = -150;
        _nameTxt.y = -_woHeight/2 + 25;
        _source.addChild(_nameTxt);
        _contClipRect = new Sprite();
        _contClipRect.mask = new Quad(260,390);
        _contClipRect.x = -_woWidth / 2 + 101;
        _contClipRect.y = -_woHeight / 2 + 140;
        _source.addChild(_contClipRect);
        _contItem = new Sprite();
        _contClipRect.addChild(_contItem);

        var item:WOCafeItem;
        for (var i:int = 0; i < 6; i++) {
            item = new WOCafeItem();
            item.source.x = 5 + (i % 2) * 130;
            item.source.y = 5 + int(i / 2) * 130;
            _contItem.addChild(item.source);
            _arrItem.push(item);
        }

        _txtPage = new CTextField(300, 60, '5/10');
        _txtPage.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtPage.alignH = Align.LEFT;
        _txtPage.x = -130;
        _txtPage.y = 200;
        _source.addChild(_txtPage);
        createArrows();
        super.showIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/caffee_window_back.png', onLoadProgres);
    }

    private function createArrows():void {
        _leftArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.alignPivot();
        _leftArrow.addChild(im);
        _leftArrow.clickCallback = onClickLeft;
        _source.addChild(_leftArrow);
//        _leftArrow.x =;
        _leftArrow.y = 20;
//        _leftArrow.visible = false;
        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX = -1;
        im.alignPivot();
        _rightArrow.addChild(im);
        _rightArrow.clickCallback = onClickRight;
        _source.addChild(_rightArrow);
//        _rightArrow.x = ;
        _rightArrow.y = 20;
//        _rightArrow.visible = false;
        checkArrows();
    }

    private function checkArrows():void {
        if ((_shift+1) == _arrItem.length) _rightArrow.visible = false;
        else _rightArrow.visible = true;
        if (_shift == 0) _leftArrow.visible = false;
        else _leftArrow.visible = true;
        updateTxtPages();
    }

    private function updateTxtPages():void {
        if (_arrItem.length <= 0) _txtPage.visible = false;
        _txtPage.text = String(_shift+1) + "/" + String(_arrItem.length);
    }

    private function onClickRight():void {
        _shift++;
        animList();
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
        super.deleteIt();
    }
}
}
