/**
 * Created by user on 2/10/17.
 */
package windows.partyWindow {
import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;
import flash.display.Bitmap;
import flash.geom.Point;
import manager.ManagerFilters;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import starling.utils.Padding;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.BackgroundYellowOut;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOPartyWindowClose extends WindowMain{
    private var _woBG:WindowBackgroundNew;
    private var _txtName:CTextField;
    private var _txtDescription:CTextField;
    private var _ava:Image;
    private var _ramka:Image;
    private var _countLoad:CTextField;
    private var _countRating:CTextField;
    private var _txtRating:CTextField;
    private var _youWind:CTextField;
    private var _arrItem:Array;
    private var _srcItem:Sprite;
    private var _bgYellow:BackgroundYellowOut;
    private var _userParty:Object;
    private var _dataParty:Object;
    private var _btnOk:CButton;

    public function WOPartyWindowClose() {
        _windowType = WindowsManager.WO_PARTY_CLOSE;
        _woHeight = 500;
        _woWidth = 550;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBG);
        _srcItem = new Sprite();
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _dataParty = g.managerParty.obEndEvent;
        _txtName = new CTextField(450, 70, String(g.managerLanguage.allTexts[_dataParty.nameMain]));
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txtName.x = -230;
        _txtName.y = -218;
        _source.addChild(_txtName);
        var myPattern:RegExp = /count/;
        var str:String =  String(g.managerLanguage.allTexts[1320]);
        _txtDescription = new CTextField(520, 120, String(g.managerLanguage.allTexts[289]));
        _txtDescription.text = String(str.replace(myPattern, '"' + String(g.managerLanguage.allTexts[_dataParty.nameMain]) + '"'));
        _txtDescription.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtDescription.x = -262;
        _txtDescription.y = -140;
        _source.addChild(_txtDescription);

        _youWind = new CTextField(450, 70, String(g.managerLanguage.allTexts[1322]));
        _youWind.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _youWind.alignH = Align.LEFT;
        _youWind.y = 160;
        _source.addChild(_youWind);
        _arrItem = [];
        _source.addChild(_srcItem);

        _bgYellow = new BackgroundYellowOut(520,130);
        _bgYellow.x = -_bgYellow.width/2 + 5;
        _bgYellow.y = -15;
        _source.addChild(_bgYellow);

        _txtRating = new CTextField(520, 120, String(g.managerLanguage.allTexts[1321]));
        _txtRating.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtRating.x = -262;
        _txtRating.y = -40;
        _source.addChild(_txtRating);

        _countRating = new CTextField(450, 90, '');
        _countRating.setFormat(CTextField.BOLD72, 46, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _countRating.alignH = Align.LEFT;
        _countRating.x = -_countRating.textBounds.width/2;
        _countRating.y = 35;
        _source.addChild(_countRating);

        _btnOk = new CButton();
        _btnOk.addButtonTexture(100, CButton.HEIGHT_55, CButton.BLUE, true);
        _btnOk.addTextField(100, 40, 0, 0, String(g.managerLanguage.allTexts[328]));
        _btnOk.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _btnOk.y = 185;
        _source.addChild(_btnOk);
        _btnOk.clickCallback = hideIt;
        _btnOk.visible = false;
    }

    override public function showItParams(callback:Function, params:Array):void {
        g.server.getRatingParty(int(g.managerParty.obEndEvent.id),false, whenLoadShow);
    }

    private function whenLoadShow ():void {
        var party:PartyItem;
        for (var i:int = 0; i < g.managerParty.userParty.length; i++) {
            if (g.managerParty.userParty[i].idParty == _dataParty.id) {
                _userParty = g.managerParty.userParty[i];
                break;
            }
        }
        for (i= 0; i < _dataParty.countToGift.length; i++) {
            if (_userParty.countResource >= _dataParty.countToGift[i]) {
                party = new PartyItem(_dataParty.idGift[i], _dataParty.typeGift[i]);
                party.source.x = i*55 + 5;
                party.source.y = 165;
                _arrItem.push(party);
                _srcItem.addChild(party.source);
            }
        }
        if (g.managerParty.getratingForEnd <= 3) {
            party = new PartyItem(_dataParty.idDecorBest, _dataParty.typeDecorBest);
            party.source.x = _arrItem.length*55 + 5;
            party.source.y = 165;
            _srcItem.addChild(party.source);
        } else if (_arrItem.length <= 0) {
            _youWind.visible = false;
            _btnOk.visible = true;
        }
        _countRating.text = String(g.managerParty.getratingForEnd);
        _countRating.x = -_countRating.textBounds.width/2;
        _youWind.x = ((_woWidth - (_youWind.textBounds.width + _srcItem.width)) - _woWidth)/2;
        _srcItem.x = _youWind.x + _youWind.textBounds.width;
        super.showIt();
    }

    override public function hideIt():void {
        g.managerParty.addEndForShowWindow();
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        var d:DropObject = new DropObject();
        for (var i:int = 0; i < _userParty.tookGift.length; i++) {
            if (!_userParty.tookGift[i] && _userParty.countResource >= _dataParty.countToGift[i]) {
                if (_dataParty.typeGift[i] == BuildType.DECOR_ANIMATION || _dataParty.typeGift[i] == BuildType.DECOR)
                    d.addDropDecor(g.allData.getBuildingById(_dataParty.idGift[i]), p, _dataParty.countGift[i], true);
                else {
                    if (_dataParty.idGift[i] == 1 && _dataParty.typeGift[i] == 1)
                        d.addDropMoney(DataMoney.SOFT_CURRENCY, _dataParty.countGift[i], p);
                    else if (_dataParty.idGift[i] == 2 && _dataParty.typeGift[i] == 2)
                        d.addDropMoney(DataMoney.HARD_CURRENCY, _dataParty.countGift[i], p);
                    else d.addDropItemNewByResourceId(_dataParty.idGift[i], p, _dataParty.countGift[i]);
                }
            }
        }
        if (g.managerParty.getratingForEnd <= 3) {
            if (_dataParty.typeDecorBest == BuildType.DECOR_ANIMATION || _dataParty.typeDecorBest == BuildType.DECOR) d.addDropDecor(g.allData.getBuildingById(_dataParty.idDecorBest), p, _dataParty.countDecorBest, true);
            else {
                if (_dataParty.idDecorBest == 1 && _dataParty.typeDecorBest == 1)
                    d.addDropMoney(DataMoney.SOFT_CURRENCY, _dataParty.countDecorBest, p);
                else if (_dataParty.idDecorBest == 2 && _dataParty.typeDecorBest == 2)
                    d.addDropMoney(DataMoney.HARD_CURRENCY, _dataParty.countDecorBest, p);
                else d.addDropItemNewByResourceId(_dataParty.idDecorBest, p, _dataParty.countDecorBest);
            }
        }
        d.releaseIt(null, false);
        super.hideIt();
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

}
}

import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import utils.MCScaler;


internal class PartyItem {
    private var g:Vars = Vars.getInstance();
    public var source:Sprite;
    private var _item:Image;

    public function PartyItem(id:int, type:int) {
        source = new Sprite();
        if (id == 1 && type  == 1) {
            _item = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
            source.addChild(_item);
        } else if (id == 2 && type == 2) {
            _item = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            source.addChild(_item);
        }  else if (type == BuildType.RESOURCE || type == BuildType.INSTRUMENT || type == BuildType.PLANT) {
            _item = new Image(g.allData.atlas[g.allData.getResourceById(id).url].getTexture(g.allData.getResourceById(id).imageShop));
            source.addChild(_item);
        } else if (type == BuildType.DECOR_ANIMATION) {
            _item = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).url + '_icon'));
            source.addChild(_item);
        } else if (type == BuildType.DECOR || type == BuildType.DECOR_TAIL) {
            _item = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).image +'_icon'));
            source.addChild(_item);
        }
        MCScaler.scale(_item, 55,55);
    }

}