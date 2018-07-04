/**
 * Created by user on 4/25/18.
 */
package windows.cafe {
import data.BuildType;

import flash.display.Bitmap;
import flash.geom.Point;

import manager.ManagerFilters;

import resourceItem.newDrop.DropObject;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;

import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;
import starling.display.Quad;

import utils.TimeUtils;

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
    private var _cafeChooseItem:WOCafeChooseItem;
    private var _cafeProgressBar:CafeProgress;
    private var _btnBuy:CButton;

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
        var arr:Array = g.allData.getArrayResourceByType(BuildType.RESOURCE_CAFE);
        var item:WOCafeItem;
        var n:int = 0;
        var y:int = 0;
        for (var i:int = 0; i < arr.length; i++) {
            item = new WOCafeItem(arr[i], clickCallbackChoose, i);
            if (i!= 0 && i%3 ==0) {
                n++;
                y = 0;
            }
            item.source.x = 5 + (n) * 130;
            item.source.y = 5 + y * 130;
            y++;
            _contItem.addChild(item.source);
            _arrItem.push(item);
        }

        _txtPage = new CTextField(300, 60, '5/10');
        _txtPage.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtPage.alignH = Align.LEFT;
        _txtPage.x = -130;
        _txtPage.y = 205;
        _source.addChild(_txtPage);
        createArrows();
        _cafeProgressBar = new CafeProgress(315);
        _cafeProgressBar.source.x = -260;
        _cafeProgressBar.source.y = 260;
        if (!g.user.cafeEnergyCount) {
            g.user.cafeEnergyCount = 10;
            g.server.updateCafeEnergyCount(null);
        }
        _cafeProgressBar.greenProgressBar(g.user.cafeEnergyCount);
        _source.addChild(_cafeProgressBar.source);
        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(100, CButton.HEIGHT_41, CButton.GREEN, true);
        _btnBuy.addTextField(100, 40, 0, 0, String(g.managerLanguage.allTexts[308]));
        _btnBuy.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btnBuy.x = 130;
        _btnBuy.y = 280;
        if (g.user.cafeEnergyCount < 10) _btnBuy.visible = true;
        else _btnBuy.visible = false;
        _source.addChild(_btnBuy);
        _btnBuy.clickCallback = onClick;
        super.showIt();
    }

    private function clickCallbackChoose(number:int):void {
        _contItem.visible = false;
        var arr:Array = g.allData.getArrayResourceByType(BuildType.RESOURCE_CAFE);
        _cafeChooseItem = new WOCafeChooseItem(arr[number], clickCallbackEnd, clickCallbackBuy);
        _source.addChild(_cafeChooseItem.source);
        _leftArrow.visible = false;
        _rightArrow.visible = false;
        _txtPage.visible = false;
    }

    private function onClick():void {
        g.windowsManager.cashWindow = this;
        super.hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_BUY_ENERGY);
        return;
    }

    private function clickCallbackEnd():void {
        _contItem.visible = true;
       checkArrows();
        _txtPage.visible = true;
        _cafeChooseItem.deleteIt();
        _source.removeChild(_cafeChooseItem.source);
    }

    private function clickCallbackBuy(obj:Object):void {
        if (int(obj.energyCount) > g.user.cafeEnergyCount) return;
        if (g.userInventory.currentCountInSklad + 1 > g.user.skladMaxCount) {
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, false);
            return;
        }
        g.userInventory.addResource(obj.ingredientsId[0], -obj.ingredientsCount[0]);
        g.userInventory.addResource(obj.ingredientsId[1], -obj.ingredientsCount[1]);
        g.managerCafe.addCafeEnergy(- int(obj.energyCount));
        g.managerCafe.playerCount +=1;
        g.server.updateUserCafeRating(null);
        var d:DropObject = new DropObject();
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        d.addDropItemNewByResourceId(obj.id, p, 1);
        d.releaseIt(null, false);
        if (g.userTimer.cafeTimer <= 0) g.managerCafe.startNewTimer();
        _btnBuy.visible = true;
        _cafeProgressBar.greenProgressBar(g.user.cafeEnergyCount);
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
        _leftArrow.x = -270;
        _leftArrow.y = 20;
