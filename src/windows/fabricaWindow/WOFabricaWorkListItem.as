/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import com.junkbyte.console.Cc;
import data.DataMoney;
import data.StructureDataRecipe;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Matrix;

import flash.geom.Point;
import manager.ManagerFilters;
import manager.ManagerLanguage;

import resourceItem.RawItem;
import resourceItem.ResourceItem;
import manager.Vars;

import social.SocialNetwork;
import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import tutorial.TutsAction;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;
import utils.TimeUtils;

import windows.WOComponents.WOSimpleButtonTexture;

import windows.WindowsManager;

public class WOFabricaWorkListItem {
    public static const BIG_CELL:String = 'big';
    public static const SMALL_CELL:String = 'small';

    private var _source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _resource:ResourceItem;
    private var _txtTimer:CTextField;
    private var _timerFinishCallback:Function;
    private var _txtNumberCreate:CTextField;
    private var _type:String;
    private var _timerBlock:Sprite;
    private var _btnSkip:CButton;
    private var _txtSkip:CTextField;
    private var _txtForce:CTextField;
    private var _skipCallback:Function;
    private var _skipSmallCallback:Function;
    private var _txt:CTextField;
    private var _priceSkip:int;
    private var _armatureBoom:Armature;
    private var g:Vars = Vars.getInstance();
    private var _number:int;
    private var _woFabrica:WOFabrica;
    private var _isHover:Boolean;
    private var _proposeBtn:CButton;
    private var _sensPropose:SensibleBlock;

    public function WOFabricaWorkListItem(type:String, number:int, woFabrica:WOFabrica) {
        _type = type;
        _source = new CSprite();
        _number = number;
        _woFabrica = woFabrica;
        _isHover = false;
        _txtNumberCreate = new CTextField(30,30," ");
        if (type == SMALL_CELL) {
            _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plants_factory_y_cell_s'));
            _txtNumberCreate.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        } else {
            _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plants_factory_y_cell_b'));
            _txtNumberCreate.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BROWN_COLOR);
        }
        _bg.x = -12;
        _bg.y = -12;
        _source.addChild(_bg);

