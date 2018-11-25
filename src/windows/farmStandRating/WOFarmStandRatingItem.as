/**
 * Created by user on 7/3/18.
 */
package windows.farmStandRating {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.ManagerFilters;
import manager.Vars;

import social.SocialNetwork;

import social.SocialNetworkEvent;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import user.Someone;

import utils.CButton;
import utils.CSprite;

import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.BackgroundQuest;
import windows.WOComponents.BackgroundQuestDone;
import windows.WindowsManager;

public class WOFarmStandRatingItem {
    public var source:Sprite;
    private var _srcAva:CSprite;
    private var _ava:Image;
    private var _ramka:Image;
    private var _txtName:CTextField;
    private var _txtCount:CTextField;
    private var _txtCountDescription:CTextField;
    private var _txtNumber:CTextField;
    private var _goAway:CButton;
    private var g:Vars = Vars.getInstance();
    private var _person:Someone;
    private var _userSocialId:String;

    public function WOFarmStandRatingItem(number:int, userId:int, count:int, socialId:String, numberUser:int = -1) {
        if (userId != g.user.userId) _person = g.user.getSomeoneBySocialId(socialId);
        else _person = g.user;
        _userSocialId = socialId;
        source = new Sprite();
        if (number%2 == 0) {
            var bgD:BackgroundQuestDone = new BackgroundQuestDone(600, 100);
            source.addChild(bgD);
        } else {
            var bg:BackgroundQuest = new BackgroundQuest(600, 100);
            source.addChild(bg);
        }
        _txtName = new CTextField(500, 70, _person.name + ' ' + _person.lastName);
        _txtName.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtName.alignH = Align.LEFT;
        source.addChild(_txtName);
        _txtName.x = 100;
        _txtName.y = -10;
        _txtCount = new CTextField(500, 70, count +' ');
        _txtCount.setFormat(CTextField.BOLD30, 30,ManagerFilters.BLUE_COLOR);
        _txtCount.alignH = Align.LEFT;
        source.addChild(_txtCount);
        _txtCount.x = 100;
        _txtCount.y = 35;
        _txtCountDescription = new CTextField(500, 70,String(g.managerLanguage.allTexts[1689]));
        _txtCountDescription.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtCountDescription.alignH = Align.LEFT;
        source.addChild(_txtCountDescription);
        _txtCountDescription.x = _txtCount.x + _txtCount.textBounds.width;
        _txtCountDescription.y = 40;
        _txtNumber = new CTextField(500, 70, String(int(number)));
        if (numberUser > -1) _txtNumber.text = String(numberUser);
        _txtNumber.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtNumber.alignH = Align.CENTER;
        source.addChild(_txtNumber);
        _txtNumber.x = -201;
        _txtNumber.y = -22;
        if (userId != g.user.userId) {
            _goAway = new CButton();
            _goAway.addButtonTexture(100, CButton.HEIGHT_55, CButton.GREEN, true);
            _goAway.addTextField(100, 49, 0, 0, String(g.managerLanguage.allTexts[386]));
            _goAway.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
            _goAway.x = 540;
            _goAway.y = 50;
            source.addChild(_goAway);
            _goAway.clickCallback = visitPerson;
        }

        _srcAva = new CSprite();
        source.addChild(_srcAva);
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 60, 60);
        _ava.x = 20;
        _ava.y = 28;
        _srcAva.addChild(_ava);
        if (userId == g.user.userId) _ramka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame_blue'));
        else _ramka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame'));
        _ramka.x = 10;
        _ramka.y = 22;
        _srcAva.addChild(_ramka);
        if ((_person || socialId == g.user.userSocialId) && g.pBitmaps[_person.photo]) {
            onLoadPhoto(g.pBitmaps[_person.photo].create() as Bitmap);
        }
    }

    public function updateAvatar():void {
        _person = g.user.getSomeoneBySocialId(_userSocialId);
////        Cc.info('WOPartyRatingFriendItem update avatar');
//        if (!_person.photo) _person = g.user.getSomeoneBySocialId(_person.userSocialId);
//        if (_person.photo =='' || _person.photo == 'unknown') _person.photo =  SocialNetwork.getDefaultAvatar();
        _txtName.text = _person.name + ' ' + _person.lastName;
        g.load.loadImage(_person.photo, onLoadPhoto);
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!_person) {
            Cc.error('WOPartyRatingFriendItem onLoadPhoto:: no _person');
            return;
        }
        Cc.ch('social', 'WOPartyRatingFriendItem on load photo: ' + _person.photo);
        if (!bitmap) bitmap = g.pBitmaps[_person.photo].create() as Bitmap;
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
            _ramka.dispose();
            _ramka = null;
            source.removeChild(_srcAva);
        }
        _srcAva = new CSprite();
        source.addChildAt(_srcAva,2);
        _ava = new Image(tex);
        MCScaler.scale(_ava, 60, 60);
        _ava.x = 20;
        _ava.y = 28;
        _srcAva.addChild(_ava);
        if (_person.userId == g.user.userId) _ramka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame_blue'));
        else _ramka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame'));
        _ramka.x = 10;
        _ramka.y = 22;
        _srcAva.addChild(_ramka);
//        source.addChildAt(_srcAva,0);
        if (_person.userSocialId != g.user.userSocialId) {
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
        g.windowsManager.closeAllWindows();
        g.townArea.goAway(_person, false);
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        if (!_person.name) _person = g.user.getSomeoneBySocialId(_person.userSocialId);
        if (_person.photo =='' || _person.photo == 'unknown') _person.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_person.photo, onLoadPhoto);
    }
}
}
