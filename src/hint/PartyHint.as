/**
 * Created by user on 6/9/15.
 */
package hint {
import build.fabrica.Fabrica;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import manager.ManagerFilters;
import manager.Vars;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.text.TextField;
import starling.utils.Color;

import tutorial.TutsAction;

import utils.CTextField;
import utils.SensibleBlock;
import utils.SimpleArrow;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class PartyHint {
    private var _source:CSprite;
    private var _txtName:CTextField;
    private var _txtTimer:CTextField;
    private var _txtText:CTextField;
    private var _timer:int;
    private var _closeTime:Number;
    private var _imageClock:Image;
    private var _bg:HintBackground;
    private var _btn:CButton;
    private var _txtCost:CTextField;
    private var _isOnHover:Boolean;
    private var _isShow:Boolean;
    private var _needMoveCenter:Boolean = false;
    private var _callbackSkip:Function;
    private var _quad:Quad;
    private var _onOutCallback:Function;
    private var _canHide:Boolean;
    private var _arrow:SimpleArrow;
    private var g:Vars = Vars.getInstance();

    public function PartyHint() {
        _canHide = true;
        _source = new CSprite();
        _isOnHover = false;
        _isShow = false;
        _txtCost = new CTextField(70,60,"");
        _txtCost.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtCost.x = 3;
        _txtCost.y = 10;
        _txtTimer = new CTextField(110,50,"");
        _txtTimer.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txtTimer.cacheIt = false;
        _txtTimer.x = -90;
        _txtTimer.y = -77;
        _txtName = new CTextField(176,50,"");
        _txtName.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtName.x = -88;

        _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("clock"));
        _imageClock.y = -93;
        _imageClock.x = -63;

        _btn = new CButton();
        _btn.addButtonTexture(70, CButton.HEIGHT_32, CButton.BLUE, true);
        _btn.addTextField(70, 40, 0, -5, String(g.managerLanguage.allTexts[379]) );
        _btn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);

//        _txtCost = new CTextField(50,50,"");
//        _txtCost.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
//        var sens:SensibleBlock;
//        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
//        MCScaler.scale(im,im.height-9, im.width-9);
//        sens = new SensibleBlock();
//        sens.textAndImage(_txtCost,im,60);
//        _btn.addSensBlock(sens,17,18);
        _btn.y = -50;
        _btn.x = 50;
        _source.addChild(_btn);
        _source.addChild(_txtName);
        _source.addChild(_txtTimer);

        _source.hoverCallback = onHover;
        _source.outCallback = outHover;
        _btn.clickCallback = onClickBtn;
        _btn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[432])); };
        _btn.outCallback = function():void { g.hint.hideIt(); };
    }

    public function set needMoveCenter(v:Boolean):void { _needMoveCenter = v; }
    public function get isShow():Boolean { return _isShow; }
    public function set canHide(v:Boolean):void { _canHide = v; }

    public function showIt(height:int,x:int, y:int, timeAll:int, timer:int, cost:int, name:String, f:Function, out:Function, ridge:Boolean = false, animal:Boolean = false):void {
        if(_isShow) return;
        if (timer <=0) return;
        _onOutCallback = out;
        _closeTime = 1;
        _txtName.text = name;
        if (_txtName.textBounds.height >= 40) {
            _bg = new HintBackground(188, 105, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
            _txtName.y = -125;
        } else {
            _bg = new HintBackground(188, 80, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
            _txtName.y = -110;
        }
        _source.addChildAt(_bg, 0);
        var quad:Quad;
        if (ridge) {
            _quad = new Quad(int(_bg.width), int(_bg.height), Color.WHITE);
            quad = new Quad(int(height * g.currentGameScale), int(height * g.currentGameScale), Color.GREEN);
            quad.pivotX = int(quad.width/2);
            _source.addChildAt(quad,0);
            quad.alpha = 0;
        } else if (animal) {
            _quad = new Quad(int(_bg.width), int(_bg.height), Color.WHITE);
            quad = new Quad(int(height * g.currentGameScale), int(height * g.currentGameScale), Color.GREEN);
            quad.pivotX = int(quad.width/2);
            _source.addChildAt(quad,0);
            quad.alpha = 0;
        } else _quad = new Quad(int(_bg.width), int(_bg.height + height/2 * g.currentGameScale), Color.WHITE);
        _quad.alpha = 0;
        _quad.x = -int(_bg.width/2);
        _quad.y = -int(_bg.height);
        _source.addChildAt(_quad,0);
        _callbackSkip = f;
        _source.x = x;// + 115;
        _source.y = y;//+ 150;

        _source.scaleX = _source.scaleY = 0;
        var tween:Tween = new Tween(_source, 0.1);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);

        _isShow = true;
        _isOnHover = true;
        _timer = timer;
        _txtTimer.text = TimeUtils.convertSecondsForHint(_timer);
//        if (g.tuts.isTuts) {
//            _txtCost.text = '0';
//        } else {
//            _txtCost.text = String(g.managerTimerSkip.newCount(timeAll,timer,cost));
//        }
        g.cont.hintContUnder.addChild(_source);
        g.gameDispatcher.addToTimer(onTimer);

        if (_needMoveCenter) {
            if (_source.y < _source.height + 50 || _source.x < _source.width / 2 + 50 || _source.x > g.managerResize.stageWidth - _source.width / 2 - 50) {
                var dY:int = 0;
                if (_source.y < _source.height + 50)
                    dY = _source.height + 50 - _source.y;
                var dX:int = 0;
                if (_source.x < _source.width / 2 + 50) {
                    dX = _source.width / 2 + 50 - _source.x;
                } else if (_source.x > g.managerResize.stageWidth - _source.width / 2 - 50) {
                    dX = g.managerResize.stageWidth - _source.width / 2 - 50 - _source.x;
                }
                g.cont.deltaMoveGameCont(dX, dY, .5);
                new TweenMax(_source, .5, {x: int(_source.x + dX), y: int(_source.y + dY), ease: Linear.easeOut});
            }
            _needMoveCenter = false;
        }
    }

    public function hideIt(force:Boolean = false):void {
        if (!_canHide && !force) return;
        if (_isOnHover && !force) return;
        if (!_isShow) return;
        if (g.tuts.isTuts && g.tuts.action == TutsAction.ANIMAL_SKIP) return;
        if (force) _closeTime = 0;
        else _closeTime = 1;

        g.gameDispatcher.addToTimer(closeTimer);
    }

    private function onTimer():void {
        _timer --;
        _txtTimer.text = TimeUtils.convertSecondsForHint(_timer);
        if(_timer <=0){
            _isOnHover = false;
            hideIt();
            managerHide();
            g.gameDispatcher.removeFromTimer(closeTimer);
            g.mouseHint.hideIt();
        }
    }

    private function closeTimer():void {
        _closeTime--;
        if (_closeTime <= 0) {
            if(!_isOnHover) {
                var tween:Tween = new Tween(_source, 0.1);
                tween.scaleTo(0);
                tween.onComplete = function ():void {
                    g.starling.juggler.remove(tween);
                    _isShow = false;
                    g.gameDispatcher.removeFromTimer(onTimer);
                    _source.removeChild(_quad);
                    _source.removeChild(_bg);
                    _bg = null;
                    if (g.cont.hintContUnder.contains(_source)) {
                        g.cont.hintContUnder.removeChild(_source);
                    }

                };
                g.starling.juggler.add(tween);
            }
            g.gameDispatcher.removeFromTimer(closeTimer);
        }
    }

    private function onHover():void {
        if (_isOnHover) return;
        _isOnHover = true;
    }

    private function outHover():void {
        _isOnHover = false;
        hideIt();
    }

    private function onClickBtn():void {
        if (g.tuts.isTuts) {
            _isOnHover = false;
            _canHide = true;
            _closeTime = 0;
            closeTimer();
            if (_callbackSkip != null) {
                _callbackSkip.apply(null);
            }
            return;
        }
//        if (g.user.hardCurrency < int(_txtCost.text)) {
//            _isOnHover = false;
//            hideIt();
//            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
//            return;
//        }
        managerHide();
//        g.userInventory.addMoney(1,-int(_txtCost.text));
        g.managerAchievement.addAll(25,1);
        _isOnHover = false;
//        managerHide();
        hideIt();
        if (_callbackSkip != null) {
            _callbackSkip.apply(null);
        }
    }

    public function managerHide(callback:Function = null):void {
        if (_isShow) {
            if (g.tuts.isTuts && g.tuts.action == TutsAction.ANIMAL_SKIP) return;
            _closeTime = 1;
            var tween:Tween = new Tween(_source, 0.1);
            tween.scaleTo(0);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
                _isShow = false;
                g.gameDispatcher.removeFromTimer(onTimer);
                _source.removeChild(_quad);
                if (g.cont.hintContUnder.contains(_source)) {
                    g.cont.hintContUnder.removeChild(_source);
                }
                if (callback != null) {
                    callback.apply();
                    callback = null;
                }
            };
            g.starling.juggler.add(tween);
            g.gameDispatcher.removeFromTimer(closeTimer);
            _isShow = false;
            _source.removeChild(_bg);
            _bg = null;
            if (g.tuts.action == TutsAction.FABRICA_SKIP_FOUNDATION) {
                var arr:Array = g.townArea.getCityObjectsById(1);
                (arr[0] as Fabrica).showArrow();
            }
        }
    }

    public function addArrow():void {
        _canHide = false;
        if (_btn && !_arrow) {
            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
            _arrow.animateAtPosition(_btn.x, _btn.y - _btn.height/2 - 2);
            _arrow.scaleIt(.7);
        }
    }

    public function hideArrow():void {
        _canHide = true;
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }
}
}