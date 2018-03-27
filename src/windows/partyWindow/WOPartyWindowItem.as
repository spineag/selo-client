/**
 * Created by user on 2/2/17.
 */
package windows.partyWindow {
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.display.Quad;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.BackgroundQuestDone;

public class WOPartyWindowItem {
    public var source:CSprite;
    private var _bg:BackgroundQuestDone;
    private var _sprItem:CSprite;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtCountResource:CTextField;
    private var _txtCountToGift:CTextField;
    private var _txtCountUser:CTextField;
    private var g:Vars = Vars.getInstance();
    private var _data:Object;
    private var _imCheck:Image;
    private var _bgWhite:Image;

    public function WOPartyWindowItem(id:int, type:int, countResource:int, countToGift:int, number:int) {
        source = new CSprite();
        _sprItem = new CSprite();
        _btn = new CButton();
        _data = {};
        _data.idResource = id;
        _data.typeResource = type;
        _data.countResource = countResource;
        _data.countToGift = countToGift;
        _data.number = number;
        _bg = new BackgroundQuestDone(700, 110);
        source.addChild(_bg);
        _txtCountResource = new CTextField(119,100,' ');
        _txtCountResource.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountResource.alignH = Align.RIGHT;
        _txtCountResource.x = 570;
        _txtCountResource.y = -35;
        _bgWhite = new Image(g.allData.atlas['partyAtlas'].getTexture('ne_window_white_cell'));
        _bgWhite.x = 5;
        _bgWhite.y = 5;
        source.addChild(_bgWhite);
        var im:Image;
        if (g.allData.getResourceById(g.managerParty.idResource).buildType == BuildType.PLANT) {
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(g.managerParty.idResource).imageShop + '_icon'));
        } else {
            im = new Image(g.allData.atlas[g.allData.getResourceById(g.managerParty.idResource).url].getTexture(g.allData.getResourceById(g.managerParty.idResource).imageShop));
        }
        im.x = 5;
        im.y = 5;
        _sprItem.addChild(im);
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('ne_window_white_cell'));
        im.x = 595;
        im.y = 5;
        _sprItem.addChild(im);
        if (id == 1 && type  == 1) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));

            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
        } else if (id == 2 && type == 2) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
        }  else if (type == BuildType.RESOURCE || type == BuildType.INSTRUMENT || type == BuildType.PLANT) {
            im = new Image(g.allData.atlas[g.allData.getResourceById(id).url].getTexture(g.allData.getResourceById(id).imageShop));
            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
            _sprItem.hoverCallback = function():void { g.hint.showIt(String(g.allData.getResourceById(id).name)); };
            _sprItem.outCallback = function():void { g.hint.hideIt(); };
        } else if (type == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).url + '_icon'));
            _sprItem.addChild(im);
            _sprItem.hoverCallback = function():void { g.hint.showIt(String(g.allData.getBuildingById(id).name)); };
            _sprItem.outCallback = function():void { g.hint.hideIt(); };
        } else if (type == BuildType.DECOR || type == BuildType.DECOR_TAIL) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).image +'_icon'));
            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
            _sprItem.hoverCallback = function():void { g.hint.showIt(String(g.allData.getBuildingById(id).name)); };
            _sprItem.outCallback = function():void { g.hint.hideIt(); };

        }
        im.x = 645;
        im.y = 45;
        im.alignPivot();
        MCScaler.scale(im, 80, 80);
        source.addChild(_sprItem);


        _btn = new CButton();
        _btn.addButtonTexture(100, CButton.HEIGHT_32, CButton.GREEN, true);
        _btn.addTextField(100, 31, 0, 0, String(g.managerLanguage.allTexts[358]));
        _btn.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
        source.addChild(_btn);

