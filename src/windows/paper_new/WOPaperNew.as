/**
 * Created by andy on 9/21/17.
 */
package windows.paper_new {
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import data.DataMoney;
import manager.ManagerFilters;
import social.SocialNetworkEvent;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import user.Someone;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOPaperNew extends WindowMain {
    private var _txtWindowName:CTextField;
    private var _mask:Sprite;
    private var _cont:Sprite;
    private var _arrPaper:Array;
    private var _arrItems:Array;
    private var _btnRefresh:CButton;
    private var _btnRefreshFree:CButton;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _txtPage:CTextField;
    private var _txtTimer:CTextField;
    private var _maxPage:int;
    private var _curPage:int;
    private var _isAnim:Boolean;
    private var _ims:Sprite;

    public function WOPaperNew() {
        super();
        _arrItems = [];
        _isAnim = false;
        _windowType = WindowsManager.WO_PAPER_NEW;
        _woWidth = 880;
        _woHeight = 646;
        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 98);
        _source.addChild(_woBGNew);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        _txtWindowName = new CTextField(300, 50, g.managerLanguage.allTexts[161]);
        _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtWindowName.x = -150;
        _txtWindowName.y = -_woHeight/2 + 25;
        _source.addChild(_txtWindowName);

        _txtPage = new CTextField(70, 30, '');
        _txtPage.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txtPage.x = -_woWidth/2 + 94;
        _txtPage.y = -_woHeight/2 + 589;
        _source.addChild(_txtPage);

        _ims = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_offers_b'));
        im.x = -_woWidth/2 + 220;
        im.y = -_woHeight/2 + 576;
        _ims.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_timer_s'));
        im.x = -_woWidth/2 + 387;
        im.y = -_woHeight/2 + 584;
        _ims.addChild(im);
        _source.addChild(_ims);
        _txtTimer = new CTextField(85, 30, '');
        _txtTimer.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txtTimer.x = -_woWidth/2 + 395;
        _txtTimer.y = -_woHeight/2 + 588;
        _ims.addChild(_txtTimer);
        _btnRefresh = new CButton();
        _btnRefresh.addButtonTexture(160, CButton.MEDIUM_HEIGHT, CButton.GREEN, true);
        _btnRefresh.addTextField(120, 37, 2, 0, g.managerLanguage.allTexts[359] + ' 1');
        _btnRefresh.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        MCScaler.scale(im, 30, 30);
        im.alignPivot();
        im.x = 140;
        im.y = 20;
        _btnRefresh.addDisplayObject(im);
        _btnRefresh.x = -_woWidth/2 + 595;
        _btnRefresh.y = -_woHeight/2 + 604;
        _source.addChild(_btnRefresh);
        _btnRefresh.clickCallback = refreshIt;
        _btnRefreshFree = new CButton();
        _btnRefreshFree.addButtonTexture(140, CButton.MEDIUM_HEIGHT, CButton.GREEN, true);
        _btnRefreshFree.addTextField(140, 37, 0, 0, g.managerLanguage.allTexts[359]);
        _btnRefreshFree.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btnRefreshFree.x = -_woWidth/2 + 585;
        _btnRefreshFree.y = -_woHeight/2 + 604;
        _source.addChild(_btnRefreshFree);
        _btnRefreshFree.clickCallback = refreshItFree;

        _mask = new Sprite();
        _mask.mask = new Quad(740, 460);
        _mask.x = -_woWidth/2 + 75;
        _mask.y = -_woHeight/2 + 107;
        _source.addChild(_mask);
        _cont = new Sprite();
        _mask.addChild(_cont);

        createArrows();
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (g.userTimer.timerAtPapper <= 0) {
            g.directServer.updateUserTimePaper(null);
            startPapperTimer();
            g.directServer.getPaperItems(fillAfterRefresh);
            g.user.paperShift = 1;
            _btnRefreshFree.visible = false;
            _btnRefresh.visible = true;
            _ims.visible = true;
            _txtTimer.text = '';
        } else {
            _btnRefreshFree.visible = true;
            _btnRefresh.visible = false;
            _ims.visible = false;
            fillAfterRefresh();
        }
        super.showIt();
    }

    private function createArrows():void {
        _leftArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.alignPivot();
        _leftArrow.addChild(im);
        _leftArrow.clickCallback = onClickLeft;
        _leftArrow.x = -_woWidth/2 + 33;
        _leftArrow.y = -_woHeight/2 + 380;
        _source.addChild(_leftArrow);

        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX = -1;
        im.alignPivot();
        _rightArrow.addChild(im);
        _rightArrow.clickCallback = onClickRight;
        _rightArrow.x = _woWidth/2 - 33;
        _rightArrow.y = -_woHeight/2 + 380;
        _source.addChild(_rightArrow);
    }

    private function onClickLeft():void {
        if (_curPage <= 0) return;
        if (_isAnim) return;
        _curPage--;
        _isAnim = true;
        TweenMax.to(_cont, .3, {x: -(_curPage-1)*3*252, onComplete: function():void { _isAnim = false; checkArrows()} });
    }

    private function onClickRight():void {
        if (_curPage >= _maxPage) return;
        if (_isAnim) return;
        _curPage++;
        _isAnim = true;
        TweenMax.to(_cont, .3, {x: -(_curPage-1)*3*252, onComplete: function():void { _isAnim = false; checkArrows()} });
    }

    private function checkArrows():void {
        _leftArrow.visible = _curPage > 1;
        _rightArrow.visible = _curPage < _maxPage;
        _txtPage.text = String(_curPage) + '/' + String(_maxPage);
    }

    public function startPapperTimer():void {
        g.userTimer.startUserPapperTimer(300);
        checkPapperTimer();
    }

    private function checkPapperTimer():void {
        if (g.userTimer.timerAtPapper >= 0) {
            _txtTimer.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.timerAtPapper);
            g.userTimer.startUserPapperTimer(g.userTimer.timerAtPapper);
            g.gameDispatcher.addToTimer(onTimer);
            _btnRefresh.visible = true;
            _btnRefreshFree.visible = false;
            _ims.visible = true;
        } else {
            _txtTimer.text = '';
            g.gameDispatcher.removeFromTimer(onTimer);
            _btnRefresh.visible = false;
            _ims.visible = false;
            _btnRefreshFree.visible = true;
        }
    }

    private function onTimer():void {
        if (g.userTimer.timerAtPapper > 0) {
            if (_txtTimer)_txtTimer.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.timerAtPapper);
        } else {
            if (_txtTimer) _txtTimer.text = '';
            g.gameDispatcher.removeFromTimer(onTimer);
            g.directServer.updateUserTimePaper(null);
            g.user.paperShift = 1;
            _btnRefresh.visible = false;
            _ims.visible = false;
            _btnRefreshFree.visible = true;
        }
    }

    private function fillAfterRefresh():void {
        _arrPaper = g.managerPaper.arr.slice();
        _maxPage = int(_arrPaper.length/6);
        if (_arrPaper.length%6) _maxPage++;
        _curPage = 1;
        _cont.x = 0;
        clearItems();
        fillItems();
        checkArrows();
        checkSocialInfoForArray();
    }

    private function refreshIt():void {
        if (g.user.hardCurrency < 1){
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -1);
        refreshItFree();
    }

    private function refreshItFree():void {
        g.directServer.updateUserTimePaper(null);
        startPapperTimer();
        g.directServer.getPaperItems(fillAfterRefresh);
    }

    private function checkSocialInfoForArray():void {
        var userIds:Array = [];
        var p:Someone;

        Cc.ch('social', 'WOPapper: ar.length: ' + _arrPaper.length);
        for (var i:int=0; i<_arrPaper.length; i++) {
            p = g.user.getSomeoneBySocialId(_arrPaper[i].userSocialId);
            if (!p.photo && userIds.indexOf(_arrPaper[i].userSocialId) == -1) userIds.push(_arrPaper[i].userSocialId);
        }
        Cc.ch('social', 'WOPapper: userIds.length: ' + userIds.length);
        if (userIds.length) {
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingInfo);
            g.socialNetwork.getTempUsersInfoById(userIds);
        }
    }

    private function onGettingInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingInfo);
        Cc.info('WOPapper:: for update avatar');
        for (var i:int=0; i<_arrItems.length; i++) {
            (_arrItems[i] as WOPaperNewItem).updatePersonInfo();
        }
    }

    private function clearItems():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _cont.removeChild(_arrItems[i].source);
            (_arrItems[i] as WOPaperNewItem).deleteIt();
        }
        _arrItems.length = 0;
    }

    private function fillItems():void {
        var it:WOPaperNewItem;
        for (var i:int=0; i<_arrPaper.length; i++) {
            it = new WOPaperNewItem(_arrPaper[i], this);
            it.source.x = int(i/2)*252;
            it.source.y = int(i%2)*237;
            _cont.addChild(it.source);
            _arrItems.push(it);
        }
    }

    private function onClickExit():void {

        super.hideIt();
    }

    override protected function deleteIt():void {
        if (!_source) return;
        clearItems();
        _source.removeChild(_txtWindowName);
        _txtWindowName.deleteIt();
        _source.removeChild(_btnRefresh);
        _btnRefresh.deleteIt();
        _source.removeChild(_btnRefreshFree);
        _btnRefreshFree.deleteIt();
        _source.removeChild(_leftArrow);
        _leftArrow.deleteIt();
        _source.removeChild(_rightArrow);
        _rightArrow.deleteIt();
        _ims.removeChild(_txtTimer);
        _txtTimer.deleteIt();
        _source.removeChild(_txtPage);
        _txtPage.deleteIt();
        super.deleteIt();
    }
}
}
