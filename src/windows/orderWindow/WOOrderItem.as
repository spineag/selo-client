/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {
import com.greensock.TweenMax;
import data.BuildType;
import manager.ManagerFilters;
import manager.ManagerLanguage;

import order.OrderItemStructure;
import manager.Vars;
import starling.display.Image;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;

public class WOOrderItem {
    public var source:CSprite;
    private var _imBG:Image;
    private var _txtName:CTextField;
    private var _txtXP:CTextField;
    private var _txtCoins:CTextField;
    private var _order:OrderItemStructure;
    private var _leftSeconds:int;
    private var _starImage:Image;
    private var _coinsImage:Image;
    private var _clockImage:Image;
    private var _delImage:Image;
    private var _position:int;
    private var _checkImage:Image;
    private var _clickCallback:Function;
    private var _act:Boolean;
    private var _wo:WOOrder;
    private var _timer:int;
    private var _isHover:Boolean;
    private var g:Vars = Vars.getInstance();
    private var _booleanNewCat:Boolean;

    public function WOOrderItem(wo:WOOrder) {
        _act = false;
        _isHover = false;
        _wo = wo;
        source = new CSprite();
        source.visible = false;
        _imBG = new Image(g.allData.atlas['interfaceAtlas'].getTexture('orders_cell'));
        source.addChild(_imBG);
        source.alignPivot();

        _clockImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('wait'));
        _clockImage.alignPivot();
        _clockImage.x = 60;
        _clockImage.y = 88;
        _clockImage.visible = false;
        source.addChild(_clockImage);

        _booleanNewCat = true;
        _delImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_or'));
        _delImage.alignPivot();
        _delImage.x = 60;
        _delImage.y = 88;
        _delImage.visible = false;
        source.addChild(_delImage);

        _txtName = new CTextField(114, 42, "Васько");
        _txtName.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        source.addChild(_txtName);

        _starImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('xp_icon'));
        MCScaler.scale(_starImage, 40,40);
        _starImage.alignPivot();
        _starImage.x = 26;
        _starImage.y = 110;
//        _starImage.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_starImage);
        _txtXP = new CTextField(64, 30, "8888");
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level) 
            _txtXP.setFormat(CTextField.BOLD18, 18, ManagerFilters.PINK_COLOR, Color.WHITE);
            else _txtXP.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtXP.alignPivot();
        _txtXP.x = 68;
        _txtXP.y = 107;
        source.addChild(_txtXP);

        _coinsImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        _coinsImage.alignPivot();
        _coinsImage.x = 26;
        _coinsImage.y = 69;
        _coinsImage.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_coinsImage);
        _txtCoins = new CTextField(64, 30, "8888");
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level) 
            _txtCoins.setFormat(CTextField.BOLD18, 18, ManagerFilters.PINK_COLOR, Color.WHITE);
            else _txtCoins.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCoins.alignPivot();
        _txtCoins.x = 68;
        _txtCoins.y = 65;
        source.addChild(_txtCoins);

        _checkImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
        MCScaler.scale(_checkImage, _checkImage.height-5, _checkImage.width-5);
        _checkImage.x = 78;
        _checkImage.y = -15;
        _checkImage.visible = false;
        source.addChild(_checkImage);
        source.hoverCallback = onHover;
        source.outCallback = onOut;
    }
    
    public function activateIt(v:Boolean):void {
        if (v) {
            if (_imBG.filter) _imBG.filter = null;
            _imBG.filter = ManagerFilters.BLUE_STROKE;
            _act = true;
        } else {
            if (_imBG.filter) _imBG.filter = null;
            _act = false;
        }
    }

    public function fillIt(order:OrderItemStructure, position:int, f:Function, b:Boolean = false):void {
        _position = position;
        _order = order;
        _clickCallback = f;
        if (b) {
            _txtName.text = String(g.managerLanguage.allTexts[372]);
            var myPattern:RegExp = /count/;
            var str:String =  String(g.managerLanguage.allTexts[342]);
            _txtCoins.deleteIt();
            _txtCoins = null;
            _txtCoins = new CTextField(110, 60,  String(str.replace(myPattern, String(g.managerOrder.countCellAtLevel(position)))));
            _txtCoins.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
//            _txtCoins.x = -10;
            _txtCoins.y = 50;
            source.addChild(_txtCoins);
            source.visible = true;
            source.filter = ManagerFilters.getButtonDisableFilter();
            _coinsImage.visible = false;
            _txtXP.visible = false;
            _starImage.visible = false;
            return;
        }
        if (g.user.language == ManagerLanguage.ENGLISH) _txtName.text = _order.catOb.nameENG;
        else _txtName.text = _order.catOb.nameRU;
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level) _txtXP.text = String(_order.xp * g.managerParty.coefficient);
            else _txtXP.text = String(_order.xp);
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level) _txtCoins.text = String(_order.coins * g.managerParty.coefficient);
            else _txtCoins.text = String(_order.coins);

        source.visible = true;
        source.endClickCallback = onClick;

        _leftSeconds = _order.startTime - TimeUtils.currentSeconds;

        if (_leftSeconds > 0) {
            if (_order.delOb) {
                _txtName.text = String(g.managerLanguage.allTexts[1171]);
//                _txtName.visible = false;
                _txtXP.visible = false;
                _txtCoins.visible = false;
                _coinsImage.visible = false;
                _starImage.visible = false;
                _checkImage.visible = false;
                g.userTimer.setOrder(_order);
                g.gameDispatcher.addToTimer(renderLeftTime);
                _clockImage.visible = false;
                _delImage.visible = true;
            } else {
                _txtName.text = String(g.managerLanguage.allTexts[1171]);
//                _txtName.visible = false;
                _txtXP.visible = false;
                _txtCoins.visible = false;
                _coinsImage.visible = false;
                _starImage.visible = false;
                _checkImage.visible = false;
                g.userTimer.setOrder(_order);
                g.gameDispatcher.addToTimer(renderLeftTimeOrder);
                _delImage.visible = false;
                _clockImage.visible = true;
            }
        } else {
            if (_order.delOb)  _order.delOb = false;
            _leftSeconds = -1;
            _txtName.text = _order.catOb.name;
//            _txtName.visible = true;
            _txtXP.visible = true;
            _txtCoins.visible = true;
            _coinsImage.visible = true;
            _starImage.visible = true;
            _clockImage.visible = false;
            _delImage.visible = false;
        }
        updateCheck();
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [this]);
        }
    }

    public function clearIt():void {
        if (source) source.filter.dispose();
        source.filter = null;
//        if (_imBG.filter) _imBG.filter.dispose();
        _imBG.filter = null;
        _order = null;
        source.endClickCallback = null;
        _txtName.text = '';
        _txtCoins.text = '';
        source.visible = false;
        _checkImage.visible = false;
        g.gameDispatcher.removeFromTimer(renderLeftTime);
        g.gameDispatcher.removeFromTimer(renderLeftTimeOrder);
    }

    private function renderLeftTime():void {
        _leftSeconds--;
        if (_leftSeconds <= 16) {
           if (_order && _txtName && _order.delOb) _wo.timerSkip(_order);
            else if (_booleanNewCat) {
               _booleanNewCat = false;
               g.userTimer.newCatOrder(_position);
           }
            g.managerOrder.checkForFullOrder();
        }
        if (_leftSeconds <= 0) {
            _leftSeconds = -1;
            g.gameDispatcher.removeFromTimer(renderLeftTime);
            _booleanNewCat = true;
            g.managerOrder.checkForFullOrder();
            if(_txtName) {
                if (g.user.language == ManagerLanguage.ENGLISH) _txtName.text = _order.catOb.nameENG;
                else _txtName.text = _order.catOb.nameRU;
                _txtName.visible = true;
            }
            if (_txtXP) _txtXP.visible = true;
            if (_txtCoins) _txtCoins.visible = true;
            if (_coinsImage) _coinsImage.visible = true;
            if (_starImage) _starImage.visible = true;
            if (_delImage) _delImage.visible = false;
            if (_clickCallback != null) { _clickCallback.apply(null, [this,1]); }
            updateCheck();
        }
    }
    
    public function updateCheck():void {
        if (!_order) return;
        if (_checkImage) {
            if (_clockImage.visible || _delImage.visible) {
                _checkImage.visible = false;
                return;
            }
            var b:Boolean = true;
            for (var i:int = 0; i < _order.resourceIds.length; i++) {
                if (g.userInventory.getCountResourceById(_order.resourceIds[i]) < _order.resourceCounts[i]) {
                    b = false;
                    break;
                }
            }
            _checkImage.visible = b;
        }
    }

    private function renderLeftTimeOrder():void {
        _leftSeconds--;
        if (_leftSeconds <= 0) {
            _leftSeconds = -1;
            g.gameDispatcher.removeFromTimer(renderLeftTimeOrder);
            if(_txtName) {
                if (g.user.language == ManagerLanguage.ENGLISH) _txtName.text = _order.catOb.nameENG;
                else _txtName.text = _order.catOb.nameRU;
                _txtName.visible = true;
            }
            if(_txtXP)_txtXP.visible = true;
            if(_txtCoins)_txtCoins.visible = true;
            if(_coinsImage)_coinsImage.visible = true;
            if(_starImage)_starImage.visible = true;
            if(_delImage)_delImage.visible = false;
            if(_clockImage)_clockImage.visible = false;
            if (_clickCallback != null) { _clickCallback.apply(null, [this,1]); }
            g.managerOrder.checkForFullOrder();
            if (_checkImage) {
                var b:Boolean = true;
                for (var i:int = 0; i < _order.resourceIds.length; i++) {
                    if (g.userInventory.getCountResourceById(_order.resourceIds[i]) < _order.resourceCounts[i]) {
                        b = false;
                        break;
                    }
                }
                _checkImage.visible = b;
            }
        }
    }

    public function onSkipTimer():void {
        g.gameDispatcher.removeFromTimer(renderLeftTime);
        _leftSeconds = 5;
        g.gameDispatcher.addToTimer(renderLeftTimeOrder);
        if (_order) _order.delOb = false;
        if (_checkImage) _checkImage.visible = false;
        if (_delImage)_delImage.visible = false;
        if (_clockImage) _clockImage.visible = true;
        if (_order) _order.startTime = TimeUtils.currentSeconds + 5;
        g.managerOrder.onSkipTimer(_order);
    }

    private function onHover():void {
        if (_isHover) return;
        _isHover = true;
        if (_imBG.filter) _imBG.filter = null;
        _imBG.filter = ManagerFilters.BUTTON_HOVER_FILTER;
        _timer = 3;
        g.gameDispatcher.addEnterFrame(onEnterFram);
    }

    private function onOut():void {
        _isHover = false;
        if (_act) {
            if (_imBG.filter) _imBG.filter = null;
            _imBG.filter = ManagerFilters.BLUE_STROKE;
        } else {
            if (_imBG.filter) _imBG.filter = null;
        }
        g.gameDispatcher.removeEnterFrame(onEnterFram);
        _timer = 0;
        g.hint.hideIt();
    }

    private function onEnterFram():void {
        _timer --;
        if (_timer <= 0) {
            g.hint.showIt(String(g.managerLanguage.allTexts[372]));
            g.gameDispatcher.removeEnterFrame(onEnterFram);
        }
    }

    public function get position():int { return _position; }
    public function get leftSeconds():int { return _leftSeconds; }
    public function getOrder():OrderItemStructure { return _order; }
    public function animation(delay:Number):void { TweenMax.to(source, .3, {scaleX:1, scaleY:1, alpha:1, y: source.y, delay:delay}); }
    public function animationHide(delay:Number):void { TweenMax.to(source, .3, {scaleX:0, scaleY:0, alpha:1, y: source.y, delay:delay}); }
    public function get isClock():Boolean { return _clockImage.visible; }

    public function clearItem():void {
        _txtName.text = '';
        _txtXP.text = '';
        _txtCoins.text = '';
        _leftSeconds = 0;
    }

    public function deleteIt():void {
        g.hint.hideIt();
//        g.gameDispatcher.removeFromTimer(renderLeftTime);
//        g.gameDispatcher.removeFromTimer(renderLeftTimeOrder);
        if (!source) return;
//        _starImage.filter.dispose();
        _coinsImage.filter.dispose();
        if (_txtName) {
            source.removeChild(_txtName);
            _txtName.deleteIt();
            _txtName = null;
        }
        if (_txtCoins) {
            source.removeChild(_txtCoins);
            _txtCoins.deleteIt();
            _txtCoins = null;
        }
        if (_txtXP) {
            source.removeChild(_txtXP);
            _txtXP.deleteIt();
            _txtXP = null;
        }
        _order = null;
        source.filter = null;
        source.removeChild(_imBG);
        if (_imBG.filter) _imBG.filter = null;
        _clickCallback = null;
        _starImage = null;
        _coinsImage = null;
        _delImage = null;
        _checkImage = null;
        source.deleteIt();
        source = null;
    }
}
}