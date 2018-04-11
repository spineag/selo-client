/**
 * Created by user on 6/19/15.
 */
package ui.xpPanel {

import additional.buyerNyashuk.ManagerBuyerNyashuk;

import flash.display.Bitmap;

import flash.filters.GlowFilter;
import flash.geom.Point;

import loaders.PBitmap;

import manager.ManagerFilters;
import manager.ManagerInviteFriendViral;

import manager.Vars;

import media.SoundConst;

import mouse.ToolsModifier;

import order.DataOrderCat;

import social.SocialNetworkSwitch;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.Color;

import ui.confetti.Confetti;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.HorizontalPlawka;
import windows.WOComponents.ProgressBarComponent;
import windows.WindowsManager;

public class XPPanel {
    private var _source:CSprite;
    private var _maxXP:int;
    private var _bar:ProgressBarComponent;
    private var _txtLevel:CTextField;
    private var _txtXPCount:CTextField;
    public var _imageStar:Image;
    private var _countXP:int;
    private var g:Vars = Vars.getInstance();
    private var _st:String;
    private var _count:int;
    private var _bAtlas:Boolean;

    public function XPPanel() {
        _source = new CSprite();
        g.cont.interfaceCont.addChild(_source);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('progres_bar'));
        _source.addChild(im);
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('xp_line_progres_bar_center'), g.allData.atlas['interfaceAtlas'].getTexture('xp_line_progres_bar_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('xp_line_pr_bar_right'), 135);
        _bar.x = -6;
        _bar.y = 3;
        _source.addChild(_bar);
        _imageStar = new Image(g.allData.atlas['interfaceAtlas'].getTexture('xp_icon'));
        _imageStar.x = -7;
        _imageStar.y = 19;
        _imageStar.pivotX = _imageStar.width/2;
        _imageStar.pivotY = _imageStar.height/2;
        _source.addChild(_imageStar);
        _txtLevel = new CTextField(60, 60, '55');
        _txtLevel.setFormat(CTextField.BOLD24, 24, 0xff7a3f, Color.WHITE);
        _txtLevel.x = -39;
        _txtLevel.y = -12;
        _source.addChild(_txtLevel);
        _txtXPCount = new CTextField(123, 50, '0');
        _txtXPCount.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_TXT_UI, Color.WHITE);
        _txtXPCount.x = 15;
        _txtXPCount.y = -6;
        _source.addChild(_txtXPCount);
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
        _maxXP = g.dataLevel.objectLevels[g.user.level + 1].xp;
        _countXP = g.user.xp;
        updateProgressBarXP();
        _bAtlas = false;
        onResize();
    }
    
    private function onClick():void {
        if (!g.isDebug) return;
        g.user.notif.checkOnNewLevel();

//        g.user.level++;
//        g.windowsManager.openWindow(WindowsManager.WO_LEVEL_UP, null);
//        var arr:Array = DataOrderCat.arr;
//        g.windowsManager.openWindow(WindowsManager.WO_ORDER_CAT_MINI, null, arr[int(Math.random()*arr.length)]);
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 17;
        _source.x = g.managerResize.stageWidth - 170;
    }
    
    public function getPanelPoints():Point {
        return new Point(g.managerResize.stageWidth - 170,17);
    }

    public function serverAddXP(count:int):void {
        if (count <=0) return;
        if (!g.userValidates.checkInfo('xp', g.user.xp)) return;
        g.user.xp += count;
        g.user.globalXP += count;
        g.userValidates.updateInfo('xp', int (g.user.xp ));
        g.server.addUserXP(int (g.user.globalXP), null);
    }

    public function visualAddXP(count:int):void{
        animationStar();
        _countXP += count;
        g.soundManager.playSound(SoundConst.XP_PLUS);
        if (_countXP >= _maxXP) {
            if (!g.userValidates.checkInfo('level', g.user.level)) return;
            _countXP -= _maxXP;
            g.user.xp -= _maxXP;
            g.user.level++;
            _maxXP = g.dataLevel.objectLevels[g.user.level + 1].xp;
            _txtLevel.text = String(g.user.level);
            updateProgressBarXP();

            g.userValidates.updateInfo('xp', g.user.xp);
            g.userValidates.updateInfo('level', g.user.level);

            if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                g.toolsModifier.cancelMove();
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                if (g.buyHint.showThis) g.buyHint.hideIt();
            }

            onGetNewLevel();
            if (_countXP >= _maxXP) visualAddXP(0);
            else {
                g.server.updateUserLevel(null);
                if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
                g.windowsManager.openWindow(WindowsManager.WO_LEVEL_UP, null);
            }
        } else 
            updateProgressBarXP();
    }

    private function onLoad(smth:*=null):void {
        _count++;
        if (_count >= 2) createAtlases();
    }

    private function createAtlases():void {
        g.allData.atlas['levelAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[_st + 'levelAtlas.png' + g.getVersion('levelAtlas')].create() as Bitmap), g.pXMLs[_st + 'levelAtlas.xml' + g.getVersion('levelAtlas')]);
        (g.pBitmaps[_st + 'levelAtlas.png' + g.getVersion('levelAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[_st + 'levelAtlas.png' + g.getVersion('levelAtlas')];
        delete  g.pXMLs[_st + 'levelAtlas.xml' + g.getVersion('levelAtlas')];
        g.load.removeByUrl(_st + 'levelAtlas.png' + g.getVersion('levelAtlas'));
        g.load.removeByUrl(_st + 'levelAtlas.xml' + g.getVersion('levelAtlas'));
        _bAtlas = false;
    }
    
    private function onGetNewLevel():void {
        g.friendPanel.checkLevel();
        g.userInventory.addNewElementsAfterGettingNewLevel();
        if (g.user.level == 4 || g.user.level == 5) g.miniScenes.checkDeleteMiniScene();
        if (g.user.level == g.allData.getBuildingById(45).blockByLevel[0])
            g.managerDailyBonus.generateDailyBonusItems();
        if (g.user.level == 8) {
            if (g.managerHelpers) g.managerHelpers.disableIt();
        } else if (g.user.level == 10) {
            if (g.managerTips) g.managerTips.deleteTips();
            if (g.managerTips) g.managerTips = null;
            g.managerQuest.checkQuestContPosition();
        } else if (g.user.level == 17) {
            g.managerQuest.checkQuestContPosition();
        }
        if (g.user.level >= 5 && g.user.level < 10) {
            if (g.managerTips) g.managerTips.calculateAvailableTips();
        }
        if (!g.isDebug) g.socialNetwork.setUserLevel();
        if (g.managerInviteFriend) g.managerInviteFriend.onUpdateLevel();
        g.user.notif.checkOnNewLevel();
    }

    public function updateProgressBarXP():void{
        _bar.progress = ((_countXP)/_maxXP)*.9 + .1; // get 10% for better view
        _txtXPCount.text = String(_countXP) + '/' + _maxXP;
        _txtLevel.text = String(g.user.level);
//        if (_maxXP - g.user.xp <= 50) {
//            if (!g.allData.atlas['levelAtlas'] && !_bAtlas) {
//                _st = g.dataPath.getGraphicsPath();
//                _count = 0;
//                _bAtlas = true;
//                g.load.loadImage(_st + 'levelAtlas.png' + g.getVersion('levelAtlas'), onLoad);
//                g.load.loadXML(_st + 'levelAtlas.xml' + g.getVersion('levelAtlas'), onLoad);
//            }
//        }
    }

    private function onHover():void {
        g.hint.showIt(_maxXP - _countXP + ' ' + String(g.managerLanguage.allTexts[503]) + (g.user.level+1) + ' '+  String(g.managerLanguage.allTexts[502]),'none', _source.x);
    }

    private function onOut():void {
        g.hint.hideIt();
    }

    private function animationStar():void {
        var tween:Tween = new Tween(_imageStar, 0.3);
        tween.scaleTo(1.5);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(1);
        g.starling.juggler.add(tween);
    }
}
}
