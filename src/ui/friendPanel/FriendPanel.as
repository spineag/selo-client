package ui.friendPanel {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import flash.geom.Point;

import flash.geom.Rectangle;

import manager.ManagerFilters;

import manager.Vars;

import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;

import starling.animation.Tween;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;

import tutorial.TutorialAction;
import tutorial.miniScenes.ManagerMiniScenes;

import user.NeighborBot;

import user.Someone;
import user.User;

import utils.CButton;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.HorizontalPlawka;

public class FriendPanel {
    private const TYPE_NORMAL:int = 1;
    private const TYPE_NEED_HELP:int = 2;
    private const TYPE_NEIGHBOR:int = 3;

    private var _source:Sprite;
    private var _mask:Sprite;
    private var _cont:Sprite;
    private var _addFriend:Sprite;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _arrFriends:Array;
    private var _arrItems:Array;
    private var _count:int;
    private var _shift:int;
    private var _addFriendsBtn:CButton;
    private var _tab1:CSprite;
    private var _tab2:CSprite;
    private var _tab3:CSprite;
    private var _activeTabType:int;
    private var _helpIcon:Image;
    private var _arrNeighborFriends:Array;

    private var g:Vars = Vars.getInstance();
    public function FriendPanel() {
        _source = new Sprite();
        onResize();
        g.cont.interfaceCont.addChild(_source);
        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_back_left'), g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_back_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_back_right'), 465);
        _source.addChild(pl);
        _mask = new Sprite();
        _mask.x = 105;
        _mask.y = 7;
        _cont = new Sprite();
        _mask.mask = new Quad(328, 90);
        _mask.addChild(_cont);
        createTabs();
        _source.addChild(_mask);
        createAddFriendBtn();
        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, onGettingInfo);
        _count = 0;
        _arrFriends = [];
        _arrNeighborFriends = [];
        _addFriend = new Sprite();
        _source.addChild(_addFriend);
        noFriends();
        g.directServer.getNeighborFriends(getNeighborFriends);
    }

    private function createTabs():void {
        _activeTabType = TYPE_NORMAL;
        _tab1 = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_tab'));
        im.x = 20;
        im.y = -23;
        _tab1.addChild(im);
        var txt:CTextField = new CTextField(106, 27, String(g.managerLanguage.allTexts[485]));
        txt.setFormat(CTextField.BOLD18, 14, ManagerFilters.BROWN_COLOR);
        txt.x = 30;
        txt.y = -23;
        _tab1.addChild(txt);
        _tab1.endClickCallback = onTab1Click;
        _source.addChild(_tab1);

        _tab2 = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_tab'));
        im.x = 20;
        im.y = -23;
        _tab2.addChild(im);
        txt = new CTextField(106, 27, String(g.managerLanguage.allTexts[486]));
        txt.setFormat(CTextField.BOLD18, 14, ManagerFilters.BROWN_COLOR);
        txt.x = 30;
        txt.y = -23;
        _tab2.addChild(txt);
        _tab2.x = 120;
        _helpIcon = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
        MCScaler.scale(_helpIcon, 20, 20);
        _helpIcon.x = 128;
        _helpIcon.y = -25;
        _tab2.addChild(_helpIcon);
        _source.addChildAt(_tab2, 0);
        _tab2.endClickCallback = onTab2Click;
        _helpIcon.visible = false;
//        if (g.user.isTester) {
            _tab3 = new CSprite();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_tab'));
            im.x = 20;
            im.y = -23;
            _tab3.addChild(im);
            txt = new CTextField(106, 27, String(g.managerLanguage.allTexts[1030]));
            txt.setFormat(CTextField.BOLD18, 14, ManagerFilters.BROWN_COLOR);
            txt.x = 30;
            txt.y = -23;
            _tab3.addChild(txt);
            _tab3.x = 240;
            _source.addChildAt(_tab3, 0);
            _tab3.endClickCallback = onTab3Click;
//        }
    }

    private function onTab1Click():void {
        if (g.managerTutorial.isTutorial || g.managerCutScenes.isCutScene) return;
        if (_activeTabType == TYPE_NORMAL) return;
        else {
            _shift = 0;
            animList();
            if (_tab3) _source.setChildIndex(_tab3, 0);

            _source.setChildIndex(_tab2, 0);
            _source.setChildIndex(_tab1, 3);
            _activeTabType = TYPE_NORMAL;
            fillFriends();
            checkArrows();
        }
    }

    private function onTab2Click():void {
        if (g.managerTutorial.isTutorial || g.managerCutScenes.isCutScene) return;
        if (_activeTabType == TYPE_NEED_HELP) return;
        else {
            _shift = 0;
            animList();
            if (_tab3) _source.setChildIndex(_tab3, 0);
            _source.setChildIndex(_tab1, 0);
            _source.setChildIndex(_tab2, 3);
            _activeTabType = TYPE_NEED_HELP;
            fillFriends();
            checkArrows();
        }
    }

    private function onTab3Click():void {
        if (g.managerTutorial.isTutorial || g.managerCutScenes.isCutScene) return;
        if (_activeTabType == TYPE_NEIGHBOR) return;
        else {
            _shift = 0;
            animList();
            _source.setChildIndex(_tab1, 0);
            _source.setChildIndex(_tab2, 0);
            if (_tab3) _source.setChildIndex(_tab3, 3);
            _activeTabType = TYPE_NEIGHBOR;
            fillFriends();
            checkArrows();
        }
    }

    private function createAddFriendBtn():void {
        _addFriendsBtn = new CButton();
        var st:String = 'friends_panel_bt_add';
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) st = 'Invite_friends_eng';
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(st));
        _addFriendsBtn.addDisplayObject(im);
        _addFriendsBtn.setPivots();
        _addFriendsBtn.x = 5 + _addFriendsBtn.width/2;
        _addFriendsBtn.y = 4 + _addFriendsBtn.height/2;
        _source.addChild(_addFriendsBtn);
       _addFriendsBtn.clickCallback = inviteFriends;
    }

    private function inviteFriends():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        g.socialNetwork.showInviteWindow();
    }

    public function onResize():void {
        if (!_source) return;
        _source.x = g.managerResize.stageWidth - 740;
        if (_source.visible) _source.y = g.managerResize.stageHeight - 89;
        else _source.y = g.managerResize.stageHeight + 100;
    }

    public function showIt():void {
        _source.visible  = true;
        TweenMax.killTweensOf(_source);
        new TweenMax(_source, .5, {y:g.managerResize.stageHeight - 89, ease:Back.easeOut, delay:.2});
    }

    public function hideIt(quick:Boolean = false, time:Number = .5):void {
        if (!quick) {
            TweenMax.killTweensOf(_source);
            new TweenMax(_source, time, {y: g.managerResize.stageHeight + 100, ease: Back.easeOut, onComplete: function ():void { _source.visible = false } });
        } else {
            _source.y = g.managerResize.stageHeight + 100;
        }
    }
    
    public function get isShowed():Boolean { return _source.visible; }

    private function createArrows():void {
        if (!_leftArrow) {
            _leftArrow = new CButton();
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
            _leftArrow.addDisplayObject(im);
            _leftArrow.setPivots();
            _leftArrow.x = 78 + _leftArrow.width / 2;
            _leftArrow.y = 15 + _leftArrow.height / 2;
            _source.addChild(_leftArrow);
            _leftArrow.clickCallback = onLeftClick;
        }

        if (!_rightArrow) {
            _rightArrow = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
            im.scaleX = -1;
            _rightArrow.addDisplayObject(im);
            _rightArrow.setPivots();
            _rightArrow.x = 485 - _rightArrow.width / 2;
            _rightArrow.y = 15 + _rightArrow.height / 2;
            _source.addChild(_rightArrow);
            _rightArrow.clickCallback = onRightClick;
        }
    }

    private function checkArrows():void {
        if (_leftArrow) {
            if (_shift <= 0) {
                _leftArrow.setEnabled = false;
            } else {
                _leftArrow.setEnabled = true;
            }
        }
        if (_rightArrow) {
            if (_shift + 5 >= _arrFriends.length) {
                _rightArrow.setEnabled = false;
            } else {
                _rightArrow.setEnabled = true;
            }
        }
    }

    public function onGettingInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, onGettingInfo);
        fillFriends();
        g.managerAchievement.achievementCountFriend(_arrFriends.length);
    }

    private function getNeighborFriends(arr:Array):void {
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] == 0) {
                arr.splice(i,1);
                i--;
            }
        }
       _arrNeighborFriends = arr;
    }

    public function updateFriendsPanel():void {
        if (_activeTabType == TYPE_NEED_HELP) {
            fillFriends();
        } else {
            checkHelpIcon();
        }
    }

    private function fillFriends():void {
        clearItems();
        Cc.ch('social', 'friendUI: fill friends');
        if (_activeTabType == TYPE_NORMAL) {
            _arrFriends = g.user.arrFriends.slice();
        } else if (_activeTabType == TYPE_NEED_HELP) {
            var ar:Array = g.user.arrFriends.slice();
            _arrFriends = [];
            for (var i:int=0; i<ar.length; i++) {
                if ((ar[i] as Someone).needHelpCount > 0) _arrFriends.push(ar[i]);
            }
        }
        if (_activeTabType == TYPE_NORMAL) {
            addButtonsAddFriends();
        }
        createLevel();
    }

    private function addButtonsAddFriends():void {
        var bt:CButton;
        var im:Image;
        var txt:CTextField;
        if (_arrFriends.length == 0) {
            Cc.ch('social', 'friendUI: fill 3 add');
            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(64, 50, String(g.managerLanguage.allTexts[487]));
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = 4;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 237 + bt.width / 2;
            bt.y = 6 + bt.height / 2;
            _addFriend.addChild(bt);
            bt.clickCallback = inviteFriends;

            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(60, 50, String(g.managerLanguage.allTexts[487]));
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = 4;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 303 + bt.width / 2;
            bt.y = 6 + bt.height / 2;
            _addFriend.addChild(bt);
            bt.clickCallback = inviteFriends;

            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(60, 50, String(g.managerLanguage.allTexts[487]));
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = 4;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 369 + bt.width / 2;
            bt.y = 6 + bt.height / 2;
            _addFriend.addChild(bt);
            bt.clickCallback = inviteFriends;
        } else if (_arrFriends.length == 1) {
            Cc.ch('social', 'friendUI: fill 2 add');
            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(60, 50, String(g.managerLanguage.allTexts[487]));
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = 4;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 303 + bt.width / 2;
            bt.y = 6 + bt.height / 2;
            _addFriend.addChild(bt);
            bt.clickCallback = inviteFriends;

            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(60, 50, String(g.managerLanguage.allTexts[487]));
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = 4;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 369 + bt.width / 2;
            bt.y = 6 + bt.height / 2;
            _addFriend.addChild(bt);
            bt.clickCallback = inviteFriends;
        } else if (_arrFriends.length == 2) {
            Cc.ch('social', 'friendUI: fill 1 add');
            bt = new CButton();
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_friend_button'));
            bt.addDisplayObject(im);
            txt = new CTextField(60, 50, String(g.managerLanguage.allTexts[487]));
            txt.setFormat(CTextField.BOLD18, 12, ManagerFilters.BROWN_COLOR);
            txt.x = 4;
            txt.y = 12;
            bt.addChild(txt);
            bt.setPivots();
            bt.x = 369 + bt.width / 2;
            bt.y = 6 + bt.height / 2;
            _addFriend.addChild(bt);
            bt.clickCallback = inviteFriends;
        }
    }

    public function addNeighborFriend(person:Someone):void {
        _arrNeighborFriends.push(person);
        g.directServer.updateNeighborFriends();
        clearItems();
        _activeTabType = TYPE_NEIGHBOR;
        _source.setChildIndex(_tab1, 0);
        _source.setChildIndex(_tab2, 0);
        if (_tab3) _source.setChildIndex(_tab3, 3);
        _arrNeighborFriends.sortOn("level",  Array.NUMERIC);
        _arrNeighborFriends.reverse();
        var item:FriendItem;
        for (var i:int = 0; i < _arrNeighborFriends.length; i++) {
            item = new FriendItem(_arrNeighborFriends[i],i,false);
            _arrItems.push(item);
            item.source.x = i*66;
            item.source.y = -1;
            _cont.addChild(item.source);
        }
        checkSocialInfoForArray();
    }

    public function deleteNeighborFriend(person:Someone):void {
        var i:int;
        for (i= 0; i <_arrNeighborFriends.length; i++) {
            if (_arrNeighborFriends[i] && _arrNeighborFriends[i].userSocialId == person.userSocialId) {
                _arrNeighborFriends.splice(i,1);
            }
        }
        g.directServer.updateNeighborFriends();
        if (_arrNeighborFriends.length > 0) {
            clearItems();
            _activeTabType = TYPE_NEIGHBOR;
            _source.setChildIndex(_tab1, 0);
            _source.setChildIndex(_tab2, 0);
            if (_tab3) _source.setChildIndex(_tab3, 3);
            _arrNeighborFriends.sortOn("level", Array.NUMERIC);
            _arrNeighborFriends.reverse();
            var item:FriendItem;
            for (i = 0; i < _arrNeighborFriends.length; i++) {
                item = new FriendItem(_arrNeighborFriends[i], i,false);
                _arrItems.push(item);
                item.source.x = i * 66;
                item.source.y = -1;
                _cont.addChild(item.source);
            }
            checkSocialInfoForArray();
        } else {
            clearItems();
            _activeTabType = TYPE_NEIGHBOR;
        }
    }

    private function checkHelpIcon():void {
        for (var i:int=0; i<_arrFriends.length; i++) {
            if (_arrFriends[i] is User || _arrFriends[i] is NeighborBot) continue;
            if ((_arrFriends[i] as Someone).needHelpCount > 0) {
                _helpIcon.visible = true;
                return;
            }
        }
        _helpIcon.visible = false;
    }

    private function sortFriend():void {
        Cc.ch('social', 'friendUI: sortFriend');
        var item:FriendItem;
        _arrItems = [];
        _shift = 0;
        var i:int;
        if (_activeTabType == TYPE_NEIGHBOR) {
            _arrNeighborFriends.sortOn("level",  Array.NUMERIC);
            _arrNeighborFriends.reverse();
            for (i= 0; i < _arrNeighborFriends.length; i++) {
                item = new FriendItem(_arrNeighborFriends[i],i,false);
                _arrItems.push(item);
                item.source.x = i*66;
                item.source.y = -1;
                _cont.addChild(item.source);
            }
            checkSocialInfoForArray();
            return;
        }
        _arrFriends.sortOn("level",  Array.NUMERIC);
        _arrFriends.reverse();
        if (_activeTabType == TYPE_NORMAL) {
            _arrFriends.unshift(g.user.neighbor);
            _arrFriends.unshift(g.user);
            checkHelpIcon();
        } else if (_activeTabType == TYPE_NEED_HELP) {
            if (_arrFriends.length) _helpIcon.visible = true;
                else _helpIcon.visible = false;
        }
        if (_arrFriends.length > 5) {
            createArrows();
            checkArrows();
        }
        var l:int = _arrFriends.length;
        if (l>5) l = 5;
        for (i= 0; i < l; i++) {
            item = new FriendItem(_arrFriends[i],i);
            _arrItems.push(item);
            item.source.x = i*66;
            item.source.y = -1;
            _cont.addChild(item.source);
        }
    }

    private function clearItems():void {
        if (!_arrItems) return;
        for (var i:int = 0; i < _arrItems.length; i++) {
            _cont.removeChild(_arrItems[i].source);
            (_arrItems[i] as FriendItem).deleteIt();
        }
        while (_addFriend.numChildren) {
            _addFriend.removeChildAt(0);
        }
        _arrItems.length = 0;
        _arrFriends.length = 0;
        _shift = 0;
    }

    private function onLeftClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        if (g.managerMiniScenes.isMiniScene && g.managerMiniScenes.isReason(ManagerMiniScenes.GO_NEIGHBOR)) g.managerMiniScenes.finishLetGoToNeighbor();
        var newCount:int = 5;
        if (_shift - newCount < 0) newCount = _shift;
        _shift -= newCount;

        var item:FriendItem;
        for (var i:int=0; i<newCount; i++) {
            item = new FriendItem(_arrFriends[_shift + i],_shift + i);
//            if(_arrFriends[_shift+i] is NeighborBot){
//            }
            _arrItems.unshift(item);
            item.source.x = 66 * (_shift + i);
            item.source.y = -1;
            _cont.addChild(item.source);
        }

        _arrItems.sortOn('position', Array.NUMERIC);
        var f:Function = function():void {
            for (i=0; i<newCount; i++) {
                item = _arrItems.pop();
                _cont.removeChild(item.source);
                item.deleteIt();
            }
        };
        animList(f);
    }

    private function onRightClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial) return;
        var newCount:int = 5;
        if (_shift + newCount + 5 >= _arrFriends.length) newCount = _arrFriends.length - _shift - 5;
        var item:FriendItem;
        for (var i:int=0; i<newCount; i++) {
            if (_arrFriends[_shift + 4 + i]) {
                item = new FriendItem(_arrFriends[_shift + 5 + i],_shift + 5 + i);
                item.source.x = 66 * (_shift + 5 + i);
                _cont.addChild(item.source);
                _arrItems.push(item);
            }
        }
        _arrItems.sortOn('position', Array.NUMERIC);
        _shift += newCount;
        var f:Function = function():void {
            for (i=0; i<newCount; i++) {
                item = _arrItems.shift();
                _cont.removeChild(item.source);
                item.deleteIt();
            }
        };
        animList(f);
    }

    private function animList(callback:Function = null):void {
        var tween:Tween = new Tween(_cont, .5);
        tween.moveTo(-_shift*66, _cont.y);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            if (callback != null) callback.apply();
        };
        g.starling.juggler.add(tween);
        checkArrows();
    }

    private function createLevel():void {
        var arr:Array = [];
        var i:int;
        if (_activeTabType == TYPE_NEIGHBOR && _arrNeighborFriends.length > 0) {
            sortFriend();
            return;
        } else {
            for (i = 0; i < _arrFriends.length; i++) {
                arr.push(_arrFriends[i].userSocialId);
            }
        }
        if (arr.length > 0) g.directServer.getAllFriendsInfo(arr, sortFriend);
        else if (_activeTabType != TYPE_NEIGHBOR) noFriends();
    }

    public function checkLevel():void {
        if (_arrFriends && _arrFriends.length) {
            for (var i:int = 0; i < _arrFriends.length; i++) {
                if (_arrFriends[i].userSocialId == g.user.userSocialId) {
                    _arrItems[i].txtLvl.text = String(g.user.level);
                }
            }
        }
    }
    public function get arrNeighborFriends():Array {
        return _arrNeighborFriends;
    }

    public function get arrFriends():Array {
        return _arrFriends;
    }

    public function getNeighborItemProperties():Object {
            var ob:Object = {};
            ob.x = 173;
            ob.y = 7;
            var p:Point = new Point(ob.x, ob.y);
            p = _source.localToGlobal(p);
            ob.x = p.x;
            ob.y = p.y;
            ob.width = 60;
            ob.height = 70;
            return ob;
    }

    private function noFriends():void {
        clearItems();
        Cc.ch('social', 'friendUI: no friends');
        var item:FriendItem;
        _arrItems = [];
        _shift = 0;
        _arrFriends.length = 0;
        if (_activeTabType == TYPE_NORMAL) {
            addButtonsAddFriends();
            _arrFriends.unshift(g.user.neighbor);
            _arrFriends.unshift(g.user);
        }
        _helpIcon.visible = false;
        if (_arrFriends.length >= 2) {
            for (var i:int = 0; i < 2; i++) {
                item = new FriendItem(_arrFriends[i]);
                if (item.source) {
                    _arrItems.push(item);
                    item.source.x = i * 66;
                    item.source.y = -1;
                    _cont.addChild(item.source);
                }
            }
        }
    }

    private function checkSocialInfoForArray():void {
        var userIds:Array = [];
        var p:Someone;
        for (var i:int = 0; i < _arrNeighborFriends.length; i++) {
            p = g.user.getSomeoneBySocialId(_arrNeighborFriends[i].userSocialId);
            if (!p.photo && userIds.indexOf(_arrNeighborFriends[i].userSocialId) == -1) userIds.push(_arrNeighborFriends[i].userSocialId);
            else if (p.photo) userIds.push(_arrNeighborFriends[i].userSocialId);
        }
        if (userIds.length) {
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettInfo);
            g.socialNetwork.getTempUsersInfoById(userIds);
        }
    }

    private function onGettInfo(e:SocialNetworkEvent):void {
        if (e) g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettInfo);
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].updateAvatar(_arrItems[i].person.level,_arrItems[i].person.userId);
        }
    }
}
}
