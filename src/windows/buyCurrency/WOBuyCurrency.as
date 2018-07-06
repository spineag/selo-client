/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import com.greensock.TweenMax;

import data.DataMoney;

import flash.display.Bitmap;

import flash.geom.Rectangle;

import loaders.PBitmap;

import manager.ManagerFilters;
import media.SoundConst;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.Color;

import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyCurrency extends WindowMain {
    private var _isHard:Boolean = false;
    private var _arrItems:Array;
    private var _txtWindowName:CTextField;
    private var _tabs:MoneyTabs;
    private var _bigYellowBG:BackgroundYellowOut;
    private var _mask:Sprite;
    private var _cont:Sprite;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _shift:int;
    private var _count:int = 0;

    public function WOBuyCurrency() {
        super();
        SOUND_OPEN = SoundConst.OPEN_CURRENCY_WINDOW;
        _windowType = WindowsManager.WO_BUY_CURRENCY;
        if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 770) _isBigWO = false;
            else _isBigWO = true;

        if (_isBigWO) {
            _woWidth = 856;
            _woHeight = 762;
        } else {
            _woWidth = 856;
            _woHeight = 500;
        }
        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 108);
        _source.addChild(_woBGNew);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        _txtWindowName = new CTextField(300, 50, g.managerLanguage.allTexts[453]);
        _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtWindowName.x = -150;
        _txtWindowName.y = -_woHeight/2 + 23;
        _source.addChild(_txtWindowName);

        if (_isBigWO) {
            _bigYellowBG = new BackgroundYellowOut(804, 558);
            _bigYellowBG.y = -_woHeight / 2 + 176;
            _bigYellowBG.x = -402;
        } else {
            _bigYellowBG = new BackgroundYellowOut(744, 308);
            _bigYellowBG.y = -_woHeight / 2 + 170;
            _bigYellowBG.x = -_woWidth/2 + 55;
        }

        _bigYellowBG.source.touchable = true;
        _source.addChild(_bigYellowBG);
        if (!_isBigWO) createForSmallWindow();
        atlasLoad();
    }

    public function atlasLoad():void {
        if (!g.allData.atlas['bankAtlas']) {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas'), onLoad);
            g.load.loadXML(g.dataPath.getGraphicsPath() + 'bankAtlas.xml' + g.getVersion('bankAtlas'), onLoad);
        } else createAtlases();
    }

    private function onLoad(smth:*=null):void {
        _count++;
        if (_count >=2) createAtlases();
    }

    private function createAtlases():void {
        if (!g.allData.atlas['bankAtlas']) {
            if (g.pBitmaps[g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas')] && g.pXMLs[g.dataPath.getGraphicsPath() + 'bankAtlas.xml' + g.getVersion('bankAtlas')]) {
                g.allData.atlas['bankAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'bankAtlas.xml' + g.getVersion('bankAtlas')]);
                (g.pBitmaps[g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas')] as PBitmap).deleteIt();

                delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas')];
                delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'bankAtlas.xml' + g.getVersion('bankAtlas')];
                g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas'));
                g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'bankAtlas.xml' + g.getVersion('bankAtlas'));
            }
        }
        _tabs = new MoneyTabs(_bigYellowBG, onTabClick, _isBigWO);
    }

    private function createForSmallWindow():void {
        _mask = new Sprite();
        _mask.mask = new Quad(716, 264 + 50);
        _mask.y = -_woHeight/2 + 192;
        _mask.x = -_woWidth/2 + 70;
        _source.addChild(_mask);
        _cont = new Sprite();
        _mask.addChild(_cont);
        _leftArrow = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.alignPivot();
        _leftArrow.addChild(im);
        _leftArrow.clickCallback = onClickLeft;
        _leftArrow.x = -_woWidth/2 + 31;
        _leftArrow.y = -_woHeight/2 + 320;
        _source.addChild(_leftArrow);
        _rightArrow = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX = -1;
        im.alignPivot();
        _rightArrow.addChild(im);
        _rightArrow.clickCallback = onClickRight;
        _rightArrow.x = _woWidth/2 - 31;
        _rightArrow.y = -_woHeight/2 + 320;
        _source.addChild(_rightArrow);
    }

    private function createLists():void {
        var item:WOBuyCurrencyItem;
        var arrInfo:Array = [];
        var arr:Array = g.allData.dataBuyMoney;

        _arrItems = [];
        for (var i:int = 0; i<arr.length; i++) {
            if (_isHard && arr[i].typeMoney == DataMoney.HARD_CURRENCY) {
                arrInfo.push(arr[i]);
            } else if (!_isHard && arr[i].typeMoney == DataMoney.SOFT_CURRENCY) {
                arrInfo.push(arr[i]);
            }
        }
        arrInfo.sortOn('count', Array.NUMERIC);
        if (_isBigWO) {
            for (i = 0; i < arrInfo.length; i++) {
                item = new WOBuyCurrencyItem(arrInfo[i].typeMoney, arrInfo[i].count, arrInfo[i].bonus, arrInfo[i].cost, arrInfo[i].id, arrInfo[i].sale);
                item.source.x = -_woWidth / 2 + 57 + (i % 3) * 260;
                if (i < 3) item.source.y = -_woHeight / 2 + 204;
                else item.source.y = -_woHeight / 2 + 468;
                _source.addChild(item.source);
                _arrItems.push(item);
            }
        } else {
            _shift = 0;
            _cont.x = 0;
            checkArrows();
            for (i = 0; i < arrInfo.length; i++) {
                item = new WOBuyCurrencyItem(arrInfo[i].typeMoney, arrInfo[i].count, arrInfo[i].bonus, arrInfo[i].cost, arrInfo[i].id, arrInfo[i].sale);
                item.source.x = 2 + i * 240;
                item.source.y = 2;
                _cont.addChild(item.source);
                _arrItems.push(item);
            }
        }
    }

    private function onClickLeft():void {
        _shift = 0;
        TweenMax.to(_cont, .3, {x: 0});
        checkArrows();
    }

    private function onClickRight():void {
        _shift = 1;
        TweenMax.to(_cont, .3, {x: 2 - 3*240});
        checkArrows();
    }

    private function checkArrows():void {
        if (_isBigWO) return;
        if (_shift > 0) {
            _leftArrow.visible = true;
            _rightArrow.visible = false;
        } else {
            _leftArrow.visible = false;
            _rightArrow.visible = true;
        }
    }

    private function onTabClick():void {
        _isHard = !_isHard;
        _tabs.activate(!_isHard);
        deleteLists();
        createLists();
    }

    private function deleteLists():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            if (_isBigWO) _source.removeChild(_arrItems[i].source);
                else _cont.removeChild(_arrItems[i].source);
            (_arrItems[i] as WOBuyCurrencyItem).deleteIt();
        }
        _arrItems.length = 0;
    }

    override public function showItParams(callback:Function, params:Array):void {
        _isHard = params[0];
        if (!g.allData.atlas['bankAtlas']) {
            g.gameDispatcher.addEnterFrame(postLoad);
            return;
        }
        _tabs.activate(!_isHard);
        createLists();
        super.showIt();
    }

    private function postLoad():void {
        if (g.allData.atlas['bankAtlas']) {
            g.gameDispatcher.removeEnterFrame(postLoad);
            _tabs.activate(!_isHard);
            createLists();
            super.showIt();
        }
    }

    override protected function deleteIt():void {
        if (!_source) return;
        deleteLists();
        if (!_isBigWO) {
            _source.removeChild(_leftArrow);
            _leftArrow.deleteIt();
            _source.removeChild(_rightArrow);
            _rightArrow.deleteIt();
        }
        _source.removeChild(_txtWindowName);
        _txtWindowName.deleteIt();
        _tabs.deleteIt();
        _source.removeChild(_bigYellowBG);
        _bigYellowBG.deleteIt();
        super.deleteIt();
    }

}
}

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import windows.WOComponents.BackgroundYellowOut;

