/**
 * Created by user on 7/31/15.
 */
package ui.friendPanel {
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;
import preloader.miniPreloader.FlashAnimatedPreloader;

import social.SocialNetwork;

import social.SocialNetworkEvent;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import tutorial.TutsAction;
import tutorial.managerCutScenes.ManagerCutScenes;
import tutorial.miniScenes.ManagerMiniScenes;

import user.NeighborBot;

import user.NeighborBot;
import user.Someone;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.SimpleArrow;

import windows.WindowsManager;

public class FriendItem {
    private var _person:Someone;
    public var source:CSprite;
    private var _ava:Image;
    private var _txtName:CTextField;
    public var txtLvl:CTextField;
    private var _preloader:FlashAnimatedPreloader;
    private var _timer:int;
    private var _positionInList:int;
    private var g:Vars = Vars.getInstance();
    private var _friendBoardHelpInfo:CSprite;
    private var _arrow:SimpleArrow;
    private var _spArrow:Sprite;

    public function FriendItem(f:Someone,pos:int =0, needAva:Boolean = true) {
        _person = f;
        _positionInList = pos;
        if (!_person) {
            Cc.error('FriendItem:: person == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'friendItem');
            return;
        }

        source = new CSprite();
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 60, 60);
        _ava.x = 10;
        _ava.y = 8;
        source.addChildAt(_ava,0);
        var im:Image;
        if (g.user.userSocialId == _person.userSocialId) im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("friend_frame_blue"));
        else im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("friend_frame"));
        source.addChildAt(im,1);
        _preloader = new FlashAnimatedPreloader();
        _preloader.source.x = 40;
        _preloader.source.y = 40;
        source.addChild(_preloader.source);
        _timer = 5;
        g.gameDispatcher.addToTimer(onTimer);
        if (needAva) {
            if (_person is NeighborBot) {
                photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
            } else {
                if (_person.photo) {
                    Cc.ch('social', 'FriendItem photo: ' + _person.photo);
                    g.load.loadImage(_person.photo, onLoadPhoto);
                } else {
                    Cc.ch('social', 'FriendItem no photo for uid: ' + _person.userSocialId);
                    g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                    g.socialNetwork.getTempUsersInfoById([_person.userSocialId]);
                }
            }
        }
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("xp_icon"));
        MCScaler.scale(im,45,45);
        im.x = 35;
        im.y = 41;
        source.addChild(im);

        txtLvl = new CTextField(40, 18, "");
        txtLvl.setFormat(CTextField.BOLD18, 16, 0xff7a3f, Color.WHITE);
        txtLvl.cacheIt = false;
        txtLvl.text = '1';
        txtLvl.text = String(_person.level);
        txtLvl.x = 38;
        txtLvl.y = 53;
        source.addChild(txtLvl);
        if (txtLvl.text == null || int(txtLvl.text) == 0) txtLvl.text = '1';
        if (_person is NeighborBot) txtLvl.text = '60';
        _txtName = new CTextField(64, 30, "");
        _txtName.needCheckForASCIIChars = true;
        _txtName.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtName.y = -15;
        _txtName.x = 8;
        if (_person.name) {
            setName(_person.name);
        } else {
            setName('loading');
        }
        source.addChild(_txtName);
        source.endClickCallback = visitPerson;

        if (_person && _person.needHelpCount > 0) {
            _friendBoardHelpInfo = new CSprite();
            var help:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
            MCScaler.scale(help, 20, 20);
            help.x = 46;
            help.y = 10;
            _friendBoardHelpInfo.addChild(help);
            _friendBoardHelpInfo.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[481])); };
            _friendBoardHelpInfo.outCallback = function():void { g.hint.hideIt(); };
            source.addChild(_friendBoardHelpInfo);
        }
    }

    private function visitPerson():void {
        g.bottomPanel.deleteArrow();
        if (g.miniScenes.isMiniScene && (g.miniScenes.isReason(ManagerMiniScenes.BUY_ORDER) || g.miniScenes.isReason(ManagerMiniScenes.OPEN_ORDER))) return;
        if (g.managerCutScenes.isCutScene) {
            if (_person is NeighborBot && g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_GO_TO_NEIGHBOR)) g.managerCutScenes.checkCutSceneCallback();
            else return;
        }
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.managerSalePack) g.managerSalePack.onUserAction();
        if (g.managerStarterPack) g.managerStarterPack.onUserAction();
        if (g.visitedUser && g.visitedUser == _person) return;
        if (g.tuts.isTuts) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) return;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (_person == g.user) {
            if (g.isAway) g.townArea.backHome();
            if (g.partyPanel) g.partyPanel.visiblePartyPanel(true);
        } else {
            g.townArea.goAway(_person);
        }
        g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!_person) {
            Cc.error('FriendItem onLoadPhoto:: no _person');
            return;
        }
        Cc.ch('social', 'FriendItem on load photo: ' + _person.photo);
        if (!bitmap) {
            bitmap = g.pBitmaps[_person.photo].create() as Bitmap;
        }
        if (!bitmap) {
            if (_preloader) {
                source.removeChild(_preloader.source);
                _preloader.deleteIt();
                _preloader = null;
                g.gameDispatcher.removeFromTimer(onTimer);
            }
            Cc.error('FriendItem:: no photo for userId: ' + _person.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        if (!_person) return;
        if (!_person.name) _person = g.user.getSomeoneBySocialId(_person.userSocialId);
        if (!_person.name) return;
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        setName(_person.name);
        if (_person.photo =='' || _person.photo == 'unknown') _person.photo = SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_person.photo, onLoadPhoto);
    }

    private function setName(st:String):void { _txtName.text = st; }
    public function get position():int { return _positionInList; }
    public function get person():Someone { return _person; }

    private function photoFromTexture(tex:Texture):void {
        if (_preloader) {
            source.removeChild(_preloader.source);
            _preloader.deleteIt();
            _preloader = null;
        }
        if (_ava) {
            source.removeChild(_ava);
            _ava = null;
        }
        if (!tex) return;
        _ava = new Image(tex);
        MCScaler.scale(_ava, 60, 60);
        _ava.x = 10;
        _ava.y = 8;
        if (source) source.addChildAt(_ava,0);
    }

    private function onTimer():void {
        _timer--;
        if (_timer <= 0) {
            g.gameDispatcher.removeFromTimer(onTimer);
            if (_preloader) {
                source.removeChild(_preloader.source);
                _preloader.deleteIt();
                _preloader = null;
            }
        }
    }


    public function getItemProperties():Object {
        var ob:Object = {};
        ob.x = source.x;
        ob.y = source.y;
        var p:Point = new Point(ob.x, ob.y);
        p = source.parent.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = 60; //(_arrItems[_shift + a-1] as ShopItem).source.width;
        ob.height = 70; //(_arrItems[_shift + a-1] as ShopItem).source.height;
        return ob;
    }

    public function deleteIt():void {
        _person = null;
        _ava = null;
        _txtName = null;
        txtLvl = null;
        if (_preloader) _preloader = null;
        source.deleteIt();
        source = null;
        if (_friendBoardHelpInfo) _friendBoardHelpInfo = null;
    }

    public function updateAvatar(level:int, uid:int):void {
        Cc.ch('social', 'FriendItem updateAvatar: ' );
        if (!_person.photo) _person = g.user.getSomeoneBySocialId(_person.userSocialId);
        if (_person.photo =='' || _person.photo == 'unknown') _person.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_person.photo, onLoadPhoto);
        _person.level = level;
        _person.userId = uid;
    }

    public function addArow(time:int):void {
        _spArrow = new Sprite();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, _spArrow);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(50, -108);
        _spArrow.scaleY = -1;
        _spArrow.x = _ava.x;
        _spArrow.y = -_ava.y - _ava.width/2;
        source.addChild(_spArrow);
        _arrow.activateTimer(time, deleteArrow);
    }

    private function deleteArrow():void {
        if (_spArrow) {
            _spArrow.dispose();
            _spArrow = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }


}
}
