/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {

import com.greensock.TweenMax;

import data.BuildType;

import manager.ManagerFilters;
import manager.ManagerOrder;
import manager.ManagerOrderItem;
import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;

public class WOOrderItem {
    public var source:CSprite;
    private var _bgCarton:CartonBackground;
    private var _bgCartonIn:CartonBackgroundIn;
    private var _txtName:CTextField;
    private var _txtXP:CTextField;
    private var _txtCoins:CTextField;
    private var _order:ManagerOrderItem;
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

    public function WOOrderItem(wo:WOOrder) {
        _wo = wo;
        source = new CSprite();
        _bgCarton = new CartonBackground(112, 90);
        _bgCarton.filter = ManagerFilters.SHADOW_LIGHT;
        source.addChild(_bgCarton);
        source.pivotX = source.width/2;
        source.pivotY = source.height/2;
        _bgCartonIn = new CartonBackgroundIn(102, 64);
        _bgCartonIn.x = 5;
        _bgCartonIn.y = 21;
        source.addChild(_bgCartonIn);
        _bgCarton.touchable = true;

        _clockImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('wait'));
        _clockImage.x = 20;
        _clockImage.y = 5;
        _clockImage.visible = false;
        source.addChild(_clockImage);

        _delImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_or'));
        _delImage.x = 25;
        _delImage.y = 10;
        _delImage.visible = false;
        source.addChild(_delImage);

        _txtName = new CTextField(112, 20, "Васько");
        _txtName.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        source.addChild(_txtName);

        _starImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small'));
        _starImage.x = 17;
        _starImage.y = 24;
        _starImage.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_starImage);
        _txtXP = new CTextField(52, 30, "8888");
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level) _txtXP.setFormat(CTextField.BOLD18, 18, ManagerFilters.PINK_COLOR, Color.WHITE);
        else _txtXP.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtXP.x = 48;
        _txtXP.y = 26;
        source.addChild(_txtXP);

        _coinsImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        _coinsImage.x = 17;
        _coinsImage.y = 55;
        _coinsImage.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_coinsImage);
        _txtCoins = new CTextField(52, 30, "8888");
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level) _txtCoins.setFormat(CTextField.BOLD18, 18, ManagerFilters.PINK_COLOR, Color.WHITE);
        else _txtCoins.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCoins.x = 48;
        _txtCoins.y = 55;
        source.addChild(_txtCoins);
        _act = false;

        source.visible = false;
        _checkImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _checkImage.y = -9;
        _checkImage.x = -9;
        _checkImage.visible = false;
        source.addChild(_checkImage);
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _isHover = false;
    }
    
    public function activateIt(v:Boolean):void {
        if (v) {
            _bgCarton.filter = null;
            _bgCarton.filter = ManagerFilters.YELLOW_STROKE;
            _act = true;
        } else {
            _bgCarton.filter = null;
            _bgCarton.filter = ManagerFilters.SHADOW_LIGHT;
            _act = false;
        }
    }

    public function fillIt(order:ManagerOrderItem, position:int, f:Function):void {
        _position = position;
        _order = order;
        _clickCallback = f;
        _txtName.text = _order.catOb.name;
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level) _txtXP.text = String(_order.xp * g.managerParty.coefficient);
        else _txtXP.text = String(_order.xp);
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level) _txtCoins.text = String(_order.coins * g.managerParty.coefficient);
        else _txtCoins.text = String(_order.coins);

        source.visible = true;
        source.endClickCallback = onClick;

        _leftSeconds = _order.startTime - int(new Date().getTime()/1000);

        if (_leftSeconds > 0) {
            if (order.delOb) {
                _txtName.visible = false;
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
                _txtName.visible = false;
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
            if (order.delOb)  order.delOb = false;
            _leftSeconds = -1;
            _txtName.visible = true;
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
            _clickCallback.apply(null, [this,false]);
        }
    }

    public function clearIt():void {
        source.filter = null;
        _order = null;
        source.endClickCallback = null;
        _txtCoins.text = '';
        _txtName.text = '';
        _txtCoins.text = '';
        source.visible = false;
        _checkImage.visible = false;
        g.gameDispatcher.removeFromTimer(renderLeftTime);
        g.gameDispatcher.removeFromTimer(renderLeftTimeOrder);
    }

    private function renderLeftTime():void {
        _leftSeconds--;
        if (_leftSeconds == 19) {
            if (_order &&_txtName && _order.delOb) {
                _wo.timerSkip(_order);
                g.managerOrder.checkForFullOrder();
            }
            else {
                g.userTimer.newCatOrder();
                g.managerOrder.checkForFullOrder();
            }
        }
        if (_leftSeconds <= 0) {
            _leftSeconds = -1;
            g.gameDispatcher.removeFromTimer(renderLeftTime);
            g.managerOrder.checkForFullOrder();
            if(_txtName) _txtName.visible = true;
            if(_txtXP) _txtXP.visible = true;
            if(_txtCoins) _txtCoins.visible = true;
            if(_coinsImage) _coinsImage.visible = true;
            if(_starImage) _starImage.visible = true;
            if(_delImage) _delImage.visible = false;
            if (_clickCallback != null) {
                _clickCallback.apply(null, [this,false,1]);
            }
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
            if(_txtName)_txtName.visible = true;
            if(_txtXP)_txtXP.visible = true;
            if(_txtCoins)_txtCoins.visible = true;
            if(_coinsImage)_coinsImage.visible = true;
            if(_starImage)_starImage.visible = true;
            if(_delImage)_delImage.visible = false;
            if(_clockImage)_clockImage.visible = false;
            if (_clickCallback != null) {
                _clickCallback.apply(null, [this,false,1]);
            }
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
        g.managerOrder.onSkipTimer(_order);
        _order.delOb = false;
        _checkImage.visible = false;
        _delImage.visible = false;
        _clockImage.visible = true;
        _order.startTime = int(new Date().getTime()/1000) + 5;
    }

    private function onHover():void {
        if (_isHover) return;
        _isHover = true;
        _bgCarton.filter = null;
        _bgCarton.filter = ManagerFilters.BUTTON_HOVER_FILTER;
        _timer = 3;
        g.gameDispatcher.addEnterFrame(onEnterFram);
    }

    private function onOut():void {
        _isHover = false;
        if (_act) {
            _bgCarton.filter = null;
            _bgCarton.filter = ManagerFilters.YELLOW_STROKE;
        } else {
            _bgCarton.filter = null;
            _bgCarton.filter = ManagerFilters.SHADOW_LIGHT;
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
    public function getOrder():ManagerOrderItem { return _order; }
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
        _starImage.filter = null;
        _coinsImage.filter = null;
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
        source.removeChild(_bgCarton);
        _bgCarton.filter = null;
        _bgCarton.deleteIt();
        _bgCarton = null;
        source.removeChild(_bgCartonIn);
        _bgCartonIn.filter = null;
        _bgCartonIn.deleteIt();
        _bgCarton = null;
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