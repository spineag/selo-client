/**
 * Created by user on 1/30/17.
 */
package windows.partyWindow {
import com.junkbyte.console.Cc;
import data.BuildType;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.ManagerLanguage;
import manager.ManagerPartyNew;
import resourceItem.newDrop.DropObject;
import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;

import starling.animation.Tween;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;

import windows.WOComponents.BackgroundMilkIn;
import windows.WOComponents.BackgroundQuest;
import windows.WOComponents.BackgroundQuestDone;

import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.DefaultVerticalScrollSprite;
import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOPartyWindow extends WindowMain {

    private var _woBG:WindowBackgroundNew;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtCoefficient:CTextField;
    private var _arrItem:Array;
    private var _sprItem:Sprite;
    private var _txtDescription:CTextField;
    private var _txtTime:CTextField;
    private var _txtTimeLost:CTextField;
    private var _isHover:Boolean;
    private var _btnMinus:CButton;
    private var _btnPlus:CButton;
    private var _btnLoad:CButton;
    private var _txtCountLoad:CTextField;
    private var _txtName:CTextField;
    private var _txtPrev:CTextField;
    private var _countLoad:int;
    private var _btnOK:CButton;
    private var _activityType:int;
    private var _sprEvent:Sprite;
    private var _sprRating:Sprite;
    private var _sprLast:Sprite;
    private var _arrItemRating:Array;
    private var _bgYellowLeft:BackgroundYellowOut;
    private var _bgYellowRight:BackgroundYellowOut;
    private var _bgWhiteRating:BackgroundPartyLight;
    private var _bgRedRating:BackgroundQuest;
    private var _txtPrevRating:CTextField;
    private var _txtMainRating:CTextField;
    private var _txtBestGiftRating:CTextField;
    private var _imBestGiftRating:Image;
    private var _arrowLeftRating:CButton;
    private var _arrowRightRating:CButton;
    private var _contClipRect:Sprite;
    private var _contItemRating:Sprite;
    private var _shift:int;
    private var _arrRating:Array;
    private var _tabs:PartyTabs;
    private var _isMain:Boolean;
    private var _bgMainRed:BackgroundQuest;
    private var _scrollSprite:DefaultVerticalScrollSprite;

    public function WOPartyWindow() {
        _windowType = WindowsManager.WO_PARTY;
        _arrItem= [];
        _woHeight = 600;
        _woWidth = 800;
        _isHover = false;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _activityType = ManagerPartyNew.TYPE_EVENT;

        _sprEvent = new Sprite();
        _sprRating = new Sprite();
        _sprRating.visible = false;
        _sprLast = new Sprite();
        _sprLast.visible = false;
        _source.addChild(_sprEvent);
        _source.addChild(_sprRating);
        _source.addChild(_sprLast);
        _sprItem = new Sprite();
        _txtName = new CTextField(750, 70, g.managerLanguage.allTexts[1279]);
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtName.x = -375;
        _txtName.y = -_woHeight/2 + 25;
        _source.addChild(_txtName);
        _txtTimeLost = new CTextField(130, 60, String(g.managerLanguage.allTexts[357]));
        _txtTimeLost.setFormat(CTextField.BOLD30, 28, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtTimeLost.alignH = Align.LEFT;

        _txtTime = new CTextField(130, 60, '');
        _txtTime.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR);
        _txtTime.alignH = Align.LEFT;

        _scrollSprite = new DefaultVerticalScrollSprite(700, 230, 700, 115);
//        _scrollSprite.source.y = 159 - _woHeight / 2;
        _scrollSprite.source.x = - 370;
        _scrollSprite.createScoll(720, 0, 260, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
//        _sprItem.addChild(_scrollSprite.source);
        ratingWO();
        if (g.allData.atlas['partyAtlas']) {
            _tabs = new PartyTabs(_source,callbackTab);
            createEventWO(false);
//            ratingWO();
            if (g.managerParty.typeParty == 3 || g.managerParty.typeParty == 4 || g.managerParty.typeParty == 5) {
//                ratingWO();
//                lastWO();
            }
        } else g.gameDispatcher.addEnterFrame(afterAtlas);


    }

    private function afterAtlas():void {
        if (g.allData.atlas['partyAtlas']) {
            g.gameDispatcher.removeEnterFrame(afterAtlas);
            _tabs = new PartyTabs(_source,callbackTab);
            createEventWO(false);
            if (g.managerParty.typeParty == 3 || g.managerParty.typeParty == 4 || g.managerParty.typeParty == 5) {
//                ratingWO();
//                lastWO();
            }
        }
    }
    private function callbackTab():void {
        _isMain = !_isMain;
        _tabs.activate(_isMain);
        if (_isMain) {
            _sprRating.visible = false;
            _sprEvent.visible = true;
            _txtName.text = String(g.managerLanguage.allTexts[1279]);
        } else {
            _sprRating.visible = true;
            _sprEvent.visible = false;
            _txtName.text = String(g.managerLanguage.allTexts[1278]);
        }
    }

    private function onClickShow():void {
        hideIt();
        var arr:Array;
        var i:int;
        if (g.managerParty.typeParty == 5) {
            arr = g.townArea.getCityObjectsByType(BuildType.ORDER);
            var arrT:Array;
            arrT = g.townArea.getCityObjectsByType(BuildType.RIDGE);
            if (arrT.length > 0) {
                for (i = 0; i < arrT.length; i++) {
                    if (arrT[i].stateRidge > 1) arr.push(arrT[i]);
                }
            }
            arrT = g.townArea.getCityObjectsByType(BuildType.MARKET);
            arr.push(arrT[0]);
            g.cont.moveCenterToPos(arr[0].posX, arr[0].posY);
            for (i = 0; i < arr.length; i++) {
                arr[i].showArrow(3);
            }
        } else {
            arr = g.townArea.getCityObjectsByType(g.managerParty.typeBuilding);
            var b:Boolean = false;
            if (BuildType.FABRICA == g.managerParty.typeBuilding) {
                for (i = 0; i < arr.length; i++) {
                    for (var j:int = 0; j < arr[i].arrRecipes.length; j++) {
                        if (arr[i].arrRecipes[j].idResource == g.managerParty.idResource) {
                            arr[0] = arr[i];
                            b = true;
                            break;
                        }
                    }
                    if (b) break;
                }
            } else if (BuildType.TREE == g.managerParty.typeBuilding) {
                for (i = 0; i < arr.length; i++) {
                    if (arr[i].dataBuild.craftIdResource == g.managerParty.idResource) {
                        arr[0] = arr[i];
                        b = true;
                        break;
                    }
                }
            } else if (BuildType.FARM == g.managerParty.typeBuilding) {
                for (i = 0; i < arr.length; i++) {
                    if (arr[i].dataAnimal.idResource == g.managerParty.idResource) {
                        arr[0] = arr[i];
                        b = true;
                        break;
                    }
                }
            }
            if (g.managerParty.idResource == 0) b = true;
            if (!b) return;
            if (!arr[0]) return;
            g.cont.moveCenterToPos(arr[0].posX, arr[0].posY);
            if (BuildType.FABRICA == g.managerParty.typeBuilding) arr[0].showArrow();
            else arr[0].showArrow(3);
        }
    }

    private function onClickMinus():void {
      if (_countLoad == 1) {
          _btnMinus.setEnabled = false;
          return;
      } else if (_countLoad -1 == 1) {
          _countLoad -=1;
          _txtCountLoad.text = String(_countLoad);
          _btnPlus.setEnabled = true;
          _btnMinus.setEnabled = false;
      } else {
          _countLoad -=1;
          _txtCountLoad.text = String(_countLoad);
          _btnPlus.setEnabled = true;
      }
    }

    private function onClickPlus():void {
        if (_countLoad + 1 > g.userInventory.getCountResourceById(g.managerParty.idResource)) {
            _btnPlus.setEnabled = false;
            return;
        } else if (_countLoad + 1 == g.userInventory.getCountResourceById(g.managerParty.idResource)){
            _countLoad +=1;
            _txtCountLoad.text = String(_countLoad);
            _btnMinus.setEnabled = true;
            _btnPlus.setEnabled = false;
        } else {
            _countLoad +=1;
            _txtCountLoad.text = String(_countLoad);
            _btnMinus.setEnabled = true;
        }
    }

    private function onClickLoad():void {
        var st:String = g.managerParty.userParty.tookGift[0] + '&' + g.managerParty.userParty.tookGift[1] + '&' + g.managerParty.userParty.tookGift[2] + '&'
                + g.managerParty.userParty.tookGift[3] + '&' + g.managerParty.userParty.tookGift[4];
        g.managerParty.userParty.countResource += _countLoad;
        g.server.updateUserParty(st,g.managerParty.userParty.countResource,0,null);
        var p:Point = new Point(0, 0);
        p = _btnLoad.localToGlobal(p);
        var d:DropObject = new DropObject();
        d.addDropXP(_countLoad * g.allData.getResourceById(g.managerParty.idResource).orderXPMin, p);
        d.releaseIt();
        g.userInventory.addResource(g.managerParty.idResource, - _countLoad);
        _countLoad =  g.userInventory.getCountResourceById(g.managerParty.idResource);
        _txtCountLoad.text = String(_countLoad);
        for (var i:int = 0; i < _arrItem.length; i++) {
            (_arrItem[i] as WOPartyWindowItem).reload();
        }
        if (_countLoad > 0) {
            _countLoad = _countLoad/2;
            if (_countLoad <= 0) {
                _countLoad = 1;
                _btnMinus.setEnabled = false;
                _btnPlus.setEnabled = false;
            } else if (_countLoad == 1) _btnMinus.setEnabled = false;
        } else {
            _btnMinus.setEnabled = false;
            _btnPlus.setEnabled = false;
            _btnLoad.setEnabled = false;
        }

    }

    override public function showItParams(callback:Function, params:Array):void {
//        if (!g.allData.atlas['partyAtlas']) {
//            g.windowsManager.hideWindow(WindowsManager.WO_PARTY);
////            g.windowsManager.closeAllWindows();
//            return;
//        }
        _isMain = true;
        _tabs.activate(_isMain);
        if (g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_XP_ORDER || g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_ORDER
                || g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_MARKET || g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_VAGONETKA
                || g.managerParty.typeParty == ManagerPartyNew.EVENT_SKIP_PLANT_FRIEND) {
            super.showIt();
            _source.x = g.managerResize.stageWidth/2 + 50;
            return;
        }  else if ( g.managerParty.typeParty == ManagerPartyNew.EVENT_COLLECT_TOKEN_WIN_GIFT || g.managerParty.typeParty == ManagerPartyNew.EVENT_COLLECT_RESOURCE_WIN_GIFT) {
            if (params[0]) _activityType = params[0];
            var item:WOPartyWindowItem;
            _sprEvent.addChild(_scrollSprite.source);
            for (var i:int = 0; i < 5; i++) {
                item = new WOPartyWindowItem(g.managerParty.idGift[i], g.managerParty.typeGift[i], g.managerParty.countGift[i], g.managerParty.countToGift[i], i + 1);
//                item.source.x = (98 * i);
                _scrollSprite.addNewCell(item.source);
                _arrItem.push(item);
            }

            _sprItem.x = -195;
            _sprItem.y = -125;
            g.gameDispatcher.addToTimer(startTimer);
            super.showIt();
            _source.x = g.managerResize.stageWidth / 2 + 50;
        }
    }

    private function startTimer():void {
        if (g.userTimer.partyToEndTimer > 0) {
            if (_txtTime)_txtTime.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.partyToEndTimer);
            if (_txtTime && _txtTime.x == 0) _txtTime.x = _txtTimeLost.x + _txtTimeLost.textBounds.width;
        } else {
            onClickExit();
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }

    private function createEventWO(b:Boolean = false):void {
        if (g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_XP_ORDER || g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_ORDER
                || g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_MARKET || g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_VAGONETKA
                || g.managerParty.typeParty == ManagerPartyNew.EVENT_SKIP_PLANT_FRIEND) {
            _bgYellowLeft = new BackgroundYellowOut(380,420);
            _bgYellowLeft.x = -_bgYellowLeft.width + 5;
            _bgYellowLeft.y = -_bgYellowLeft.height/2 + 40;
            _sprEvent.addChild(_bgYellowLeft);

            _bgYellowRight = new BackgroundYellowOut(380,420);
            _bgYellowRight.x = 7;
            _bgYellowRight.y = -_bgYellowRight.height/2 + 40;
            _sprEvent.addChild(_bgYellowRight);
            _btnOK = new CButton();
            _btnOK.addButtonTexture(140, CButton.HEIGHT_41, CButton.BLUE, true);
            _btnOK.addTextField(140, 38, 0, -5, String(g.managerLanguage.allTexts[308]));
            _btnOK.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);
            _btnOK.y = 270;
            _sprEvent.addChild(_btnOK);

            _txtPrev = new CTextField(375, 200, String(g.managerLanguage.allTexts[465]));
            _txtPrev.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR);
            _txtPrev.x = -390;
            _txtPrev.y = -220;
            _sprEvent.addChild(_txtPrev);
            _txtDescription = new CTextField(375, 200, String(g.managerLanguage.allTexts[474]));
            _txtDescription.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);
            _txtDescription.x = -390;
            _txtDescription.y = -20;
            _sprEvent.addChild(_txtDescription);
            _txtTimeLost.x = -310;
            _txtTimeLost.y = -85;
            _txtTime.y = -85;
        } else if ( g.managerParty.typeParty == ManagerPartyNew.EVENT_COLLECT_TOKEN_WIN_GIFT || g.managerParty.typeParty == ManagerPartyNew.EVENT_COLLECT_RESOURCE_WIN_GIFT) {
            _bgMainRed = new BackgroundQuest(760,420);
            _bgMainRed.x = -_bgMainRed.width/2 + 5;
            _bgMainRed.y = -_bgMainRed.height/2 + 40;
            _sprEvent.addChild(_bgMainRed);
            _txtTimeLost.x = -120;
            _txtTimeLost.y = -65;
            _txtTime.y = -65;
            _btnOK = new CButton();
            _btnOK.addButtonTexture(140, CButton.HEIGHT_41, CButton.BLUE, true);
            _btnOK.addTextField(140, 38, 0, -5, String(g.managerLanguage.allTexts[308]));
            _btnOK.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);
            _btnOK.y = 270;
            _sprEvent.addChild(_btnOK);
            _txtPrev = new CTextField(755, 200, String(g.managerLanguage.allTexts[465]));
            _txtPrev.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, ManagerFilters.BLUE_COLOR);
            _txtPrev.x = -383;
            _txtPrev.y = -260;
            _sprEvent.addChild(_txtPrev);
            _txtDescription = new CTextField(755, 200, String(g.managerLanguage.allTexts[474]));
            _txtDescription.setFormat(CTextField.BOLD30, 30,  ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
            _txtDescription.x = -383;
            _txtDescription.y = -200;
            _sprEvent.addChild(_txtDescription);
        }
        _sprEvent.addChild(_txtTime);
        _sprEvent.addChild(_txtTimeLost);

    }

    private function ratingWO():void {
        _bgWhiteRating = new BackgroundPartyLight(740,260);
        _bgWhiteRating.x = -_bgWhiteRating.width/2;
        _bgWhiteRating.y = -_bgWhiteRating.height/2 - 30;
        _sprRating.addChild(_bgWhiteRating);

        _bgRedRating = new BackgroundQuest(740,150);
        _bgRedRating.x = -_bgRedRating.width/2 + 5;
        _bgRedRating.y = 110;
        _sprRating.addChild(_bgRedRating);

        _contClipRect = new Sprite();
        _contClipRect.mask = new Quad(600,135);
        _contClipRect.x = -_bgRedRating.width/2+75;
        _contClipRect.y = 115;
        _sprRating.addChild(_contClipRect);
        _contItemRating = new Sprite();
        _contClipRect.addChild(_contItemRating);
        _txtPrevRating = new CTextField(730, 120, String(g.managerLanguage.allTexts[188]));
        _txtPrevRating.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
        _txtPrevRating.x = -370;
        _txtPrevRating.y = -195;
        _sprRating.addChild(_txtPrevRating);

        _txtMainRating = new CTextField(730, 100, String(g.managerLanguage.allTexts[275]));
        _txtMainRating.setFormat(CTextField.BOLD30, 28, ManagerFilters.BLUE_LIGHT_NEW);
        _txtMainRating.x = -370;
        _txtMainRating.y = -140;
        _sprRating.addChild(_txtMainRating);

        _arrowLeftRating = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plants_factory_arrow_red'));
        im.alignPivot();
        _arrowLeftRating.addChild(im);
        _arrowLeftRating.clickCallback = onClickLeft;
        _arrowLeftRating.x = -_woWidth/2 + 63;
        _arrowLeftRating.y = 187;
        _sprRating.addChild(_arrowLeftRating);

        _arrowRightRating = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plants_factory_arrow_red'));
        im.scaleX = -1;
        im.alignPivot();
        _arrowRightRating.addChild(im);
        _arrowRightRating.clickCallback = onClickRight;
        _arrowRightRating.x = _woWidth/2 - 63;
        _arrowRightRating.y = 187;
        _sprRating.addChild(_arrowRightRating);
        var b:Boolean = false;
        var item:WOPartyRatingFriendItem;
        _arrRating = [];
        _shift = 0;
        for (var i:int = 0; i < g.managerParty.arrBestPlayers.length; i++) {
            if (g.user.userId == g.managerParty.arrBestPlayers[i].userId) {
                b = true;
                item = new WOPartyRatingFriendItem(g.managerParty.arrBestPlayers[i], i+1, true);
            } else  {
                item = new WOPartyRatingFriendItem(g.managerParty.arrBestPlayers[i], i+1, false);
            }
            item.source.x = i*120 + 5;
            _arrRating.push(item);
            _contItemRating.addChild(item.source);
        }
        _contItemRating.x = 15;

        _txtBestGiftRating = new CTextField(200, 120, String(g.managerLanguage.allTexts[465])); // ТЕКСТ НАГРАДЫ
        _txtBestGiftRating.x = 140;
        _txtBestGiftRating.y = -80;
        _txtBestGiftRating.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
        _sprRating.addChild(_txtBestGiftRating);

        _imBestGiftRating = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bank_rubins_1'));
        MCScaler.scale(_imBestGiftRating, 115, 115);
        _imBestGiftRating.x = 200;
        _imBestGiftRating.y = 20;
        _sprRating.addChild(_imBestGiftRating);
    }

    private function onClickRight():void {
        _shift++;
        animList();
    }

    private function onClickLeft():void {
        _shift--;
        animList();
    }

    private function animList():void {
        var tween:Tween = new Tween(_contItemRating, .5);
        tween.moveTo(-_shift*600,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        g.starling.juggler.add(tween);
        checkArrows();
    }

    private function checkArrows():void {
        if ((_shift+1) == _arrRating.length/5) _arrowRightRating.visible = false;
        else _arrowRightRating.visible = true;
        if (_shift == 0) _arrowLeftRating.visible = false;
        else _arrowLeftRating.visible = true;
    }

    private function checkSocialInfoForArray():void {
        var userIds:Array = [];
        var p:Someone;

        for (var i:int=0; i < g.managerParty.arrBestPlayers.length; i++) {
            p = g.user.getSomeoneBySocialId(g.managerParty.arrBestPlayers[i].userSocialId);
            if (!p.photo && userIds.indexOf(g.managerParty.arrBestPlayers[i].userSocialId) == -1 && g.managerParty.arrBestPlayers[i].userSocialId != g.user.userSocialId) userIds.push(g.managerParty.arrBestPlayers[i].userSocialId);
            else if (p.photo && g.managerParty.arrBestPlayers[i].userSocialId != g.user.userSocialId) userIds.push(g.managerParty.arrBestPlayers[i].userSocialId);
        }
        if (userIds.length) {
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingInfo);
            g.socialNetwork.getTempUsersInfoById(userIds);
        }
    }

    private function onGettingInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingInfo);
        for (var i:int = 0; i < _arrItemRating.length; i++) {
            (_arrItemRating[i] as WOPartyRatingFriendItem).updateAvatar();
        }
    }

    override protected function deleteIt():void {
        for (var i:int = 0; i <_arrItem.length; i++) {
            _arrItem[i].deleteIt();
        }
        if (_txtBtn) {
            if (_btn)_btn.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        if (_txtDescription) {
            if (_sprEvent) _sprEvent.removeChild(_txtDescription);
            _txtDescription.deleteIt();
            _txtDescription = null;
        }
        if (_txtTime) {
            if (_sprEvent) _sprEvent.removeChild(_txtTime);
            _txtTime.deleteIt();
            _txtTime = null;
        }
        if (_txtTimeLost) {
            if (_sprEvent) _sprEvent.removeChild(_txtTimeLost);
            _txtTimeLost.deleteIt();
            _txtTimeLost = null;
        }
        if (_btn) {
            if (_sprEvent) _sprEvent.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        super.deleteIt();
    }

    private function onClickExit(e:Event=null):void {
        g.gameDispatcher.removeFromTimer(startTimer);
        super.hideIt();
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
import utils.MCScaler;

import windows.WOComponents.BackgroundYellowOut;

internal class PartyTabs {
    private var g:Vars = Vars.getInstance();
    private var _callback:Function;
    private var _sprUnActiveTabMain:CSprite;
    private var _sprUnActiveTabRating:CSprite;
    private var _imActiveTabMain:Image;
    private var _imActiveTabMainRating:Image;
    private var _imRating:Image;
    private var _imMain:Image;

    public function PartyTabs(source:Sprite, f:Function) {
        _callback = f;
        _sprUnActiveTabMain = new CSprite();
        _sprUnActiveTabMain.x = -510;
        _sprUnActiveTabMain.y = -120;
        _sprUnActiveTabRating = new CSprite();
        _sprUnActiveTabRating.x = -510;
        _sprUnActiveTabRating.y = 40;
        var im:Image = new Image(g.allData.atlas['partyAtlas'].getTexture('event_tab_nactive'));
        _sprUnActiveTabMain.addChild(im);
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('big_event_tap'));
        MCScaler.scale(im, im.height-10, im.width-10);
        im.x = 20;
        im.y = 30;
        _sprUnActiveTabMain.addChild(im);
        _sprUnActiveTabMain.endClickCallback = onClick;
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_tab_nactive'));
        _sprUnActiveTabRating.addChild(im);
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('big_top_tap'));
        MCScaler.scale(im, im.height-10, im.width-10);
        im.x = 20;
        im.y = 30;
        _sprUnActiveTabRating.addChild(im);
        _sprUnActiveTabRating.endClickCallback = onClick;
        source.addChild(_sprUnActiveTabMain);
        source.addChild(_sprUnActiveTabRating);
        _imActiveTabMain = new Image(g.allData.atlas['partyAtlas'].getTexture('event_tab_active'));
        _imActiveTabMain.x = -510;
        _imActiveTabMain.y = -120;
        source.addChildAt(_imActiveTabMain,1);
        _imActiveTabMainRating = new Image(g.allData.atlas['partyAtlas'].getTexture('event_tab_active'));
        _imActiveTabMainRating.x = -510;
        _imActiveTabMainRating.y = 40;
        source.addChildAt(_imActiveTabMainRating,1);
        _imMain = new Image(g.allData.atlas['partyAtlas'].getTexture('big_event_tap'));
        _imMain.x = -490;
        _imMain.y = -90;
        source.addChild(_imMain);
        MCScaler.scale(_imMain, _imMain.height-10, _imMain.width-10);

        _imRating = new Image(g.allData.atlas['partyAtlas'].getTexture('big_top_tap'));
        _imRating.x = -490;
        _imRating.y = 70;
        source.addChild(_imRating);
        MCScaler.scale(_imRating, _imRating.height-10, _imRating.width-10);
    }

    private function onClick():void { if (_callback!=null) _callback.apply(); }

    public function activate(isMain:Boolean):void {
        _imRating.visible = _imActiveTabMainRating.visible =_sprUnActiveTabMain.visible = !isMain;
        _imMain.visible = _sprUnActiveTabRating.visible = _imActiveTabMain.visible = isMain;
    }

    public function deleteIt():void {
    }

}