/**
 * Created by user on 5/24/17.
 */
package windows.partyWindow {
import com.junkbyte.console.Cc;

import data.BuildType;

import data.StructureDataBuilding;

import flash.display.Bitmap;

import manager.ManagerFilters;

import manager.Vars;

import social.SocialNetwork;

import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Quad;

import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import starling.utils.Color;

import user.Someone;

import utils.CSprite;

import utils.CTextField;

import utils.MCScaler;

import windows.WindowsManager;

public class WOPartyRatingFriendItem {
    public var source:Sprite;
    private var _srcAva:CSprite;
    private var _ava:Image;
    private var _txtCountResource:CTextField;
    private var _txtNamePerson:CTextField;
    private var _imResource:Image;
    private var _personS:Someone;
    private var _data:Object;
    private var _imRamka:Image;
    private var _number:int;
    private var _imBackCount:Image;

    private var g:Vars = Vars.getInstance();

    public function WOPartyRatingFriendItem(ob:Object, number:int, user:Boolean = false) {
        _personS = new Someone();
        if (ob) {
            _personS.userId = ob.userId;
            _personS.userSocialId = ob.userSocialId;
            _personS.photo = ob.photo;
            _personS.name = ob.name;
            _personS.level = ob.level;
            _data = ob;
        } else if (user) {
            _personS.userId = g.user.userId;
            _personS.userSocialId = g.user.userSocialId;
            _personS.photo = g.user.photo;
            _personS.name = g.user.name;
            _personS.level = g.user.level;
            _data = {};
            _data.level = _personS.level;
            _data.userId = _personS.userId;
            _data.userSocialId = _personS.userSocialId;
        }
        _number = number;
        source = new Sprite();
        source.y = 40;
        var im:Image;

        _srcAva = new CSprite();
        source.addChild(_srcAva);
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 60, 60);
        _ava.x = 10;
        _ava.y = 8;
        _srcAva.addChild(_ava);
        if (_number == 1) _imRamka = new Image(g.allData.atlas['partyAtlas'].getTexture('ne_window_frame_1'));
        else if (_number == 2) _imRamka = new Image(g.allData.atlas['partyAtlas'].getTexture('ne_window_frame_2'));
        else if (_number == 3) _imRamka = new Image(g.allData.atlas['partyAtlas'].getTexture('ne_window_frame_3'));
        else if (user) _imRamka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame_blue'));
        else  _imRamka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame'));
        _srcAva.addChild(_imRamka);

        if ((user || ob.userSocialId == g.user.userSocialId) && g.pBitmaps[_personS.photo]) {
            onLoadPhoto(g.pBitmaps[_personS.photo].create() as Bitmap);
        }
        _imBackCount = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_m_big'));
        _imBackCount.x = 53;
        _imBackCount.y = 40;
        source.addChild(_imBackCount);
        if (user) _txtCountResource = new CTextField(250, 100, String(g.managerParty.userParty[0].countResource));
        else _txtCountResource = new CTextField(250, 100, String(ob.countResource));
        _txtCountResource.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountResource.alignH = Align.CENTER;
        source.addChild(_txtCountResource);
        _txtCountResource.x = -52;
        _txtCountResource.y = 9;
        if (number == 1) {
            im = new Image(g.allData.atlas['partyAtlas'].getTexture('first_top_event_window'));
            im.x = 4;
        } else if (number == 2) {
            im = new Image(g.allData.atlas['partyAtlas'].getTexture('second_top_event_window'));
            im.x = 4;
        } else if (number == 3) {
            im = new Image(g.allData.atlas['partyAtlas'].getTexture('third_top_event_window'));
            im.x = 4;
        } else {
            im = new Image(g.allData.atlas['partyAtlas'].getTexture('other_top_event_window'));
            im.x = 16;
        }
        im.y =-40;
        source.addChild(im);
        var txt:CTextField = new CTextField(250, 100, String(number));
        if (number > 3) {
            txt.setFormat(CTextField.BOLD30, 28, 0xb116cc, Color.WHITE);
            txt.alignH = Align.CENTER;
            txt.y = -70;
            txt.x =  -88;
            source.addChild(txt);
        }

        _txtNamePerson = new CTextField(150, 120, '');
        _txtNamePerson.needCheckForASCIIChars = true;
        _txtNamePerson.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtNamePerson.alignH = Align.LEFT;
        if (user) _txtNamePerson.text = g.user.name;
        else _txtNamePerson.text = _personS.name;
        _txtNamePerson.x = -_txtNamePerson.textBounds.width/2 + 43;
        _txtNamePerson.y = 25;
        source.addChild(_txtNamePerson);
    }

    public function updateAvatar():void {
        Cc.info('WOPartyRatingFriendItem update avatar');
        if (!_personS.photo) _personS = g.user.getSomeoneBySocialId(_personS.userSocialId);
        if (_personS.photo =='' || _personS.photo == 'unknown') _personS.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_personS.photo, onLoadPhoto);
        _personS.level = _data.level;
        _personS.userId = _data.userId;
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!_personS) {
            Cc.error('WOPartyRatingFriendItem onLoadPhoto:: no _person');
            return;
        }
        Cc.ch('social', 'WOPartyRatingFriendItem on load photo: ' + _personS.photo);
        if (!bitmap) bitmap = g.pBitmaps[_personS.photo].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        if (!tex) return;
        if (_srcAva && _ava) {
            _srcAva.removeChild(_ava);
            _srcAva.deleteIt();
            _srcAva.dispose();
            _srcAva = null;
            _ava.dispose();
            _ava = null;
            _imRamka.dispose();
            _imRamka = null;
        }
        _srcAva = new CSprite();
        source.addChild(_srcAva);
        _ava = new Image(tex);
        MCScaler.scale(_ava, 60, 60);
        _ava.x = 10;
        _ava.y = 8;
        _srcAva.addChild(_ava);
        if (_number == 1) _imRamka = new Image(g.allData.atlas['partyAtlas'].getTexture('ne_window_frame_1'));
        else if (_number == 2) _imRamka = new Image(g.allData.atlas['partyAtlas'].getTexture('ne_window_frame_2'));
        else if (_number == 3) _imRamka = new Image(g.allData.atlas['partyAtlas'].getTexture('ne_window_frame_3'));
        else if ( _personS.userId == g.user.userId) _imRamka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame_blue'));
        else  _imRamka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame'));
        _srcAva.addChild(_imRamka);
        if (_data.userSocialId != g.user.userSocialId) {
            _srcAva.endClickCallback = visitPerson;
            _srcAva.hoverCallback = function ():void {
                g.hint.showIt(String(g.managerLanguage.allTexts[386]));
            };
            _srcAva.outCallback = function ():void {
                g.hint.hideIt();
            };
        }
    }

    private function visitPerson():void {
        g.townArea.goAway(_personS);
        g.windowsManager.hideWindow(WindowsManager.WO_PARTY);
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        if (!_personS.name) _personS = g.user.getSomeoneBySocialId(_personS.userSocialId);
        if (_personS.photo =='' || _personS.photo == 'unknown') _personS.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_personS.photo, onLoadPhoto);
    }
}
}
