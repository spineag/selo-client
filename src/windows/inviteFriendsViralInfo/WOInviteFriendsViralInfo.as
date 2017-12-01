/**
 * Created by andy on 5/26/17.
 */
package windows.inviteFriendsViralInfo {
import com.junkbyte.console.Cc;

import manager.ManagerFilters;
import manager.ManagerLanguage;

import social.SocialNetworkEvent;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.TimeUtils;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOInviteFriendsViralInfo extends WindowMain {
    private var _woBG:WindowBackgroundNew;
    private var _txt:CTextField;
    private var _txt2:CTextField;
    private var _txtCount:CTextField;
    private var _txtName:CTextField;
    private var _imMain:Image;
    private var _callback:Function;
    private var _btn:CButton;
    private var _countFriends:int;
    private var _countRubies:int;
    private var _imRub:Image;
    private var _contTimerEnd:Sprite;
    private var _txtTimerEnd:CTextField;

    public function WOInviteFriendsViralInfo() {
        super();
        _windowType = WindowsManager.WO_INVITE_FRIENDS_VIRAL_INFO;
        _woWidth = 656;
        _woHeight = 510;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,115);
        _source.addChild(_woBG);

        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        _imMain = new Image(g.allData.atlas['inviteAtlas'].getTexture('ava_rubin'));
        _imMain.alignPivot();
        _imMain.y = 5;
        _source.addChild(_imMain);
        _txtName  = new CTextField(500,70,String(g.managerLanguage.allTexts[427]));
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtName.x = -260;
        _txtName.y = -230;
        _source.addChild(_txtName);
        _btn = new CButton();
        _btn.addButtonTexture(130, CButton.HEIGHT_55, CButton.GREEN, true);
        _btn.addTextField(130, 54, 0, 0, String(g.managerLanguage.allTexts[427]));
        _btn.setTextFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btn);


        _btn.clickCallback = letInvite;
        _btn.y = 215;
        var txt:CTextField;
        _countFriends = g.managerInviteFriend.getCountFriends();
        _countRubies = g.managerInviteFriend.getCountRubies();
        var st:String = g.managerLanguage.allTexts[1062];
        st = st.replace('count', String(_countFriends));
        _txt = new CTextField(300,30,st);
        _txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
        _txt.x = -150;
        _txt.y = 95;
        _source.addChild(_txt);

        st = g.managerLanguage.allTexts[1063];
        st = st.replace('count_ruby', String(_countRubies) + '    ');
        _txt2 = new CTextField(400,30,st);
        _txt2.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
        _txt2.x = -200;
        _txt2.y = 130;
        _source.addChild(_txt2);

        _txtCount = new CTextField(90,70,String('+') + String(_countFriends*_countRubies));
        _txtCount.setFormat(CTextField.BOLD72, 45, Color.WHITE, ManagerFilters.RED_COLOR);
        _txtCount.x = 88;
        _txtCount.y = -85;
        _source.addChild(_txtCount);

        _imRub = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        _imRub.alignPivot();
        if (g.user.language == ManagerLanguage.RUSSIAN) _imRub.x = -12;
            else _imRub.x = -80;
        _imRub.y = 145;
        _source.addChild(_imRub);

        _contTimerEnd = new Sprite();
        var im:Image = new Image(g.allData.atlas['inviteAtlas'].getTexture('valik_timer'));
        im.alignPivot();
        _contTimerEnd.addChild(im);
        txt = new CTextField(120, 60, String(g.managerLanguage.allTexts[357]));
        txt.setFormat(CTextField.BOLD18, 16, 0xff7575);
        txt.x = -61;
        if (g.user.language == ManagerLanguage.ENGLISH) txt.y = -44;
        else txt.y = -47;
        _contTimerEnd.addChild(txt);
        _txtTimerEnd = new  CTextField(120, 60, '');
        _txtTimerEnd.setFormat(CTextField.BOLD24, 24, 0xd30102);
        _txtTimerEnd.x = -64;
        if (g.user.language == ManagerLanguage.ENGLISH) _txtTimerEnd.y = -18;
        else _txtTimerEnd.y = -12;
        _contTimerEnd.addChild(_txtTimerEnd);
        _contTimerEnd.x = -280;
        _contTimerEnd.y = -65;
        _source.addChild(_contTimerEnd);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _callback = callback;
        super.showIt();
        g.gameDispatcher.addToTimer(onTimer);
    }

    private function onTimer():void { _txtTimerEnd.text = TimeUtils.convertSecondsToStringClassic(g.managerInviteFriend.timerEnd); }

    private function letInvite():void {
        g.gameDispatcher.removeFromTimer(onTimer);
        _contTimerEnd.visible = false;
        g.socialNetwork.addEventListener(SocialNetworkEvent.ON_VIRAL_INVITE, onViralInvite);
        g.socialNetwork.showViralInviteWindow();
    }
    
    private function onViralInvite(e:SocialNetworkEvent):void {
        Cc.info('onViralInvite: ' + e.params.ar.toString());
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ON_VIRAL_INVITE, onViralInvite);
        if (_callback != null) {
            _callback.apply(null, [e.params.ar]);
            _callback = null;
        }
        hideIt();
    }

    private function onClickExit():void {
        if (_callback != null) {
            _callback.apply(null, [[]]);
            _callback = null;
        }
        hideIt();
    }

    override protected function deleteIt():void {
        g.gameDispatcher.removeFromTimer(onTimer);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ON_VIRAL_INVITE, onViralInvite);
        if (_txt) {
            _source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        if (_txt2) {
            _source.removeChild(_txt2);
            _txt2.deleteIt();
            _txt2 = null;
        }
        if (_txtCount) {
            _source.removeChild(_txtCount);
            _txtCount.deleteIt();
            _txtCount = null;
        }
        if (_btn) {
            _source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        if (_woBG) {
            _source.removeChild(_woBG);
            _woBG.deleteIt();
            _woBG = null;
        }
        super.deleteIt();
    }
}
}
