/**
 * Created by user on 12/15/16.
 */
package windows.buyerNyashuk {
import additional.buyerNyashuk.BuyerNyashuk;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import manager.ManagerFilters;
import quest.ManagerQuest;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;
import tutorial.TutsAction;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyerNyashuk extends WindowMain{

    private var _woBG:WindowBackgroundNew;
    private var _data:Object;
    private var _nyashuk:BuyerNyashuk;
    private var _arrCTex:Array;

    public function WOBuyerNyashuk() {
        _windowType = WindowsManager.WO_BUYER_NYASHUK;
        _woWidth = 650;
        _woHeight = 400;
        _arrCTex = [];
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,115);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        var btn:CButton;
        btn = new CButton();
        btn.addButtonTexture(150, CButton.HEIGHT_55, CButton.GREEN, true);
        btn.addTextField(150, 45, 0, 0, String(g.managerLanguage.allTexts[1292]));
        btn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR);
        btn.x = 180;
        btn.y = _woHeight / 2 - 40;
        btn.clickCallback = onClickBuy;
        _source.addChild(btn);
        _arrCTex.push(btn);

        btn = new CButton();
        btn.addButtonTexture(150, CButton.HEIGHT_55, CButton.GREEN, true);
        btn.addTextField(150, 45, 0, 0, String(g.managerLanguage.allTexts[1290]));
        btn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR);
        btn.y = _woHeight / 2 - 40;
        btn.clickCallback = onClickExit;
        _source.addChild(btn);
        _arrCTex.push(btn);

        btn = new CButton();
        btn.addButtonTexture(150, CButton.HEIGHT_55, CButton.RED, true);
        btn.addTextField(150, 45, 0, 0, String(g.managerLanguage.allTexts[1291]));
        btn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.RED_COLOR);
        btn.clickCallback = onClickDelete;
        btn.x = - 180;
        btn.y = _woHeight / 2 - 40;
        _source.addChild(btn);
        _arrCTex.push(btn);

        var txt:CTextField;
        txt =  new CTextField(_woWidth,_woHeight,String(g.managerLanguage.allTexts[450]));
        txt.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        txt.x = -_woWidth/2;
        txt.y = -_woHeight+50;
        _source.addChild(txt);
        _arrCTex.push(txt);
    }

    private function onClickExit(e:Event=null):void {
        super.hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        var im:Image;
        switch (params[0]) {
            case 1:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('nyash_blue'));
                im.x = 110;
                im.y = -45;
                _source.addChild(im);
                break;
            case 2:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('nyash_red'));
                im.x = 110;
                im.y = -45;
                _source.addChild(im);
                break;
        }
        _data = params[1];
        _nyashuk = params[2];
        fillItBot(_data);
        super.showIt();
    }

    public function fillItBot(ob:Object):void {
        if (!_data) {
            Cc.error('WOPapperItem fillItBot:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woPapperItem');
            return;
        }
        var dataResource:Object;
        var txt:CTextField =  new CTextField(350,50,String(g.managerLanguage.allTexts[451]) + ' '+ String(g.managerLanguage.allTexts[452]));
        txt.setFormat(CTextField.BOLD24, 24,ManagerFilters.BLUE_LIGHT_NEW);
        txt.x = -165;
        if (txt.textBounds.height > 40) txt.y = -80;
        else txt.y = -90;
        _source.addChild(txt);
        _arrCTex.push(txt);
        dataResource = g.allData.getResourceById(_data.resourceId);
        var im:Image;
        if (dataResource.buildType == BuildType.PLANT) im = new Image(g.allData.atlas['resourceAtlas'].getTexture(dataResource.imageShop + '_icon'));
            else im = new Image(g.allData.atlas[dataResource.url].getTexture(dataResource.imageShop));
        if (!im) {
            Cc.error('WOPapperItem fillItBot:: no such image: ' + dataResource.imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woPapperItem');
            return;
        }
        im.x = -250;
        im.y = -30;
        _source.addChild(im);

        txt = new CTextField(100,100,"/" + _data.resourceCount);
        txt.y = 35;
        txt.x = - 205;
        txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(100,100,String(g.userInventory.getCountResourceById(_data.resourceId)));
        txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        if (g.userInventory.getCountResourceById(_data.resourceId) >= _data.resourceCount) txt.changeTextColor = Color.WHITE;
        else txt.changeTextColor = ManagerFilters.ORANGE_COLOR;
        txt.x = - 310;
        txt.y = 35;
        txt.alignH = Align.RIGHT;
        _source.addChild(txt);
        _arrCTex.push(txt);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tutorial_arrow_pink'));
        MCScaler.scale(im, im.height -50, im.width -50);
        im.x = -140;
        _source.addChild(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_medium'));
        im.x = -50;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_level_icon'));
        im.x = 45;
        im.y = -5;
        _source.addChild(im);

        txt = new CTextField(100,50,_data.cost);
        txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -30;
        txt.y = -7;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(100,50,_data.xp);
        txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = 55;
        txt.y = -7;
        _source.addChild(txt);
        _arrCTex.push(txt);
    }

    private function onClickBuy(noResource:Boolean = false):void {
        var ob:Object = {};
        if (g.userInventory.getCountResourceById(_data.resourceId) < _data.resourceCount) {
            if (!g.tuts.isTuts) {
                ob.data = g.allData.getResourceById(_data.resourceId);
                ob.count = _data.resourceCount - g.userInventory.getCountResourceById(_data.resourceId);
                ob.dataNyashuk = _data;
                super.hideIt();
                g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClickBuy, 'nyashuk', ob, _nyashuk);
            } else super.hideIt();
            return;
        }
        if (!noResource && g.allData.getResourceById(_data.resourceId).buildType == BuildType.PLANT && g.userInventory.getCountResourceById(_data.resourceId) == _data.resourceCount && !g.userInventory.checkLastResource(_data.resourceId)) {
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, onClickBuy, _data, 'nyashuk', _nyashuk);
            return;
        }
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        var d:DropObject = new DropObject();
        d.addDropMoney(DataMoney.SOFT_CURRENCY, _data.cost, p);
        d.addDropXP(5, p);
        d.releaseIt();
        
        _data.visible = false;
        g.userInventory.addResource(_data.resourceId,-_data.resourceCount);
        g.server.updateUserPapperBuy(_data.buyerId,0,0,0,0,0,0);
        if (_data.buyerId == 1) {
            if (g.user.level >= 14) g.userTimer.buyerNyashukBlue(600);
            else g.userTimer.buyerNyashukBlue(g.managerOrder.delayBeforeNextOrder);
        }
        else {
            if (g.user.level >= 14) g.userTimer.buyerNyashukRed(600);
            else g.userTimer.buyerNyashukRed(g.managerOrder.delayBeforeNextOrder);
        }
        g.managerBuyerNyashuk.onReleaseOrder(_nyashuk,false);
        g.managerQuest.onActionForTaskType(ManagerQuest.NIASH_BUYER);
        g.managerAchievement.addAll(1,1);
        super.hideIt();
    }

    private function onClickDelete():void {
        g.managerBuyerNyashuk.onReleaseOrder(_nyashuk,false);
        if (_data.buyerId == 1) {
            if (g.user.level >= 14) g.userTimer.buyerNyashukBlue(600);
            else g.userTimer.buyerNyashukBlue(g.managerOrder.delayBeforeNextOrder);
        }
        else {
            if (g.user.level >= 14) g.userTimer.buyerNyashukRed(600);
            else g.userTimer.buyerNyashukRed(g.managerOrder.delayBeforeNextOrder);
        }
        _data.timeToNext = TimeUtils.currentSeconds;
        g.server.updateUserPapperBuy(_data.buyerId,0,0,0,0,0,0);
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (g.tuts.isTuts && g.tuts.action == TutsAction.NYASHIK) g.tuts.checkTutsCallback();
        _data = null;
        _nyashuk = null;
        for (var i:int = 0; i <_arrCTex.length; i++) {
            if (_arrCTex[i])_arrCTex[i].deleteIt();
            _arrCTex[i] = null;
        }
        super.deleteIt();
    }
}
}
