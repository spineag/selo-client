/**
 * Created by user on 7/23/15.
 */
package windows.cave {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.ManagerFilters;
import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.WindowMine;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyCave extends WindowMain {
    private var _btn:CButton;
    private var _txt:CTextField;
    private var _priceTxt:CTextField;
    private var _callback:Function;
    private var _dataObject:Object;
    private var _nameImage:String;

    public function WOBuyCave() {
        super();
        _windowType = WindowsManager.WO_BUY_CAVE;
        _callbackClickBG = hideIt;
        _btn = new CButton();
        _btn.addButtonTexture(250, 35, CButton.BLUE, true);
        _btn.y = 165;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        MCScaler.scale(im,25,25);
        im.x = 215;
        im.y = 7;
        _btn.addChild(im);
        _priceTxt = new CTextField(217, 30, '');
        _priceTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _priceTxt.y = 5;
        _btn.addChild(_priceTxt);
        _source.addChild(_btn);
        _btn.clickCallback = onClickBuy;
        _txt = new CTextField(300, 30, '');
        _txt.setFormat(CTextField.BOLD18, 18, Color.WHITE);
        _txt.x = -150;
        _txt.y = -20;
        _source.addChild(_txt);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + _nameImage].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var im:Image;
        im = new Image(tex);
        im.x = -im.width/2;
        im.y = -im.height/2;
        _woWidth = im.width;
        _woHeight = im.height;
        createExitButton(hideIt);
        _source.addChildAt(im,0);
        super.showIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _dataObject = params[0];
        _callback = callback;
        _btn.visible = true;
        var st:String;
        switch (params[2]) {
            case 'cave':
                _priceTxt.text = String(g.managerLanguage.allTexts[443]) + String(_dataObject.cost);
                st = g.dataPath.getGraphicsPath();
                _nameImage = 'imageWindows/mine_window.png';
                g.load.loadImage(st + 'imageWindows/mine_window.png',onLoad);
                break;
            case 'house':
                _btn.visible = false;
                st = g.dataPath.getGraphicsPath();
                _nameImage = 'imageWindows/hobbit_house_window.png';
                g.load.loadImage(st + 'imageWindows/hobbit_house_window.png',onLoad);
                break;
            case 'train':
                _priceTxt.text = String(g.managerLanguage.allTexts[443]) + String(_dataObject.cost);
                st = g.dataPath.getGraphicsPath();
                _nameImage = 'imageWindows/aerial_tram_window.png';
                g.load.loadImage(st + 'imageWindows/aerial_tram_window.png',onLoad);
                break;
        }
    }
    
    private function onClickBuy(callob:Object = null, cost:int = 0):void {
        if (g.user.softCurrencyCount < _dataObject.cost) {
            var ob:Object = {};
            ob.currency = 2;
            ob.count = _dataObject.cost - g.user.softCurrencyCount;
            g.windowsManager.cashWindow = this;
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClickBuy, 'money', ob);
            return;
        }
        if (_callback != null) {
            _callback.apply();
        }
        if (isCashed) {
            g.windowsManager.uncasheWindow();
        } else {
            hideIt();
        }
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        if (_priceTxt) {
            _btn.removeChild(_priceTxt);
            _priceTxt.deleteIt();
            _priceTxt = null;
        }
        if (_btn) _source.removeChild(_btn);
        if (_btn) _btn.deleteIt();
        if (_btn) _btn = null;
        if (_dataObject) _dataObject = null;
        if (_nameImage) _nameImage = '';
        super.deleteIt();
    }

    override public function releaseFromCash():void {
        isCashed = false;
        deleteIt();
    }
}
}
