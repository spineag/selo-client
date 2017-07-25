/**
 * Created by user on 6/19/15.
 */
package ui.xpPanel {

import additional.buyerNyashuk.ManagerBuyerNyashuk;

import flash.filters.GlowFilter;
import flash.geom.Point;

import manager.ManagerFilters;
import manager.ManagerInviteFriendViral;

import manager.Vars;

import media.SoundConst;

import mouse.ToolsModifier;

import social.SocialNetworkSwitch;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

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

    public function XPPanel() {
        _source = new CSprite();
        _source.nameIt = 'xpPanel';
        g.cont.interfaceCont.addChild(_source);
        var pl:HorizontalPlawka = new HorizontalPlawka(null, g.allData.atlas['interfaceAtlas'].getTexture('xp_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('xp_back_left'), 163);
        _source.addChild(pl);
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('progress_bar_left'), g.allData.atlas['interfaceAtlas'].getTexture('progress_bar_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('progress_bar_right'), 150);
        _bar.x = 9;
        _bar.y = 3;
        _source.addChild(_bar);
        _imageStar = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        MCScaler.scale(_imageStar, 60, 60);
        _imageStar.x = -10;
        _imageStar.y = 5;
        _imageStar.pivotX = _imageStar.width/2;
        _imageStar.pivotY = _imageStar.height/2;
        _source.addChild(_imageStar);
        _txtLevel = new CTextField(60, 60, '55');
        _txtLevel.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtLevel.x = -30;
        _txtLevel.y = -12;
        _source.addChild(_txtLevel);
        _txtXPCount = new CTextField(123, 30, '0');
        _txtXPCount.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtXPCount.x = 35;
        _txtXPCount.y = 4;
        _source.addChild(_txtXPCount);
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _maxXP = g.dataLevel.objectLevels[g.user.level + 1].xp;
        _countXP = g.user.xp;
        checkXP();
        onResize();
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 17;
        _source.x = g.managerResize.stageWidth - 170;
    }
    
    public function getPanelPoints():Point {
        return new Point(g.managerResize.stageWidth - 170,17);
    }
    
    public function visualAddXP(count:int):void{
        animationStar();
        _countXP += count;
        g.soundManager.playSound(SoundConst.XP_PLUS);
        if (_countXP >= _maxXP){
            if (!g.userValidates.checkInfo('level', g.user.level)) return;
            _countXP -= _maxXP;
            g.user.xp -= _maxXP;
            g.user.level++;
            _maxXP = g.dataLevel.objectLevels[g.user.level + 1].xp;
            _txtLevel.text = String(g.user.level);
            checkXP();

            g.userValidates.updateInfo('xp', g.user.xp);
            g.userValidates.updateInfo('level', g.user.level);

            if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
            if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                g.toolsModifier.cancelMove();
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                if (g.buyHint.showThis) g.buyHint.hideIt();
            }
            g.windowsManager.openWindow(WindowsManager.WO_LEVEL_UP, null);
            g.friendPanel.checkLevel();
            g.directServer.updateUserLevel(null);
            g.userInventory.addNewElementsAfterGettingNewLevel();
            g.managerCats.calculateMaxCountCats();

//            if (g.user.level == 5 && g.socialNetworkID != SocialNetworkSwitch.SN_FB_ID) {
//                g.managerBuyerNyashuk = new ManagerBuyerNyashuk(true);
//            } else if (g.user.level == 7 && g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) g.managerBuyerNyashuk = new ManagerBuyerNyashuk(true);
            if (g.user.level > 3 && g.user.isOpenOrder) g.managerOrder.checkOrders();
            if (g.user.level == 4 || g.user.level == 5) g.managerMiniScenes.checkDeleteMiniScene();
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
        } else 
            checkXP();
    }

    public function serverAddXP(count:int):void {
        if (!g.userValidates.checkInfo('xp', g.user.xp)) return;
        g.user.xp += count;
        g.user.globalXP += count;
        g.userValidates.updateInfo('xp', int (g.user.xp ));
        g.directServer.addUserXP(int (g.user.globalXP), null);
    }

    public function checkXP():void{
        _bar.progress = ((_countXP)/_maxXP)*.9 + .1; // get 10% for better view
        _txtXPCount.text = String(_countXP);
        _txtLevel.text = String(g.user.level);
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
        tween.scaleTo(0.6);
        g.starling.juggler.add(tween);
    }
}
}