//        _leftArrow.visible = false;
        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX = -1;
        im.alignPivot();
        _rightArrow.addChild(im);
        _rightArrow.clickCallback = onClickRight;
        _source.addChild(_rightArrow);
        _rightArrow.x = 50;
        _rightArrow.y = 20;
//        _rightArrow.visible = false;
        checkArrows();
    }

    private function checkArrows():void {
        if (_shift+1 >= int(_arrItem.length/4)) _rightArrow.visible = false;
        else _rightArrow.visible = true;
        if (_shift <= 0) _leftArrow.visible = false;
        else _leftArrow.visible = true;
        updateTxtPages();
    }

    private function updateTxtPages():void {
        if (_arrItem.length <= 0) _txtPage.visible = false;
        _txtPage.text = String(_shift+1) + "/" + String(int(_arrItem.length/4));
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
        tween.moveTo(-_shift*260,0);
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

import starling.display.Sprite;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.TimeUtils;

internal class CafeProgress {
    private var g:Vars = Vars.getInstance();
    public var source:CSprite;
    private var _srcGreenBar:Sprite;
    private var _widthBg:int;
    private var _txtCount:CTextField;
    private var _isHover:Boolean;

    public function CafeProgress(width:int) {
        _widthBg = width;
        source = new CSprite();
        var imLeft:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('energy_sell_1_c_w'));
        source.addChild(imLeft);
        var im:Image;
        for (var i:int = 0; i < width/3; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('energy_sell_2_c_w'));
            im.x = (imLeft.x + imLeft.width) + (i*im.width);
            source.addChild(im);
        }
        var imRight:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('energy_sell_1_c_w'));
        imRight.scaleX = -1;
        imRight.x = im.x + imRight.width;
        source.addChild(imRight);
        _txtCount = new CTextField(316, 60, '5/10 Энергии');
        _txtCount.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txtCount.y = -15;
        source.addChild(_txtCount);
        _isHover = false;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
    }

    public function greenProgressBar(greenCount:int):void {
        _txtCount.text = greenCount +'/10 Энергии';
        if (_srcGreenBar) {
            _srcGreenBar.dispose();
            source.removeChild(_srcGreenBar);
        }
        if (greenCount <= 0) return;
        _srcGreenBar = new Sprite();
        _srcGreenBar.x = 2;
        _srcGreenBar.y = 2;
        source.addChildAt(_srcGreenBar,source.numChildren-1);
        var imLeft:Image;
        var i:int;
        var im:Image;
        var count:int =  greenCount * 11 - 6;
        imLeft = new Image(g.allData.atlas['interfaceAtlas'].getTexture('energy_sell_green_1_c_w'));
        _srcGreenBar.addChild(imLeft);
        for (i = 0; i < count; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('energy_sell_green_2_c_w'));
            im.x = (imLeft.x + imLeft.width) + (i*im.width);
            _srcGreenBar.addChild(im);
        }
        var imRight:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('energy_sell_green_1_c_w'));
        imRight.scaleX = -1;
        imRight.x = im.x + imRight.width;
        _srcGreenBar.addChild(imRight);
    }

    private function onHover():void {
        if (_isHover || g.user.cafeEnergyCount == 10) return;
        g.gameDispatcher.addEnterFrame(startTimer);
        _isHover = true;
    }

    private function onOut():void {
        g.gameDispatcher.removeEnterFrame(startTimer);
        _txtCount.text = g.user.cafeEnergyCount +'/10 Энергии';
        _isHover = false
    }

    private function startTimer():void {
        if (g.userTimer.cafeTimer > 0) {
            _txtCount.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.cafeTimer);
        }
    }
}
