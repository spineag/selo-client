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
    private var g:Vars = Vars.getInstance();

    public function MarketFriendItem(f:Someone, wo:WOMarket, _shift:int) {
        _shiftFriend = _shift;
        source = new CSprite();
        source.x = 218;
        var bg:Quad = new Quad(100, 102, Color.WHITE);
        bg.x = 4;
        bg.y = .5;
        source.addChild(bg);
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
                _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                MCScaler.scale(_ava, 98, 98);
                _ava.x = 4;
                _ava.y = 2;
                source.addChild(_ava);
                g.load.loadImage(_person.photo, onLoadPhoto);
            } else {
                g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                g.socialNetwork.getTempUsersInfoById([_person.userSocialId]);
            }
        }
        _txtName = new CTextField(100, 30, 'loading...');
        _txtName.needCheckForASCIIChars = true;
        _txtName.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtName.y = 70;
        if (_person.name) _txtName.text = _person.name;
        source.addChild(_txtName);
        source.endClickCallback = chooseThis;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        visitBtn = new CButton();
        visitBtn.addButtonTexture(80, 30, CButton.BLUE, true);
        _txtBtn = new CTextField(76, 25, String(g.managerLanguage.allTexts[386]));
        _txtBtn.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtBtn.x = 2;
        _txtBtn.y = 3;
        visitBtn.addChild(_txtBtn);
        visitBtn.x = 55;
        visitBtn.y = 3;
        source.addChild(visitBtn);
        visitBtn.clickCallback = visitPerson;
        visitBtn.visible = false;

        if (_person.needHelpCount > 0) {
            _helpIcon = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
            MCScaler.scale(_helpIcon, 20, 20);
            _helpIcon.x = 85;
            _helpIcon.y = 80;
            source.addChild(_helpIcon);
        }
    }

    private function visitPerson():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_person == g.user) {
            g.catPanel.visibleCatPanel(true);
            if (g.partyPanel) g.partyPanel.visiblePartyPanel(true);
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.uncasheWindow();
            g.townArea.backHome();
        } else {
            g.catPanel.visibleCatPanel(false);
            if (g.partyPanel) g.partyPanel.visiblePartyPanel(false);
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.uncasheWindow();
            g.townArea.goAway(_person);
        }
    }

    public function get person():Someone { return _person; }
    private function onHover():void { source.filter = ManagerFilters.BUILD_STROKE; }
    private function onOut():void { source.filter = null; }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        if (!_person.name) _person = g.user.getSomeoneBySocialId(_person.userSocialId);
//        _person.name = ar[0].first_name;
//        _person.lastName = ar[0].last_name;
//        _person.photo = ar[0].photo_100;
        _txtName.text = _person.name;
        if (_person.photo =='' || _person.photo == 'unknown') _person.photo =  SocialNetwork.getDefaultAvatar();
        g.load.loadImage(_person.photo, onLoadPhoto);
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
        MCScaler.scale(_ava, 98, 98);
        _ava.x = 4;
        _ava.y = 2;
        if (source) source.addChild(_ava);
        if (visitBtn && source.contains(visitBtn)) source.setChildIndex(visitBtn, source.numChildren-1);
        if (_helpIcon && source.contains(_helpIcon)) source.setChildIndex(_helpIcon, source.numChildren-1);
    }

    private function chooseThis():void {
        if (g.managerTutorial.isTutorial) return;
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