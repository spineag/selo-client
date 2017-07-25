/**
 * Created by user on 7/7/15.
 */
package ui.couponePanel {
import flash.geom.Point;
import flash.geom.Rectangle;

import manager.ManagerFabricaRecipe;

import manager.ManagerFilters;

import manager.Vars;

import mouse.ToolsModifier;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WindowsManager;

public class CouponePanel {
    private var _source:CSprite;
    private var _contClipRect:Sprite;
    private var _contCoupone:Sprite;
    private var _imCoupone:Image;
    private var _imYellow:Image;
    private var _imRed:Image;
    private var _imBlue:Image;
    private var _imGreen:Image;
    private var _count:int;

    private var _txtYellow:CTextField;
    private var _txtRed:CTextField;
    private var _txtBlue:CTextField;
    private var _txtGreen:CTextField;

    private var g:Vars = Vars.getInstance();

    public function CouponePanel() {
        _source = new CSprite();
        _source.nameIt = 'couponePanel';
        g.cont.interfaceCont.addChild(_source);
        _contCoupone = new Sprite();
        _contClipRect = new Sprite();
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
        _source.addChild(_contClipRect);
        _contClipRect.addChild(_contCoupone);
        _imCoupone = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coupons_icon"));
        _imCoupone.x = 30;
        _imCoupone.y = 30;
        MCScaler.scale(_imCoupone,69,75);
        _imCoupone.pivotX = _imCoupone.width/2;
        _imCoupone.pivotY = _imCoupone.width/2;
        _source.addChild(_imCoupone);
        _imGreen = new Image(g.allData.atlas['interfaceAtlas'].getTexture("green_coupone"));
        MCScaler.scale(_imGreen,30,30);
        _imGreen.x = 70;
        _imGreen.y += 5;
        _contCoupone.addChild(_imGreen);
        _imBlue = new Image(g.allData.atlas['interfaceAtlas'].getTexture("blue_coupone"));
        MCScaler.scale(_imBlue,30,30);
        _imBlue.x = 100;
        _imBlue.y += 5;
        _contCoupone.addChild(_imBlue);
        _imYellow = new Image(g.allData.atlas['interfaceAtlas'].getTexture("yellow_coupone"));
        MCScaler.scale(_imYellow,30,30);
        _imYellow.x = 130;
        _imYellow.y += 5;
        _contCoupone.addChild(_imYellow);
        _imRed = new Image(g.allData.atlas['interfaceAtlas'].getTexture("red_coupone"));
        MCScaler.scale(_imRed,30,30);
        _imRed.x = 160;
        _imRed.y += 5;
        _contCoupone.addChild(_imRed);
        _txtGreen = new CTextField(50,50,"");
        _txtGreen.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtGreen.x = 58;
        _txtGreen.y = 20;
        _contCoupone.addChild(_txtGreen);
        _txtBlue = new CTextField(50,50,"");
        _txtBlue.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtBlue.x = 88;
        _txtBlue.y = 20;
        _contCoupone.addChild(_txtBlue);
        _txtYellow = new CTextField(50,50,"");
        _txtYellow.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtYellow.x = 120;
        _txtYellow.y = 20;
        _contCoupone.addChild(_txtYellow);
        _txtRed = new CTextField(50,50,"");
        _txtRed.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtRed.x = 150;
        _txtRed.y = 20;
        _contCoupone.addChild(_txtRed);
        _source.x = 20;
        _source.y = 120;

        _contCoupone.visible = false;
        _contCoupone.x = -100;
        if(g.user.level < 11) _source.visible = false;
        else _source.visible = true;
    }

    private function onHover():void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        _contCoupone.visible = true;
        var quad:Quad = new Quad(_imCoupone.width, _imCoupone.height,Color.WHITE);
//
//        if (g.user.greenCouponCount >= 100) _txtGreen.setFormat(CTextField.BOLD18, 12, Color.WHITE, ManagerFilters.BROWN_COLOR);
//        if (g.user.blueCouponCount >= 100) _txtBlue.setFormat(CTextField.BOLD18, 12, Color.WHITE, ManagerFilters.BROWN_COLOR);
//        if (g.user.redCouponCount >= 100) _txtRed.setFormat(CTextField.BOLD18, 12, Color.WHITE, ManagerFilters.BROWN_COLOR);
//        if (g.user.yellowCouponCount >= 100) _txtYellow.setFormat(CTextField.BOLD18, 12, Color.WHITE, ManagerFilters.BROWN_COLOR);

        quad.alpha = 0;
        _source.addChildAt(quad,0);
        _txtGreen.text = String(g.user.greenCouponCount);
        _txtBlue.text = String(g.user.blueCouponCount);
        _txtRed.text = String(g.user.redCouponCount);
        _txtYellow.text = String(g.user.yellowCouponCount);
        g.hint.showIt(String(g.managerLanguage.allTexts[484]),'none',1);
        _contClipRect.mask = new Quad(400, 400);
        _contClipRect.mask.x = 15;
        
        var tween:Tween = new Tween(_contCoupone, 0.2);
        tween.moveTo(10,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);
    }

    private function onOut():void {
        var tween:Tween = new Tween(_contCoupone, 0.2);
        tween.moveTo(-100,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            _contCoupone.visible = false;
        };
        g.starling.juggler.add(tween);

        g.hint.hideIt();
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) return;
        var tween:Tween = new Tween(_contCoupone, 0.2);
        tween.moveTo(-100,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            _contCoupone.visible = false;
        };
        g.starling.juggler.add(tween);
        g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
        g.hint.hideIt();
    }

    public function getPoint():Point {
        var p:Point = new Point();
        p.x = _imCoupone.x + 20;
        p.y = _imCoupone.y + 10;
        p = _source.localToGlobal(p);
        return p;
    }

    public function animationBuy():void {

        var tween:Tween = new Tween(_imCoupone, 0.6);
        tween.scaleTo(2);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(0.8);
        g.starling.juggler.add(tween);
    }

    private function onEnterFrame():void {
        _count ++;
        if (_count >= 5) {
            _count = 0;
            _imCoupone.width = 75;
            _imCoupone.height = 69;
            _source.x = 20;
            _source.y = 120;
            g.gameDispatcher.removeEnterFrame(onEnterFrame);
        }
    }

    public function openPanel(b:Boolean):void {
        _source.visible = b;
    }

    public function getContPropertie():Object {
        var obj:Object = {};
        var p:Point = new Point();
        p.x = _source.x;
        p.y = _source.y;
        p = g.cont.interfaceCont.localToGlobal(p);
        obj.x = p.x - 50;
        obj.y = p.y;
        obj.width = _source.width;
        obj.height = _source.height;
        return obj;
    }
}
}
