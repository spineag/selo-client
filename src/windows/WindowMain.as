/**
 * Created by user on 6/2/15.
 */
package windows {
import com.greensock.TweenMax;

import flash.events.TimerEvent;
import flash.utils.Timer;

import manager.Vars;

import media.SoundConst;

import social.SocialNetworkSwitch;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import tutorial.managerCutScenes.ManagerCutScenes;

import utils.CButton;
import utils.CSprite;
import utils.Utils;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowsManager;
import windows.market.WOMarketChoose;

public class WindowMain {
    protected var _source:Sprite;
    protected var _btnExit:CButton;
    protected var _bg:Image;
    protected var _woWidth:int;
    protected var _woHeight:int;
    protected var _black:CSprite;
    protected var g:Vars = Vars.getInstance();
    protected var _callbackClickBG:Function;
    protected var _windowType:String;
    protected var _isShowed:Boolean = false;
    protected var SOUND_OPEN:int = 0;
    protected var _onWoShowCallback:Function;
    protected var _woBGNew:WindowBackgroundNew;
    protected var _blackAlpha:Number = .5;    
    public var isCashed:Boolean = false;
    protected var _isBigWO:Boolean = true;
    protected var _deltaY:int = 0;

    public function WindowMain() {
        _source = new Sprite();
        _source.x = g.managerResize.stageWidth/2;
        _source.y = g.managerResize.stageHeight/2;
        _woHeight = 0;
        _woWidth = 0;
        SOUND_OPEN = SoundConst.DEFAULT_WINDOW;

    }

    public function showItParams(callback:Function, params:Array):void { }
    public function get source():Sprite { return _source; }
    public function get windowType():String { return _windowType; }
    public function hideIt():void {  if (_source) TweenMax.to(_source, .3, {y:-g.managerResize.stageHeight/2, onComplete: onHideAnimation}); }
    public function hideItQuick():void { onHideAnimation(); }
    public function releaseFromCash():void { showIt(); }
    public function get isShowed():Boolean { return _isShowed; }
    public function set onWoShowCallback(f:Function):void { _onWoShowCallback = f; }

    public function showIt():void {
        if (SOUND_OPEN) g.soundManager.playSound(SOUND_OPEN);
        g.hideAllHints();//?
        _isShowed = true;
        if (_source) {
            createBlackBG();
            g.cont.addGameContListener(false);
            g.cont.windowsCont.addChild(_source);
            _source.x = int(g.managerResize.stageWidth/2);
            _source.y = int(-g.managerResize.stageHeight/2);
            TweenMax.to(_source, .3, {y: int(g.managerResize.stageHeight/2 + _deltaY), onComplete: onShowingWindow});
        }
    }

    protected function onShowingWindow():void {
        if (_onWoShowCallback != null) {
            _onWoShowCallback.apply();
            _onWoShowCallback = null;
        } 
        if (g.tuts.isTuts)  g.tuts.checkTutsCallbackOnShowWindow();
        if (g.miniScenes.isMiniScene) g.miniScenes.checkMiniCutSceneCallbackOnShowWindow();
        if (g.managerCutScenes.isCutScene) {
            if ((g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_SHOW_MARKET) && _windowType == WindowsManager.WO_MARKET) ||
                (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_BUY_DECOR) && _windowType == WindowsManager.WO_SHOP) ||
                (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_SHOW_PAPPER) && _windowType == WindowsManager.WO_PAPER) )
                g.managerCutScenes.checkCutSceneCallback();
        }
    }

    private function onHideAnimation():void {
        _isShowed = false;
        if (g.cont.windowsCont.contains(_source)) g.cont.windowsCont.removeChild(_source);
        g.cont.addGameContListener(true);
        removeBlackBG();
        if (!isCashed) deleteIt();
        if (g.miniScenes.isMiniScene) g.miniScenes.checkMiniCutSceneCallbackOnHideWindow();
        g.windowsManager.onHideWindow(this);
    }

    protected function deleteIt():void {
        if (_btnExit && _source) {
            _source.removeChild(_btnExit);
            _btnExit.deleteIt();
            _btnExit = null;
        }
        _callbackClickBG = null;
        if (_woBGNew && _source) {
            _source.removeChild(_woBGNew);
            _woBGNew.deleteIt();
        }
        if (_source) _source.dispose();
        _source = null;
    }

    protected function createExitButton(callback:Function):void {
        _btnExit = new CButton();
        _btnExit.addDisplayObject(new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_close')));
        _btnExit.setPivots();
        _btnExit.x = _woWidth/2 - 36;
        _btnExit.y = -_woHeight/2 + 36;
        _btnExit.createHitArea('bt_close');
        if (_source) _source.addChild(_btnExit);
        _btnExit.clickCallback = callback;
    }

    protected function grayExitButton(b:Boolean):void {
        if (!_btnExit) return;
        if (b) _btnExit.alpha = .5;
        else _btnExit.alpha = 1;
    }

    protected function hideExitButton():void {
        if (_btnExit) {
            _source.removeChild(_btnExit);
            _btnExit.deleteIt();
            _btnExit = null;
        }
    }

    public function onResize():void {
        _source.x = g.managerResize.stageWidth/2;
        _source.y = g.managerResize.stageHeight/2;
        removeBlackBG();
        createBlackBG();
    }

    private function createBlackBG():void {
        if (_black) return;
        _black = new CSprite();
        _black.addChild(new Quad(g.managerResize.stageWidth, g.managerResize.stageHeight, Color.BLACK));
        g.cont.windowsCont.addChildAt(_black, 0);
        _black.alpha = .0;
        _black.endClickCallback = onBGClick;
        if (_blackAlpha && g.tuts && g.tuts.isTuts) _blackAlpha = .7;
        if (_blackAlpha) TweenMax.to(_black, .2, {alpha:_blackAlpha});
    }

    private function removeBlackBG():void {
        if (_black) {
            _black.endClickCallback = null;
            if (g.cont.windowsCont.contains(_black)) g.cont.windowsCont.removeChild(_black);
            _black.dispose();
            _black = null;
        }
    }

    private function onBGClick():void {
        if (_callbackClickBG != null) {
            _callbackClickBG.apply();
        }
    }
}
}
