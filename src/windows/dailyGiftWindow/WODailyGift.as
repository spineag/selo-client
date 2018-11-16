/**
 * Created by user on 11/30/16.
 */
package windows.dailyGiftWindow {
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import manager.ManagerFilters;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Color;
import temp.DropResourceVariaty;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.BackgroundWhiteIn;
import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WODailyGift extends WindowMain {
    private var _woBG:WindowBackgroundNew;
    private var _cont:Sprite;
    private var _btnGet:CButton;
    private var _arrayItem:Array;
    private var _sprItem:Sprite;
    private var _itemToday:Object;
    private var _point:Point;
    private var _arrCTex:Array;

    public function WODailyGift() {
        super();
        _windowType = WindowsManager.WO_DAILY_GIFT;
        _woHeight = 400;
        _woWidth = 765;
        _sprItem = new Sprite();
        _arrCTex = [];

        _woBG = new WindowBackgroundNew(_woWidth, _woHeight, 70);
        _source.addChild(_woBG);
        _cont = new Sprite();
        _source.addChild(_cont);
        var c:BackgroundYellowOut = new BackgroundYellowOut(735, 315);
        c.x = -_woWidth/2 + 15;
        c.y = -_woHeight/2+70;
        _cont.addChild(c);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _btnGet = new CButton();
        _btnGet.addButtonTexture(160, CButton.HEIGHT_41, CButton.GREEN, true);
        _btnGet.addTextField(160, 40, -5, -5, String(g.managerLanguage.allTexts[437]));
        _btnGet.setTextFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btnGet);
        _btnGet.y = 200;
        _btnGet.clickCallback = onClickExit;
        var _txt:CTextField;
        _txt = new CTextField(680, 340, String(g.managerLanguage.allTexts[438]));
        _txt.setFormat(CTextField.BOLD72, 50,  ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txt.x = -350;
        _txt.y = -340;
        _source.addChild(_txt);
        _arrCTex.push(_txt);

        _txt = new CTextField(600,40, String(g.managerLanguage.allTexts[439]));
        _txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -300;
        _txt.y = -128;
        _source.addChild(_txt);
        _arrCTex.push(_txt);
        _itemToday = {};
    }

    override public function showItParams(callback:Function, params:Array):void {
        _arrayItem = [];
        _arrayItem = params[0];
        var source:Sprite;
        var day:int = 24 * 60 * 60 * 1000;
//        var yesterday:Date = new Date();
//        var yesterdayDailyGift:Date = new Date(g.user.dayDailyGift * 1000);
//        yesterday.setTime(yesterday.getTime() - day);
        g.user.countDailyGift++;
        g.user.dayDailyGift = int(new Date(g.user.day));
        if (g.user.countDailyGift > 10) {
            g.user.countDailyGift = 1;
        }
//
//        if (yesterday.date != yesterdayDailyGift.date) {
//            g.user.countDailyGift = 1;
//        }
        for (var i:int = 0; i < _arrayItem.length; i++) {
            source = new Sprite();
            source.x = (i % 5) * 135;
            source.y = int(i / 5) * 135;
            createItem(_arrayItem[i].resource_id, _arrayItem[i].type, _arrayItem[i].count, source, i);
            _sprItem.addChild(source);
        }
        _sprItem.x = -340;
        _sprItem.y = -90;
        _source.addChild(_sprItem);
        super.showIt();
    }
    override public function hideIt():void {
//        g.managerCats.helloCats();
//        if (g.managerParty.userParty && !g.managerParty.userParty.showWindow && g.managerParty.userParty.countResource >=g. managerParty.countToGift[0] && (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2))
//            g.managerParty.endPartyWindow();
//        else if (g.userTimer.partyToEndTimer > 0 && g.managerParty.eventOn && g.managerParty.levelToStart <= g.user.level && g.allData.atlas['partyAtlas']) {
//            g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
//        }
//        else if (g.userTimer.partyToEndTimer <= 0 && g.managerParty.userParty && !g.managerParty.userParty.showWindow
//                && (g.managerParty.typeParty == 3 || g.managerParty.typeParty == 4 || g.managerParty.typeParty == 5)) g.managerParty.endPartyWindow();

        super.hideIt();
    }

    private function onClickExit(e:Event = null):void {
        g.server.updateDailyGift(g.user.countDailyGift);
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        var d:DropObject = new DropObject();
        if (int(_itemToday.type) == BuildType.DECOR || int(_itemToday.type) == BuildType.DECOR_ANIMATION)
            d.addDropDecor(g.allData.getBuildingById(_itemToday.id), p, _itemToday.count, true);
        else if (_itemToday.type == DropResourceVariaty.DROP_TYPE_MONEY) 
            d.addDropMoney(_itemToday.id, _itemToday.count, p);
        else d.addDropItemNewByResourceId(_itemToday.id, p, _itemToday.count);
        d.releaseIt(null, false);
        hideIt();
    }

    override protected function deleteIt():void {
        for (var i:int = 0; i<_arrCTex.length; i++) {
            if(_arrCTex[i]) {
                _arrCTex[i].deleteIt();
                _arrCTex[i] = null;
            }
        }
        super.deleteIt();
        if (g.miniScenes.continueAfterNeighbor==3) {
            g.miniScenes.continueAfterNeighbor=-1;
            g.managerQuest.getNewQuests();
        }
    }

    private function createItem(id:int, type:String, count:int, source:Sprite, number:int):void {
        var bg:BackgroundWhiteIn = new BackgroundWhiteIn(130, 130);
        source.addChild(bg);
        var im:Image;

        if (id == 1 && type == '1') {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            MCScaler.scale(im,im.height-20,im.width-20);
            im.x = bg.width/2 ;
            im.y = bg.width/2;
            id = DataMoney.HARD_CURRENCY;
            type = DropResourceVariaty.DROP_TYPE_MONEY;
        } else if (id == 2 && type == '2') {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
            MCScaler.scale(im,im.height-20,im.width-20);
            im.x = bg.width/2 ;
            im.y = bg.width/2;
            id = DataMoney.SOFT_CURRENCY;
            type = DropResourceVariaty.DROP_TYPE_MONEY;
        } else if (int(type) == BuildType.INSTRUMENT) {
            im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(id).imageShop));
            MCScaler.scale(im,im.height-10,im.width-10);
            im.x = bg.width/2;
            im.y = bg.width/2;
            type = DropResourceVariaty.DROP_TYPE_RESOURSE;
        } else if (int(type) == BuildType.DECOR) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).image+ '_icon'));
            MCScaler.scale(im,im.height-60,im.width-60);
            im.x = bg.width/2 - 20;
            im.y = bg.width/2 - 20;
        } else if (int(type) == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).url+ '_icon'));
            MCScaler.scale(im,im.height-60,im.width-60);
            im.x = bg.width/2 - 20;
            im.y = bg.width/2 - 20;
        }
        im.alignPivot();
        source.addChild(im);
        var txt:CTextField = new CTextField(130,40, String(g.managerLanguage.allTexts[440]) + " " + (number+1));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.y = -5;
        source.addChild(txt);
        _arrCTex.push(txt);
        txt = new CTextField(130,30, String(count));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.y = 95;
        source.addChild(txt);
        _arrCTex.push(txt);
        if (number < g.user.countDailyGift-1) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
//            MCScaler.scale(im,im.height-20,im.width-20);
            im.x = 5;
            im.y = 15;
            source.addChild(im);
            source.alpha = .5;
        }

        if (number == g.user.countDailyGift-1) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
//            MCScaler.scale(im,im.height-20,im.width-20);
            im.x = 5;
            im.y = 15;
            source.addChild(im);
            _itemToday.id = id;
            _itemToday.type = type;
            _itemToday.count = count;
            _point = new Point(source.x, source.y);
            _point = source.localToGlobal(_point);
        }
    }

}
}
