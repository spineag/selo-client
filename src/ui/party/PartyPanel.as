package ui.party {
import flash.geom.Point;
import manager.ManagerFilters;
import manager.ManagerPartyNew;
import manager.Vars;

import social.SocialNetworkSwitch;

import starling.animation.Tween;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;

import user.Friend;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WindowsManager;

public class PartyPanel {
    private var _source:CSprite;
    private var g:Vars = Vars.getInstance();
    private var _txtTimer:CTextField;
    private var _isHover:Boolean;
    private var _imHelp:Image;
    private var _imHelpLeyka:Image;
    private var _imHelpCursor:Image;
    private var _srcHelp:Sprite;
    private var _srcParty:Sprite;
    private var _txtHelp:CTextField;
    private var _countHelpParty:int;

    public function PartyPanel() {
        _source = new CSprite();
        _srcParty = new Sprite();
        _source.addChild(_srcParty);
        _srcHelp = new Sprite();
        _source.addChild(_srcHelp);
        var im:Image;
        im = new Image(g.allData.atlas['partyAtlas'].getTexture(g.managerParty.imIcon));
        _srcParty.addChild(im);
        _txtTimer = new CTextField(100,60,'');
        _txtTimer.setFormat(CTextField.BOLD18, 18, 0xd30102);
        _srcParty.addChild(_txtTimer);
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

    public function get gCountHelpParty():int {
        return _countHelpParty;
    }

    public function set sCountHelpParty(count:int):void {
        _countHelpParty += count;
        _txtHelp.text = _countHelpParty + '/10';
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 120;
        _source.x = g.managerResize.stageWidth - 140;
    }

    private function startTimer():void {
        if (g.userTimer.partyToEndTimer > 0) {
            if (_txtTimer)_txtTimer.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.partyToEndTimer);
        } else {
            visiblePartyPanel(false);
            if (!g.managerParty.userParty[0].showWindow) {
                if (_txtTimer) {
                    _srcParty.removeChild(_txtTimer);
                    _txtTimer.deleteIt();
                    _txtTimer = null;
                }
//                g.managerParty.endPartyWindow()
            }
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }

    private function onHover():void {
        if (_isHover) return;
        _isHover = true;
        g.hint.showIt(String(g.managerLanguage.allTexts[g.managerParty.nameMain]),'none', _source.x);
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
    }

    private function onOut():void {
        g.hint.hideIt();
        _isHover = false;
        _source.filter = null;
    }

    public function visiblePartyPanel(b:Boolean):void {
        if (b && _source && _srcParty && g.managerParty.eventOn) {
            if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_SKIP_PLANT_FRIEND) showBoardHelpFriend(false);
            _srcParty.visible = true;
        }
        else if (_source && _srcParty) {
            _srcParty.visible = false;
            if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_SKIP_PLANT_FRIEND && g.visitedUser is Friend) {
                showBoardHelpFriend();
            }
        }
        if (g.managerInviteFriend) g.managerInviteFriend.updateTimerPanelPosition();
    }
    
    public function get isVisible():Boolean { return _source.visible; }

    public function checkCountHelp():void {
        var bFor:Boolean = false;
        for (var i:int = 0; i < g.managerParty.userParty[0].friendId.length; i++) {
            if (g.visitedUser.userId == g.managerParty.userParty[0].friendId[i]) {
                bFor = true;
                _countHelpParty = g.managerParty.userParty[0].friendCount[i];
                _txtHelp.text = _countHelpParty + '/10';
                break;
            }
        }
        if (!bFor) {
            _countHelpParty = 0;
            _txtHelp.text = _countHelpParty + '/10';
        }
    }

    private function showBoardHelpFriend(b:Boolean = true):void {
        if (b) {
            _srcHelp.y = 20;
            _srcHelp.x = 40;
            _imHelp = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_button'));
            _imHelp.scaleX = 1.5;
            _imHelp.x = -35;
//            MCScaler.scale(_imHelp, _imHelp.height -5, _imHelp.width-_imHelp.width/2);
            _srcHelp.addChild(_imHelp);
            _txtHelp = new CTextField(122, 30, ' ');
            _txtHelp.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
            _txtHelp.cacheIt = false;
            _txtHelp.alignH = Align.RIGHT;
            _txtHelp.x = -50;
            _txtHelp.y = 5;
            _srcHelp.addChild(_txtHelp);
            _imHelpCursor = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_circle_pt_1'));
            MCScaler.scale(_imHelpCursor,_imHelpCursor.height/1.5,_imHelpCursor.width/1.5);
            _srcHelp.addChild(_imHelpCursor);
            _imHelpCursor.x = -48;
            _imHelpCursor.y = -5;
            _imHelpLeyka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('watering_can'));
            _imHelpLeyka.scale = .5;
//            _imHelpLeyka.scaleX = -1;
            _srcHelp.addChild(_imHelpLeyka);
            _imHelpLeyka.x = -43;
            _imHelpLeyka.y = -5;

            checkCountHelp();
        } else {
            if (_imHelp) {
                _srcHelp.removeChild(_imHelp);
                _imHelp.dispose();
                _imHelp = null;
            }

            if (_imHelpCursor) {
                _srcHelp.removeChild(_imHelpCursor);
                _imHelpCursor.dispose();
                _imHelpCursor = null;
            }

            if (_imHelpLeyka) {
                _srcHelp.removeChild(_imHelpLeyka);
                _imHelpLeyka.dispose();
                _imHelpLeyka = null;
            }

            if (_txtHelp) {
                _srcHelp.removeChild(_txtHelp);
                _txtHelp.dispose();
                _txtHelp = null;
            }
        }

    }

    private function onClick():void {
        if (g.userTimer.partyToEndTimer > 0) {
            _isHover = false;
            _source.filter = null;
            g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
        }
    }

    public function getPoint():Object {
        var obj:Object = {};
        obj.x = _source.x;
        obj.y = _source.y;
        return obj;
    }

    public function animationBuy():void {
        var tween:Tween;
        tween = new Tween(_source, 0.3);
        tween.scaleTo(1.8);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(1);
        g.starling.juggler.add(tween);

    }
}
}