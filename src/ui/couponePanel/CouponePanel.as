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
    private var _imCoupone:Image;
    private var _imCouponePlashka:Image;

    private var g:Vars = Vars.getInstance();

    public function CouponePanel() {
        _source = new CSprite();
        g.cont.interfaceCont.addChild(_source);
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
        _imCouponePlashka = new Image(g.allData.atlas['interfaceAtlas'].getTexture("vauchers_pt_2_icon"));
        _imCouponePlashka.x = 75;
        _imCouponePlashka.y = 47;
        _imCouponePlashka.pivotX = _imCouponePlashka.width/2;
        _imCouponePlashka.pivotY = _imCouponePlashka.width/2;
        MCScaler.scale(_imCouponePlashka,_imCouponePlashka.height-5, _imCouponePlashka.width-5);
        _source.addChild(_imCouponePlashka);

        _imCoupone = new Image(g.allData.atlas['interfaceAtlas'].getTexture("vauchers_pt_1_icon"));
        _imCoupone.x = 30;
        _imCoupone.y = 30;
        _source.x = 30;
        _source.y = 80;
        _imCoupone.pivotX = _imCoupone.width/2;
        _imCoupone.pivotY = _imCoupone.width/2;
        MCScaler.scale(_imCoupone,_imCoupone.height-5, _imCoupone.width-5);
        _source.addChild(_imCoupone);

        if (g.user.level < 11) _source.visible = false;
        else _source.visible = true;
    }

    private function onHover():void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.managerSalePack) g.managerSalePack.onUserAction();
        g.hint.showIt(String(g.managerLanguage.allTexts[484]),'none',1);
    }

    private function onOut():void {
        g.hint.hideIt();
    }

    private function onClick():void {
        if (g.tuts.isTuts) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) return;
        g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
        g.hint.hideIt();
    }

    public function getPoint():Point {
        var p:Point = new Point();
        p.x = _source.x + 20;
        p.y = _source.y + 10;
        p = _source.localToGlobal(p);
        return p;
    }

    public function animationBuy():void {

        var tween:Tween = new Tween(_source, 0.6);
        tween.scaleTo(2);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(0.8);
        g.starling.juggler.add(tween);
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