internal class MoneyTabs {
    private var g:Vars = Vars.getInstance();
    private var _callback:Function;
    private var _imActiveSoft:Image;
    private var _txtActiveSoft:CTextField;
    private var _unactiveSoft:CSprite;
    private var _txtUnactiveSoft:CTextField;
    private var _imActiveHard:Image;
    private var _txtActiveHard:CTextField;
    private var _unactiveHard:CSprite;
    private var _txtUnactiveHard:CTextField;
    private var _bg:BackgroundYellowOut;

    public function MoneyTabs(bg:BackgroundYellowOut, f:Function, isBigWindow:Boolean) {
        _bg = bg;
        _callback = f;
        _imActiveSoft = new Image(g.allData.atlas['bankAtlas'].getTexture('bank_panel_tab_big'));
        _imActiveSoft.pivotX = _imActiveSoft.width/2;
        _imActiveSoft.pivotY = _imActiveSoft.height;
        bg.addChild(_imActiveSoft);
        _txtActiveSoft = new CTextField(330, 48, g.managerLanguage.allTexts[325]);
        _txtActiveSoft.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        bg.addChild(_txtActiveSoft);
        if ( isBigWindow) {
            _imActiveSoft.x = 230;
            _txtActiveSoft.x = 69;
        } else {
            _imActiveSoft.x = 200;
            _txtActiveSoft.x = 39;
        }
        _imActiveSoft.y = 11;
        _txtActiveSoft.y = -50;

        _unactiveSoft = new CSprite();
        var im:Image = new Image(g.allData.atlas['bankAtlas'].getTexture('bank_panel_tab_small'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        _unactiveSoft.addChild(im);
        bg.addChildAt(_unactiveSoft, 0);
        _unactiveSoft.endClickCallback = onClick;
        _txtUnactiveSoft = new CTextField(330, 48, g.managerLanguage.allTexts[325]);
        _txtUnactiveSoft.setFormat(CTextField.BOLD24, 24, ManagerFilters.BROWN_COLOR, Color.WHITE);
        bg.addChild(_txtUnactiveSoft);
        if (isBigWindow) {
            _unactiveSoft.x = 230;
            _txtUnactiveSoft.x = 69;
        } else {
            _unactiveSoft.x = 200;
            _txtUnactiveSoft.x = 39;
        }
        _txtUnactiveSoft.y = -42;
        _unactiveSoft.y = 13;

        _imActiveHard = new Image(g.allData.atlas['bankAtlas'].getTexture('bank_panel_tab_big'));
        _imActiveHard.pivotX = _imActiveHard.width/2;
        _imActiveHard.pivotY = _imActiveHard.height;
        bg.addChild(_imActiveHard);
        _txtActiveHard = new CTextField(330, 48, g.managerLanguage.allTexts[326]);
        _txtActiveHard.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        bg.addChild(_txtActiveHard);
        if (isBigWindow) {
            _txtActiveHard.x = 412;
            _imActiveHard.x = 578;
        } else {
            _txtActiveHard.x = 382;
            _imActiveHard.x = 548;
        }
        _imActiveHard.y = 11;
        _txtActiveHard.y = -50;

        _unactiveHard = new CSprite();
        im = new Image(g.allData.atlas['bankAtlas'].getTexture('bank_panel_tab_small'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        _unactiveHard.addChild(im);
        bg.addChildAt(_unactiveHard, 0);
        _unactiveHard.endClickCallback = onClick;
        _txtUnactiveHard = new CTextField(330, 48, g.managerLanguage.allTexts[326]);
        _txtUnactiveHard.setFormat(CTextField.BOLD24, 24, ManagerFilters.BROWN_COLOR, Color.WHITE);
        bg.addChild(_txtUnactiveHard);
        if (isBigWindow) {
            _txtUnactiveHard.x = 412;
            _unactiveHard.x = 578;
        } else {
            _txtUnactiveHard.x = 382;
            _unactiveHard.x = 548;
        }
        _unactiveHard.y = 13;
        _txtUnactiveHard.y = -42;
    }

    private function onClick():void { if (_callback!=null) _callback.apply(); }

    public function activate(isSoft:Boolean):void {
        _imActiveSoft.visible = _unactiveHard.visible = isSoft;
        _imActiveHard.visible = _unactiveSoft.visible = !isSoft;
        _txtActiveSoft.visible = _txtUnactiveHard.visible = isSoft;
        _txtActiveHard.visible = _txtUnactiveSoft.visible = !isSoft;
    }

    public function deleteIt():void {
        _bg.removeChild(_txtActiveSoft);
        _bg.removeChild(_txtActiveHard);
        _bg.removeChild(_txtUnactiveHard);
        _bg.removeChild(_txtUnactiveSoft);
        _bg.removeChild(_imActiveSoft);
        _bg.removeChild(_imActiveHard);
        _bg.removeChild(_unactiveSoft);
        _bg.removeChild(_unactiveHard);
        _txtActiveSoft.deleteIt();
        _txtActiveHard.deleteIt();
        _txtUnactiveSoft.deleteIt();
        _txtUnactiveHard.deleteIt();
        _imActiveSoft.dispose();
        _imActiveHard.dispose();
        _unactiveSoft.deleteIt();
        _unactiveHard.deleteIt();
        _bg = null;
    }

}

