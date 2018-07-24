/**
 * Created by user on 4/4/18.
 */
package windows.miniPartyWindow {
import com.greensock.TweenMax;

import data.BuildType;
import data.DataMoney;

import dragonBones.factories.BuildArmaturePackage;

import manager.ManagerFilters;

import com.greensock.easing.Quad;

import starling.display.Image;

import starling.display.Sprite;

import starling.events.Event;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;

import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;

import windows.WOComponents.BackgroundQuest;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOMiniPartyWindow extends WindowMain{
    private var _woBG:WindowBackgroundNew;
    private var _txtName:CTextField;
    private var _txtDescription:CTextField;
    private var _koleso:Sprite;
    private var _arrItems:Array;
    private var _curActivePosition:int;
    private var _btnRotate:CButton;
    private var _btnRotateRubie:CButton;
    private var _cont:Sprite;
    private var _contItemCraft:Sprite;
    private var _forRubieRotate:Boolean;
    private var _bgYellow:BackgroundQuest;
    private var _isAnimate:Boolean;

    public function WOMiniPartyWindow() {
        _windowType = WindowsManager.WO_MINI_PARTY;
        _woWidth = 500;
        _woHeight = 600;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBG);
        _bgYellow = new BackgroundQuest(485, 80);
        _bgYellow.y = -185;
        _bgYellow.x = -_bgYellow.width/2 +6;
        _source.addChild(_bgYellow);
        _forRubieRotate = false;
        createExitButton(onClickExit);
        _isAnimate = false;
        _callbackClickBG = onClickExit;
        _txtName = new CTextField(450, 70, String(g.managerLanguage.allTexts[g.managerMiniParty.nameMain]));
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txtName.x = -230;
        _txtName.y = -266;
        _source.addChild(_txtName);
        _txtDescription = new CTextField(450, 70, String(g.managerLanguage.allTexts[g.managerMiniParty.descriptionMain]));
        _txtDescription.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtDescription.x = -230;
        _txtDescription.y = -180;
//        _source.addChild(_txtDescription);
        _curActivePosition = 0;
        _cont = new Sprite();
        _cont.y = 70;
        _source.addChild(_cont);
        _koleso = new Sprite();
        _cont.addChild(_koleso);
        var im:Image;
        im = new Image(g.allData.atlas['miniPartyAtlas'].getTexture('event_lucky_wheel_1'));
        im.x = -im.width/2;
        im.y = -im.height/2;

        _koleso.addChild(im);
        _btnRotate = new CButton();
        _btnRotate.addButtonTexture(200, CButton.HEIGHT_41, CButton.GREEN, true);
//        var txt:CTextField = new CTextField(200, 40, String(g.managerLanguage.allTexts[1332]) +  ' ' + String(g.managerMiniParty.countItem));
//        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btnRotate.y = 260;
//        if (g.allData.getResourceById(g.managerMiniParty.idItemEvent[0]).buildType == BuildType.PLANT)im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(g.managerMiniParty.idItemEvent[0]).imageShop + '_icon'));
//        else im = new Image(g.allData.atlas[g.allData.getResourceById(g.managerMiniParty.idItemEvent[0]).url].getTexture(g.allData.getResourceById(g.managerMiniParty.idItemEvent[0]).imageShop));
//        MCScaler.scale(im, 40, 40);
//        var sens:SensibleBlock = new SensibleBlock();
//        sens.textAndImage(txt,im,200);
//        _btnRotate.addSensBlock(sens,0,20);
        _btnRotate.clickCallback = rotateKoleso;
        _source.addChild(_btnRotate);


        _btnRotateRubie = new CButton();
        _btnRotateRubie.addButtonTexture(200, CButton.HEIGHT_41, CButton.GREEN, true);
//        txt = new CTextField(200, 40, String(g.managerLanguage.allTexts[1332]) +  ' 2');
//        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btnRotateRubie.y = 260;
//        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
//        sens = new SensibleBlock();
//        sens.textAndImage(txt,im,200);
//        _btnRotateRubie.addSensBlock(sens,0,20);
        _btnRotateRubie.clickCallback = rotateKoleso;
        _source.addChild(_btnRotateRubie);
        im = new Image(g.allData.atlas['miniPartyAtlas'].getTexture('event_lucky_wheel_3'));
        im.x = -im.width/2;
        im.y = -100;
        _source.addChild(im);
        im = new Image(g.allData.atlas['miniPartyAtlas'].getTexture('event_lucky_wheel_2'));
        im.x = -im.width/2;
        im.y = 19;
        _source.addChild(im);
//        fillItems();
        _contItemCraft = new Sprite();
        _contItemCraft.y = 70;
        _source.addChild(_contItemCraft);
        checkBtn();
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    private function fillItems():void {
        var item:WOMiniPartyItem;
        _arrItems = [];
        for (var i:int=0; i < g.managerMiniParty.idGift.length; i++) {
            item = new WOMiniPartyItem(g.managerMiniParty.idGift[i],g.managerMiniParty.typeGift[i], i, _koleso);
            _arrItems.push(item);
        }
    }

    private function onClickExit(e:Event=null):void {
//        g.gameDispatcher.removeFromTimer(startTimer);
        super.hideIt();
    }

    private function checkBtn():void {
        if (g.userInventory.getCountResourceById(g.managerMiniParty.idItemEvent[0]) < g.managerMiniParty.countItem) {
            _btnRotate.visible = false;
            _btnRotateRubie.visible = true;
            _forRubieRotate = true;
        } else {
            _btnRotate.visible = true;
            _btnRotateRubie.visible = false;
            _forRubieRotate = false;
        }
    }

    private function rotateKoleso():void {
        if (_isAnimate) return;
        if (_forRubieRotate) {
            if (5 > g.user.hardCurrency) {
                g.windowsManager.uncasheWindow();
                super.hideIt();
                g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
                return;
            }
        }
        _isAnimate = true;
        _curActivePosition = int(5 + Math.random()*5); // choose random item position as prise
        var rotation:Number = _curActivePosition * -1.256;
        TweenMax.to(_koleso, 5, {rotation: rotation, ease: Quad.easeInOut, onComplete:completeRotateKoleso});
    }

    private function completeRotateKoleso():void {
        TweenMax.to(_koleso, 1, {rotation: _koleso.rotation, ease: Quad.easeInOut, onComplete:showGiftAnimation, delay:.2});

    }

    private function showGiftAnimation():void {
        _curActivePosition -=5;
        new WOMiniPartyCraftItem(g.managerMiniParty.idGift[_curActivePosition], g.managerMiniParty.typeGift[_curActivePosition], g.managerMiniParty.countGift[_curActivePosition], _contItemCraft, null);
        if (_forRubieRotate) g.userInventory.addMoney(DataMoney.HARD_CURRENCY, - 2);
        else g.userInventory.addResource(g.managerMiniParty.idItemEvent[0], -g.managerMiniParty.countItem);
        checkBtn();
        _isAnimate = false;

    }
}
}