        if (type == SMALL_CELL) {
            _txtNumberCreate.x = 55;
            _txtNumberCreate.y = 55;
            _source.visible = false;
            _txt = new CTextField(85, 80, String(g.managerLanguage.allTexts[430]));
            _txt.setFormat(CTextField.BOLD18, 15, ManagerFilters.BLUE_COLOR);
            _source.addChild(_txt);
            _source.endClickCallback = onClick;
        } else if (_type == BIG_CELL) {
            _txtNumberCreate.x = 75;
            _txtNumberCreate.y = 95;
            _timerBlock = new Sprite();
            var t:Sprite = new WOSimpleButtonTexture(111, CButton.HEIGHT_32, CButton.BLUE);
            _timerBlock.addChild(t);
            _txtTimer = new CTextField(111, 30, ' ');
            _txtTimer.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
            _txtTimer.cacheIt = false;
            _timerBlock.addChild(_txtTimer);
            _source.addChild(_timerBlock);
            _timerBlock.visible = false;
            _txt = new CTextField(110, 170, String(g.managerLanguage.allTexts[431]));
            _txt.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
            _source.addChild(_txt);

            _btnSkip = new CButton();
            _btnSkip.addButtonTexture(111, CButton.HEIGHT_41, CButton.GREEN, true);
            _txtSkip = new CTextField(60,28,"25");
            _txtSkip.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            _txtSkip.x = 19;
            _txtSkip.y = 13;
            _btnSkip.addChild(_txtSkip);
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            MCScaler.scale(im, 26, 26);
            im.alignPivot();
            im.x = 94;
            im.y = 20;
            _btnSkip.addChild(im);
            _btnSkip.x = 55;
            _btnSkip.y = 160;
            _txtForce = new CTextField(80,20,String(g.managerLanguage.allTexts[432]));
            _txtForce.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            _txtForce.x = 3;
            _txtForce.y = -3;
            _btnSkip.addChild(_txtForce);
            _source.addChild(_btnSkip);
            _btnSkip.visible = false;
            _btnSkip.clickCallback = makeSkip;
        }
    }

    private function onClick():void {
        if (_resource) {
            g.hint.hideIt();
            g.windowsManager.hideWindow(WindowsManager.WO_FABRICA);
            g.windowsManager.cashWindow = _woFabrica;
            g.windowsManager.openWindow(WindowsManager.WO_FABRIC_DELETE_ITEM, makeSkipSmall,_resource);
        }
    }

    private function makeSkipSmall():void {
        if (g.user.hardCurrency >= 1) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -1);

            if (_skipSmallCallback != null) {
                _skipSmallCallback.apply(null, [_number]);
//                _skipSmallCallback = null;
            }
        } else {
            g.windowsManager.closeAllWindows();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
        }
    }

    public function get source():Sprite { return _source; }

    public function fillData(resource:ResourceItem, buy:Boolean = false):void {
        _resource = resource;
        if (!_resource) {
            Cc.error('WOFabricaWorkListItem fillData:: _resource == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'WoFabricaWorkListItem');
            return;
        }
        if (_type == BIG_CELL) {
            _btnSkip.visible = true;
            if (g.tuts.isTuts) _txtSkip.text = String(0);
            else _txtSkip.text = String(g.managerTimerSkip.newCount(_resource.buildTime, _resource.leftTime, _resource.priceSkipHard));
            _priceSkip = g.managerTimerSkip.newCount(_resource.buildTime, _resource.leftTime, _resource.priceSkipHard);
        }
        fillIcon(_resource.imageShop, buy);
    }

    private function fillIcon(s:String, buy:Boolean = false):void {
        if (_icon) {
            _source.removeChild(_icon);
            _icon = null;
        }

        var onFinish:Function = function():void {
            if (_armatureBoom) {
                WorldClock.clock.remove(_armatureBoom);
                _armatureBoom.removeEventListener(EventObject.COMPLETE, onFinish);
                _armatureBoom.removeEventListener(EventObject.LOOP_COMPLETE, onFinish);
                _source.removeChild(_armatureBoom.display as StarlingArmatureDisplay);
                _armatureBoom = null;
            }
            if (g.tuts.isTuts) {
//                removeArrow();
                g.tuts.checkTutsCallback();
            }
        };
        if (buy) {
            _armatureBoom = g.allData.factory['explode_gray_fabric'].buildArmature("expl_fabric");

            if (_type == SMALL_CELL) {
                (_armatureBoom.display as StarlingArmatureDisplay).x = _bg.width / 2 -15;
                (_armatureBoom.display as StarlingArmatureDisplay).y = _bg.height/2 + 20;
                (_armatureBoom.display as StarlingArmatureDisplay).scale = .5;
            } else {
                (_armatureBoom.display as StarlingArmatureDisplay).x = _bg.width / 2 -15;
                (_armatureBoom.display as StarlingArmatureDisplay).y = _bg.height/2 + 30;
            }
            WorldClock.clock.add(_armatureBoom);
            _source.addChild(_armatureBoom.display as StarlingArmatureDisplay);
            _armatureBoom.addEventListener(EventObject.COMPLETE, onFinish);
            _armatureBoom.addEventListener(EventObject.LOOP_COMPLETE, onFinish);
            _armatureBoom.animation.gotoAndPlayByFrame("idle");
        }

        _icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(s));
        _icon.alignPivot();
        if (_type == BIG_CELL) {
//            MCScaler.scale(_icon, 85, 100);
            _icon.x = 54;
            _icon.y = 83;
        } else {
            MCScaler.scale(_icon, 74, 74);
            _icon.x = 43;
            _icon.y = 43;
        }
        var r:StructureDataRecipe = g.allData.getRecipeByResourceId(_resource.resourceID);
        if ( r && r.numberCreate > 1) _txtNumberCreate.text = String(r.numberCreate);
            else _txtNumberCreate.text = " ";

        _source.addChildAt(_icon,1);
        if (_type != BIG_CELL) {
            _source.hoverCallback =  function():void {
                if (_isHover) return;
                _isHover = true;
                g.hint.showIt(String(g.managerLanguage.allTexts[433]));
                _source.filter = ManagerFilters.BUTTON_HOVER_FILTER;
            };
            _source.outCallback =  function():void {
                _isHover = false;
                g.hint.hideIt();
                _source.filter = null;
            };
        }
        _source.addChild(_txtNumberCreate);
        _txt.visible = false;
    }

    public function destroyTimer():void {
        g.gameDispatcher.removeFromTimer(render);
        _timerFinishCallback = null;
        _txtTimer.text = '';
        _timerBlock.visible = false;
    }

    public function activateTimer(f:Function):void {
        if (_type == BIG_CELL) {
            _timerFinishCallback = f;
            g.gameDispatcher.addToTimer(render);
            _timerBlock.visible = true;
            _btnSkip.visible = true;
            _txtTimer.text = TimeUtils.convertSecondsToStringClassic(_resource.leftTime);
        } else {
            Cc.error('WOFabricaWorkListItem activateTimer:: ');
        }
    }

    private function render():void {
        if (!_resource) return;
        if (_resource.leftTime <= 0) {
            g.gameDispatcher.removeFromTimer(render);
            _txtTimer.text = '';
            _timerBlock.visible = false;
            _btnSkip.visible = false;
            if (g.tuts.isTuts && g.tuts.action == TutsAction.FABRICA_SKIP_RECIPE) {
                g.tuts.checkTutsCallback();
            }
            if (_timerFinishCallback != null) {
                _timerFinishCallback.apply();
            }
        } else {
            _txtTimer.text = TimeUtils.convertSecondsToStringClassic(_resource.leftTime);
        }
    }

    public function showBuyPropose(buyCount:int, callback:Function):void {
        if (g.tuts.isTuts || g.managerCutScenes.isCutScene) return;
        if (_type != SMALL_CELL) return;
        _source.visible = true;
        _txt.visible = false;
        if (_proposeBtn) return;
        _proposeBtn = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('add_button_light'));
        im.alignPivot();
        _proposeBtn.addDisplayObject(im);
        _proposeBtn.x = 42;
        _proposeBtn.y = 30;
        _source.addChild(_proposeBtn);

        _sensPropose = new SensibleBlock();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        MCScaler.scale(im, 26, 26);
        var t:CTextField = new CTextField(60, 30, String(buyCount));
        t.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _sensPropose.textAndImage(t, im, 85, 25);
        _sensPropose.y = 67;
        _source.addChild(_sensPropose);

        var f1:Function = function ():void {
            _proposeBtn.filter = null;
            g.hint.hideIt();
            if (g.user.hardCurrency >= buyCount) {
                if (callback != null) {
                    callback.apply();
                }
                unfillIt();
                _txt.visible = true;
                _source.visible = true;
                var p:Point = new Point(_source.width / 2, _source.height / 2);
                p = _source.localToGlobal(p);
                new RawItem(p, g.allData.atlas['interfaceAtlas'].getTexture('rubins'), buyCount, 0);
                g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -buyCount);
            } else {
                g.windowsManager.closeAllWindows();
                g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            }
        };
        _proposeBtn.clickCallback = f1;
        _proposeBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[434])); };
        _proposeBtn.outCallback = function():void { g.hint.hideIt(); };
    }

    public function removePropose():void {
        unfillIt();
        _source.visible = true;
    }

    private function makeSkip():void {
        if (g.tuts.isTuts) {
            if (g.tuts.isTuts && g.tuts.action == TutsAction.FABRICA_SKIP_RECIPE) {
                if (_skipCallback != null) {
                    destroyTimer();
                    _btnSkip.visible = false;
                    _skipCallback.apply();
                }
                g.tuts.checkTutsCallback();
            }
            return;
        }
        if (g.user.hardCurrency >= _priceSkip) {
            if (_skipCallback != null) {
                g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_priceSkip);
                g.managerAchievement.addAll(25,1);
                destroyTimer();
                _btnSkip.visible = false;
                _skipCallback.apply();
            }
            if (g.tuts.isTuts && g.tuts.action == TutsAction.FABRICA_SKIP_RECIPE) {
                g.tuts.checkTutsCallback();
            }
        } else {
            g.windowsManager.hideWindow(WindowsManager.WO_FABRICA);
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
        }
    }

    public function set skipCallback(f:Function):void {
        _skipCallback = f;
    }

    public function set skipSmallCallback(f:Function):void {
        _skipSmallCallback = f;
    }

    public function getSkipBtnProperties():Object {
        var ob:Object = {};
        ob.x = _btnSkip.x - _btnSkip.width/2;
        ob.y = _btnSkip.y - _btnSkip.height/2;
        var p:Point = new Point(ob.x, ob.y);
        p = _source.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = _btnSkip.width;
        ob.height = _btnSkip.height;
        return ob;
    }

    public function unfillIt():void {
        if (_icon) {
            _txtNumberCreate.text = " ";
            _source.removeChild(_txtNumberCreate);
            _source.removeChild(_icon);
            _icon = null;
        }
        _resource = null;
//        _skipCallback = null;
        if (_type == SMALL_CELL) {
            _source.visible = false;
            if (_proposeBtn) {
                _source.removeChild(_proposeBtn);
                _proposeBtn.deleteIt();
                _proposeBtn = null;
            }
            if (_sensPropose) {
                _source.removeChild(_sensPropose);
                _sensPropose.deleteIt();
                _sensPropose = null;
            }
        } else {
            _txtSkip.text = '';
            _btnSkip.visible = false;
        }
        _txt.visible = true;
    }

    public function deleteIt():void {
        g.gameDispatcher.removeFromTimer(render);
        if (_armatureBoom) {
            WorldClock.clock.remove(_armatureBoom);
            _source.removeChild(_armatureBoom.display as StarlingArmatureDisplay);
            _armatureBoom = null;
        }
        if (_txt) {
            _source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        if (_txtSkip) {
            if (_btnSkip) _btnSkip.removeChild(_txtSkip);
            _txtSkip.deleteIt();
            _txtSkip = null;
        }
        if (_txtNumberCreate) {
            _source.removeChild(_txtNumberCreate);
            _txtNumberCreate.deleteIt();
            _txtNumberCreate = null;
        }
        if (_txtTimer) {
            _timerBlock.removeChild(_txtTimer);
            _txtTimer.deleteIt();
            _txtTimer = null;
        }
        if (_txtForce) {
            if (_btnSkip) _btnSkip.removeChild(_txtForce);
            _txtForce.deleteIt();
            _txtForce = null;
        }
        if (_proposeBtn) {
            _source.removeChild(_proposeBtn);
            _proposeBtn.deleteIt();
            _proposeBtn = null;
        }
        if (_sensPropose) {
            _source.removeChild(_sensPropose);
            _sensPropose.deleteIt();
            _sensPropose = null;
        }
        if (_btnSkip) {
            _source.removeChild(_btnSkip);
            _btnSkip.deleteIt();
            _btnSkip = null;
        }
        _source.dispose();
        _source = null;
        _timerFinishCallback = null;
        _skipCallback = null;
        _resource = null;
    }

}
}
