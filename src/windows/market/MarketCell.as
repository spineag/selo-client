/**
 * Created by user on 6/17/15.
 */
package windows.market {
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.WhiteBackgroundIn;
import windows.WindowsManager;

public class MarketCell {
    public var source:CSprite;
    public var _cont:Sprite;
    private var _info:Object; // id & count
    private var _data:Object;
    private var _image:Image;
    private var _countTxt:CTextField;
    private var g:Vars = Vars.getInstance();
    private var _clickCallback:Function;
//    private var _carton:WhiteBackgroundIn;
    private var _bg:Image;

    public function MarketCell(info:Object) {
        _clickCallback = null;
        source = new CSprite();
        _cont = new Sprite();
        source.addChild(_cont);
        source.endClickCallback = onClick;
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_yellow_cell'));
        _cont.addChild(_bg);

        _info = info;
        if (!_info) {
            Cc.error('MarketCell:: _info == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketCell');
            return;
        }
        _data = g.allData.getResourceById(_info.id);
        if (_data) {
            if (_data.buildType == BuildType.PLANT) {
                _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
            } else {
                _image = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
            }
            if (!_image) {
                Cc.error('MarketCell:: no such image: ' + _data.imageShop);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketCell');
                return;
            }
            MCScaler.scale(_image, 100, 100);
            _image.x = 60 - _image.width/2;
            _image.y = 60 - _image.height/2;
            _cont.addChild(_image);
        } else {
            Cc.error('MarketCell:: _data == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketCell');
            return;
        }

        _countTxt = new CTextField(80,30,String(g.userInventory.getCountResourceById(_data.id)));
        _countTxt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _countTxt.cacheIt = false;
        _countTxt.alignH = Align.RIGHT;
        _countTxt.x = 25;
        _countTxt.y = 82;
        _cont.addChild(_countTxt);
    }

    public function set clickCallback(f:Function):void {
        _clickCallback = f;
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_info.id]);
        }
        if (g.userInventory.getCountResourceById(_data.id))
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_info.id]);
        }
        activateIt(true);
    }

    public function activateIt(a:Boolean):void {
        if (a) _cont.filter = ManagerFilters.YELLOW_STROKE;
         else _cont.filter = null;
    }

    public function deleteIt():void {
        source.removeChild(_cont);
        if (_countTxt) {
            _cont.removeChild(_countTxt);
            _countTxt.deleteIt();
            _countTxt = null;
        }
        _clickCallback = null;
        _info = null;
        _data = null;
        _image = null;
        source.dispose();
        source = null;
    }
}
}