//        _btn.addButtonTexture(80, 20, CButton.GREEN, true);
//        _txtBtn = new CTextField(80,20,String(g.managerLanguage.allTexts[358]));
//        _txtBtn.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
//        _btn.addChild(_txtBtn);
        _btn.x = 645;
        _btn.y = 90;
        _btn.clickCallback = onClick;
        if (!Boolean(g.managerParty.userParty.tookGift[_data.number - 1]) && g.managerParty.userParty.countResource >= _data.countToGift)  {
            _btn.setEnabled = true;
        } else if (Boolean(g.managerParty.userParty.tookGift[_data.number - 1])) {
            _btn.setEnabled = false;
            _btn.visible = false;
            _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            _imCheck.x = 45;
            _imCheck.y = 106;
            source.addChild(_imCheck);
        } else _btn.setEnabled = false;

        source.addChild(_btn);
        source.addChild(_txtCountResource);


        _txtCountUser = new CTextField(119,100,String(g.managerParty.userParty.countResource));
        _txtCountUser.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.PURPLE_COLOR);
        _txtCountUser.alignH = Align.LEFT;
        _txtCountUser.x = 330;
        _txtCountUser.y = 35;
        source.addChild(_txtCountUser);

        _txtCountToGift = new CTextField(119,100,'/' + String(countToGift));
        _txtCountToGift.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountToGift.alignH = Align.LEFT;
        _txtCountToGift.x = _txtCountUser.x + _txtCountUser.textBounds.width-1;
        _txtCountToGift.y = 35;
        source.addChild(_txtCountToGift);


