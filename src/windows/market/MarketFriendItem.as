/**
 * Created by user on 8/27/15.
 */
package windows.market {
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;

import social.SocialNetwork;

import social.SocialNetworkEvent;

import starling.display.Image;
import starling.display.Quad;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import user.NeighborBot;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class MarketFriendItem {
    private var _person:Someone;
    public var source:CSprite;
    private var _ava:Image;
    private var _txtName:CTextField;
    private var _wo:WOMarket;
    public var visitBtn:CButton;
    private var _shiftFriend:int;
    private var _txtBtn:CTextField;
    private var _helpIcon:Image;
    private var _imRamka:Image;
    private var g:Vars = Vars.getInstance();

    public function MarketFriendItem(f:Someone, wo:WOMarket, _shift:int) {
        _shiftFriend = _shift;
        source = new CSprite();
        _person = f;
        if (!_person) {
            Cc.error('MarketFriendItem:: person == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketFriendMarket');
            return;
        }
        _wo = wo;
        if (_person is NeighborBot) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (_person.photo) {
//                _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
//                MCScaler.scale(_ava, 85, 85);
//                _ava.x = 12;
//                _ava.y = 12;
//                source.addChild(_ava);
                g.load.loadImage(_person.photo, onLoadPhoto);
            } else {
                g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                g.socialNetwork.getTempUsersInfoById([_person.userSocialId]);
            }
        }
        _txtName = new CTextField(100, 30, 'loading...');
        _txtName.needCheckForASCIIChars = true;
        _txtName.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtName.y = -25;
        if (_person.name) _txtName.text = _person.name;
        source.addChild(_txtName);
        source.endClickCallback = chooseThis;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        visitBtn = new CButton();
        visitBtn.addButtonTexture(80, CButton.HEIGHT_32, CButton.GREEN, true);
        _txtBtn = new CTextField(76, 25, String(g.managerLanguage.allTexts[386]));
        _txtBtn.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtBtn.x = 2;
        _txtBtn.y = 3;
        visitBtn.addChild(_txtBtn);
        visitBtn.x = 55;
        visitBtn.y = 3;
        visitBtn.clickCallback = visitPerson;
        visitBtn.visible = false;
        _imRamka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_friend_panel'));
        source.addChild(_imRamka);

        if (_person.needHelpCount > 0) {
            _helpIcon = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
            MCScaler.scale(_helpIcon, 20, 20);
            _helpIcon.x = 74;
            _helpIcon.y = 14;
            source.addChild(_helpIcon);
        }
    }

    private function visitPerson():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_person == g.user) {
            if (g.partyPanel) g.partyPanel.visiblePartyPanel(true);
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.uncasheWindow();
            g.townArea.backHome();
        } else {
            if (g.partyPanel) g.partyPanel.visiblePartyPanel(false);
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.uncasheWindow();
            g.townArea.goAway(_person);
        }
    }

    public function get person():Someone { return _person; }
    private function onHover():void { _imRamka.filter = ManagerFilters.BUILD_STROKE; }
    private function onOut():void { _imRamka.filter = null; }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        if (!_person) return;
        if (!_person.name) _person = g.user.getSomeoneBySocialId(_person.userSocialId);
        if (!_person.name) return;
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        _txtName.text = _person.name;
        if (_person.photo =='' || _person.photo == 'unknown' || _person.photo == 'https://vk.com/images/camera_100.png') {
            onLoadPhoto(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        } else g.load.loadImage(_person.photo, onLoadPhoto);
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            bitmap = g.pBitmaps[person.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('MarketFriendItem:: no photo for userId: ' + _person.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        _ava = new Image(tex);
        MCScaler.scale(_ava, 85, 85);
        _ava.x = 12;
        _ava.y = 12;
        if (source) source.addChildAt(_ava,0);
        if (visitBtn && source.contains(visitBtn)) source.setChildIndex(visitBtn, source.numChildren-1);
        if (_helpIcon && source.contains(_helpIcon)) source.setChildIndex(_helpIcon, source.numChildren-1);
    }

    private function chooseThis():void {
        if (g.tuts.isTuts) return;
        if (_wo.curUser == _person) return;
        if (_person == g.user && _person.level < 5) return;
        if (!_wo) return;
        _wo.onChooseFriendOnPanel(_person, _shiftFriend);
    }

    public function deleteIt():void {
        _wo = null;
        _ava = null;
        if (_txtName) {
            source.removeChild(_txtName);
            _txtName.deleteIt();
            _txtName = null;
        }
        if (_imRamka) {
            source.removeChild(_imRamka);
            _imRamka.dispose();
            _imRamka = null;
        }
        if (_txtBtn) {
            visitBtn.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        _person = null;
        if (visitBtn) {
            visitBtn.deleteIt();
            visitBtn = null;
        }
        source.filter = null;
        if (source) source.dispose();
        source = null;
    }
}
}