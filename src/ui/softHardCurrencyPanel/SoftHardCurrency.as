/**
 * Created by user on 7/6/15.
 */
package ui.softHardCurrencyPanel {
import flash.filters.GlowFilter;
import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import mouse.ToolsModifier;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.styles.DistanceFieldStyle;

import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.HorizontalPlawka;
import windows.WindowsManager;

public class SoftHardCurrency {
    private var _source:Sprite;
    private var _contSoft:CSprite;
    private var _contHard:CSprite;
    private var _txtSoft:CTextField;
    private var _txtHard:CTextField;
    private var _imCoin:Image;
    private var _imHard:Image;
    private var g:Vars = Vars.getInstance();

    public function SoftHardCurrency() {
        _source = new Sprite();
        _contSoft = new CSprite();
        _contHard = new CSprite();
        _contSoft.endClickCallback = onClickSoft;
        _contSoft.hoverCallback = function ():void {
            g.hint.showIt(String(g.managerLanguage.allTexts[325]),'none',1);
        };
        _contSoft.outCallback = function ():void {
            g.hint.hideIt();
        };
        _contHard.endClickCallback = onClickHard;
        _contHard.hoverCallback = function ():void {
            g.hint.showIt(String(g.managerLanguage.allTexts[326]),'none',1);
        };
        _contHard.outCallback = function ():void {
            g.hint.hideIt();
        };
        createPanel(true, _contSoft, onClickSoft);
        createPanel(false, _contHard, onClickHard);
        _txtSoft =  new CTextField(120, 50, '00');
        _txtSoft.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_TXT_UI, Color.WHITE);
        _contSoft.addChild(_txtSoft);
        _txtHard =  new CTextField(120, 50, '00');
        _txtHard.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_TXT_UI, Color.WHITE);
        _contHard.addChild(_txtHard);

        _source.addChild(_contSoft);
//        _contHard.y = 56;
        _source.addChild(_contHard);
        _source.x = 35;
        _source.y = 15;
        _contSoft.x = 180;
        _txtHard.y = -8;
        _txtSoft.y = -8;
        _txtSoft.alignH = Align.LEFT;
        _txtHard.alignH = Align.LEFT;
        _txtSoft.x = 67 - _txtSoft.textBounds.width/2;
        _txtHard.x = 67 - _txtHard.textBounds.width/2;
        g.cont.interfaceCont.addChild(_source);
//        var q:Quad = new Quad(5,5,Color.BLACK);
//        q.x = 65;
//        _contHard.addChild(q);

    }

    private function createPanel(isSoft:Boolean, p:CSprite, f:Function):void {
        var im:Image;
//        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
//                g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), 122);
//        p.addChild(pl);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('progres_bar'));

        im.touchable = true;
        p.addChild(im);
        if (isSoft) {
            _imCoin = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
            MCScaler.scale(_imCoin, 50, 50);
            _imCoin.x = -_imCoin.width/2 + 15;
            _imCoin.y = 5;
            _imCoin.pivotX = 25;
            _imCoin.pivotY = 25;
            p.addChild(_imCoin);
        } else {
            _imHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            MCScaler.scale(_imHard, 50, 50);
            _imHard.x = -_imHard.width/2 + 15;
            _imHard.y = 5;
            _imHard.pivotX = 25;
            _imHard.pivotY = 25;
            p.addChild(_imHard);
        }
        var btn:CButton = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_button_light'));
        btn.addDisplayObject(im);
        btn.setPivots();
        btn.x = 158 - btn.width/2;
        btn.y = 20;
        p.addChild(btn);
        btn.clickCallback = f;
    }

    public function checkSoft():void {
        _txtSoft.text =  String(g.user.softCurrencyCount);
        _txtSoft.x = 67 - _txtSoft.textBounds.width/2;
    }

    public function checkHard():void {
        _txtHard.text =  String(g.user.hardCurrency);
        _txtHard.x = 67 - _txtHard.textBounds.width/2;
    }

    public function getHardCurrencyPoint():Point {
        return _contHard.localToGlobal(new Point(14, 30));
    }

    public function get actionON():Boolean{
        var arr:Array = g.allData.dataBuyMoney;
        var b:Boolean = false;

        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i].sale > 0) {
                b = true;
                break;
            }
        }
        return b;
    }

    public function getSoftCurrencyPoint():Point {
        return _contSoft.localToGlobal(new Point(14, 30));
    }

    private function onClickSoft():void {
        if (g.tuts.isTuts) return;
        if (g.managerCutScenes.isCutScene) return;
        if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
            g.toolsModifier.cancelMove();
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
        g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, false);
    }

    private function onClickHard():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts) return;
        if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
            g.toolsModifier.cancelMove();
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
        g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
    }

    public function animationBuy(hard:Boolean):void {
        var tween:Tween;
        if (hard) {
            tween = new Tween(_imHard, 0.3);
        } else {
            tween = new Tween(_imCoin, 0.3);
        }
        tween.scaleTo(1.5);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(0.5);
        g.starling.juggler.add(tween);

    }

}
}
