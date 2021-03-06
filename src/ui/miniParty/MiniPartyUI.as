/**
 * Created by user on 7/24/18.
 */
package ui.miniParty {
import flash.geom.Point;

import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;

import utils.CSprite;
import utils.CTextField;
import utils.TimeUtils;

import windows.WindowsManager;

public class MiniPartyUI {
    private var _source:CSprite;
    private var _txtTimer:CTextField;
    private var _isHover:Boolean;
    private var g:Vars = Vars.getInstance();

    public function MiniPartyUI() {
        _source = new CSprite();
        var im:Image;
        im = new Image(g.allData.atlas['miniPartyAtlas'].getTexture(g.managerMiniParty.iconUI));
        _source.addChild(im);
        _txtTimer = new CTextField(100,60,'');
        _txtTimer.setFormat(CTextField.BOLD18, 18, 0xd30102);
        _source.addChild(_txtTimer);
        _txtTimer.y = 55;

        g.cont.interfaceCont.addChild(_source);
        onResize();
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
        g.gameDispatcher.addToTimer(startTimer);
        _source.alignPivot();
        _isHover = false;
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 120;
        _source.x = g.managerResize.stageWidth - 140;
    }

    private function startTimer():void {
        if (g.userTimer.miniPartyToEndTimer > 0) {
            if (_txtTimer)_txtTimer.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.miniPartyToEndTimer);
        } else {
            visiblePartyPanel(false);
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }

    private function onHover():void {
        if (_isHover) return;
        _isHover = true;
        g.hint.showIt(String(g.managerLanguage.allTexts[g.managerMiniParty.nameMain]),'none', _source.x);
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
    }

    private function onOut():void {
        g.hint.hideIt();
        _isHover = false;
        _source.filter = null;
    }

    public function visiblePartyPanel(b:Boolean):void {
        if (b && _source && g.managerMiniParty.miniEventOn) _source.visible = true;
        else if (_source) _source.visible = false;
        if (g.managerInviteFriend) g.managerInviteFriend.updateTimerPanelPosition();
    }

    public function get isVisible():Boolean { return _source.visible; }

    private function onClick():void {
        if (g.userTimer.miniPartyToEndTimer > 0) {
            _isHover = false;
            _source.filter = null;
            g.windowsManager.openWindow(WindowsManager.WO_MINI_PARTY,null);
        }
    }

    public function getPoint():Point {
        var p:Point = new Point();
        if (g.windowsManager.currentWindow) {
            p = new Point(_source.x,_source.y);
            return p;
        }
        p.x = _source.x;
        p.y = _source.y ;
        p = _source.localToGlobal(p);

        return p;
    }
}
}