//        if (_txtCountUser) {
//            if (number == 1)        _txtCountUser.x = 22;
//            else if (number == 2)   _txtCountUser.x = 15;
//            else if (number == 3)   _txtCountUser.x = 10;
//            else if (number == 4)   _txtCountUser.x = 0;
//            else if (number == 5)   _txtCountUser.x = -6;
//        }
        var _quad:Quad;
        var width:int;
        if (number > 1) {
            width = ((g.managerParty.userParty.countResource - g.managerParty.countToGift[number-2]) / (countToGift - g.managerParty.countToGift[number-2])) * 75;
        } else width = (g.managerParty.userParty.countResource / countToGift) * 75;
        if (g.managerParty.userParty.countResource > countToGift) {
            _quad = new Quad(75, 30, 0xff3da5);
            _quad.y = 165;
            source.addChild(_quad);
        } else if (number != 1 && g.managerParty.userParty.countResource > g.managerParty.countToGift[number - 2]) {
//            width = 1;
            if (width > 0) {
                _quad = new Quad(width, 30, 0xff3da5);
                _quad.x = 20;
                _quad.y = 165;
                source.addChild(_quad);
            }
        } else if (number == 1 && g.managerParty.userParty.countResource > 0) {
            if (width > 0) {
                _quad = new Quad(width, 30, 0xff3da5);
                _quad.x = 20;
                _quad.y = 165;
                source.addChild(_quad);
            }
        }
        if (_quad) {
            if (number == 1) {
                _quad.x = 50;
            } else if (number == 2) {
                _quad.x = 45;
            } else if (number == 3) {
                _quad.x = 36;
            } else if (number == 4) {
                _quad.x = 28;
            }else if (number == 5) {
                _quad.x = 20;
            }
        }
    }

    public function reload():void {
        source.removeChild(_imCheck);
        source.removeChild(_btn);
        source.removeChild(_txtCountResource);
        source.removeChild(_txtCountToGift);
        source.removeChild(_txtCountUser);
        if (!Boolean(g.managerParty.userParty.tookGift[_data.number - 1]) && g.managerParty.userParty.countResource >= _data.countToGift)  {
            _btn.setEnabled = true;
        } else if (Boolean(g.managerParty.userParty.tookGift[_data.number - 1])) {
            _btn.setEnabled = false;
            _btn.visible = false;
            _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            _imCheck.x = 45;
            _imCheck.y = 106;
            source.addChild(_imCheck);
        } else _btn.setEnabled = false;
        source.addChild(_btn);
        source.addChild(_txtCountResource);
        _txtCountUser = new CTextField(119,100,String(g.managerParty.userParty.countResource));
        _txtCountUser.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.PURPLE_COLOR);
        _txtCountUser.alignH = Align.LEFT;
        _txtCountUser.x = 330;
        _txtCountUser.y = 35;
        source.addChild(_txtCountUser);
        _txtCountToGift = new CTextField(119,100,String(_data.countToGift));
        _txtCountToGift.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountToGift.alignH = Align.LEFT;
        _txtCountToGift.x = _txtCountUser.x + _txtCountUser.textBounds.width-1;
        _txtCountToGift.y = 35;
        source.addChild(_txtCountToGift);
        var _quad:Quad;
        var width:int;
        if (_data.number > 1) {
            width = ((100 * (g.managerParty.userParty.countResource - g.managerParty.countToGift[_data.number - 2])) / (_data.countToGift - g.managerParty.countToGift[_data.number -2])) * .75;

        } else width = (100 * g.managerParty.userParty.countResource / _data.countToGift) * .75;
        if (g.managerParty.userParty.countResource > _data.countToGift) {
            _quad = new Quad(75, 30, 0xff3da5);
            _quad.y = 165;
            source.addChild(_quad);
        }
        else if (_data.number != 1 && g.managerParty.userParty.countResource > g.managerParty.countToGift[_data.number - 2]) {
//            width = 1;
            if (width > 0) {
                _quad = new Quad(width, 30, 0xff3da5);
                _quad.x = 20;
                _quad.y = 165;
                source.addChild(_quad);
            }

        } else if (_data.number == 1 && g.managerParty.userParty.countResource > 0) {
            if (width > 0) {
                _quad = new Quad(width, 30, 0xff3da5);
                _quad.x = 20;
                _quad.y = 165;
                source.addChild(_quad);
            }
        }
        if (_quad) {
            if (_data.number == 1) {
                _quad.x = 44;
            } else if (_data.number == 2) {
                _quad.x = 37;
            } else if (_data.number == 3) {
                _quad.x = 31;
            } else if (_data.number == 4) {
                _quad.x = 23;
            }else if (_data.number == 5) {
                _quad.x = 16;
            }
        }
    }

    private function onClick():void {
        _btn.setEnabled = false;
        g.managerParty.userParty.tookGift[_data.number - 1] = 1;
        var st:String = g.managerParty.userParty.tookGift[0] + '&' + g.managerParty.userParty.tookGift[1] + '&' + g.managerParty.userParty.tookGift[2] + '&'
                + g.managerParty.userParty.tookGift[3] + '&' + g.managerParty.userParty.tookGift[4];
        g.server.updateUserParty(st,g.managerParty.userParty.countResource,0, null);

        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        var d:DropObject = new DropObject();
        if (_data.typeResource == BuildType.DECOR_ANIMATION || _data.typeResource == BuildType.DECOR) {
            d.addDropDecor(g.allData.getBuildingById(_data.idResource), p, _data.countResource);
        } else {
            if (_data.idResource == 1 && _data.typeResource == 1)
                d.addDropMoney(DataMoney.SOFT_CURRENCY, _data.countResource, p);
            else if (_data.idResource == 2 && _data.typeResource == 2) 
                d.addDropMoney(DataMoney.HARD_CURRENCY, _data.countResource, p);
            else d.addDropItemNewByResourceId(_data.idResource, p, _data.countResource);
        }
        d.releaseIt(null, false);
    }

    public function deleteIt():void {
        if (_txtBtn) {
            if (_btn) _btn.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        if (_btn) {
            source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        if (_txtCountResource) {
            if (source) source.removeChild(_txtCountResource);
            _txtCountResource.deleteIt();
            _txtCountResource = null;
        }
        if (_txtCountToGift) {
            if (source) source.removeChild(_txtCountToGift);
            _txtCountToGift.deleteIt();
            _txtCountToGift = null;
        }
        if(_txtCountUser) {
            if (source) source.removeChild(_txtCountUser);
            _txtCountUser.deleteIt();
            _txtCountUser = null;
        }
        if(_bg) {
            _bg = null;
        }
        if (_data) {
            _data = null;
        }
    }
}
}
