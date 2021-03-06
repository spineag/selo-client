/**
 * Created by user on 2/15/17.
 */
package ui.sale {
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Quad;

import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.TimeUtils;

import windows.WindowsManager;

public class SalePanel {
    private var _source:CSprite;
    private var g:Vars = Vars.getInstance();
    private var _armature:Armature;
    private var _timer:int;
    private var _txtData:CTextField;
    private var _spriteTxt:Sprite;

    public function SalePanel() {
        _source = new CSprite();
        _source.endClickCallback = onClick;
        _source.hoverCallback = function ():void {
            g.hint.showIt(String(g.managerLanguage.allTexts[454]))
        };
        _source.outCallback = function ():void {
            g.hint.hideIt()
        };
        onResize();
        g.cont.interfaceCont.addChild(_source);
        loadTipsIcon();
    }

    private function loadTipsIcon():void {
        var st:String = 'animations_json/sale_icon';
        g.loadAnimation.load(st, 'sale_icon', onLoad);
    }

    private function onLoad():void {
        _armature =  g.allData.factory['sale_icon'].buildArmature('cat');
        WorldClock.clock.add(_armature);
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        _armature.animation.gotoAndPlayByFrame('idle');
        _timer = 20;
        g.gameDispatcher.addToTimer(animation);
        _txtData = new CTextField(128,60,' ');
        _txtData.setFormat(CTextField.BOLD18, 16, 0x4b7200);
        _txtData.y = -25;
        _txtData.x = -30;
        _spriteTxt = new Sprite();
        _spriteTxt.addChild(_txtData);

        if (!b) var b:Slot = _armature.getSlot('birka copy');
        if (b) {
            b.displayList = null;
            b.display = _spriteTxt;
        }
        g.gameDispatcher.addToTimer(startTimer);
        if (g.managerInviteFriend) g.managerInviteFriend.updateTimerPanelPosition();
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 12;
        _source.x = g.managerResize.stageWidth - 240;
    }

    private function onClick():void {
        if (g.managerSalePack.userSale.typeSale == 1) g.windowsManager.openWindow(WindowsManager.WO_SALE_PACK_RUBIES, null, false);
        else if (g.managerSalePack.userSale.typeSale == 2) g.windowsManager.openWindow(WindowsManager.WO_SALE_PACK_INSTRUMENTS, null, false);
        else if (g.managerSalePack.userSale.typeSale == 3) g.windowsManager.openWindow(WindowsManager.WO_SALE_PACK_VAUCHERS, null, false);
        else if (g.managerSalePack.userSale.typeSale == 4) g.windowsManager.openWindow(WindowsManager.WO_THREE_ONE, null, false);
    }

    private function startTimer():void {
        if (g.userTimer.saleTimerToEnd > 0) {
            if (_txtData)_txtData.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.saleTimerToEnd);
        } else {
            visiblePartyPanel(false);
            if (_txtData) {
                _source.removeChild(_txtData);
                _txtData.deleteIt();
                _txtData = null;
            }
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }

    public function visiblePartyPanel(b:Boolean):void {
        if (b) _source.visible = true;
        else _source.visible = false;
        if (g.managerInviteFriend) g.managerInviteFriend.updateTimerPanelPosition();
    }
    
    public function get isVisible():Boolean { return _source.visible; } 

    private function animation():void {
        _timer--;
        if (_timer <= 0) {
            g.gameDispatcher.removeFromTimer(animation);
            _armature.animation.gotoAndPlayByFrame('idle');
            _timer = 12;
            g.gameDispatcher.addToTimer(animation);
        }
    }
}
}
