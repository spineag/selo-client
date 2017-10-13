/**
 * Created by andy on 11/13/15.
 */
package windows.orderWindow {
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.utils.Align;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

public class WOOrderResourceItem {
    public var source:CSprite;
    private var _check:Image;
    private var _countTxt:CTextField;
    private var _countTxtNeed:CTextField;
    private var _image:Image;
    private var _id:int;
    private var _onHover:Boolean;
    private var g:Vars = Vars.getInstance();

    public function WOOrderResourceItem() {
        source = new CSprite();
        _onHover = false;
        _check = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
        _check.x = 15;
        _check.y = -36;
        _check.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_check);
        _check.visible = false;

        _countTxt = new CTextField(80, 40, "10");
        _countTxt.setFormat(CTextField.BOLD24, 22, ManagerFilters.WINDOW_STROKE_BLUE_COLOR,  Color.WHITE);
        _countTxt.alignH = Align.RIGHT;
        _countTxt.y = 12;
        _countTxt.x = -53;
        source.addChild(_countTxt);
        _countTxtNeed = new CTextField(80, 40, "/10");
        _countTxtNeed.setFormat(CTextField.BOLD24, 22, ManagerFilters.WINDOW_STROKE_BLUE_COLOR, Color.WHITE);
        _countTxtNeed.alignH = Align.LEFT;
        _countTxtNeed.y = 12;
        _countTxtNeed.x = 27;
        source.addChild(_countTxtNeed);
        source.hoverCallback = onHover;
        source.outCallback = outCallback;
        source.visible = false;
    }

    public function clearIt():void {
        _check.visible = false;
        source.visible = false;
        if (_image && source.contains(_image)) {
            source.removeChild(_image);
            _image.dispose();
            _image = null;
        }
        _countTxt.text = '';
    }

    public function fillIt(id:int, count:int):void {
        var obj:Object = g.allData.getResourceById(id);
        if (!obj) {
            Cc.error('WOOrderResourceItem:: no resource for id: ' + id);
            _countTxt.text = '0/0';
            _check.visible = true;
            _id = 0;
            source.visible = true;
            return;
        }
        _id = id;
        if (obj.buildType == BuildType.PLANT) _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(obj.imageShop + '_icon'));
            else _image = new Image(g.allData.atlas[obj.url].getTexture(obj.imageShop));
        MCScaler.scale(_image, 80, 80);
        _image.alignPivot();
        source.addChildAt(_image, 0);
        var curCount:int = g.userInventory.getCountResourceById(id);
        _countTxt.text = String(curCount);
        _countTxtNeed.text = '/' + String(count);
        if (curCount >= count) {
            _countTxt.changeTextColor = ManagerFilters.BLUE_COLOR;
        } else  _countTxt.changeTextColor = ManagerFilters.RED_TXT_NEW;
        _check.visible = curCount >= count;
        source.visible = true;
    }

    public function isChecked():Boolean { return _check.visible; }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        g.resourceHint.showIt(_id, source.x - source.width/2, source.y - source.height/2, source);
    }

    private function outCallback():void {
        if (!_onHover) return;
        _onHover = false;
        g.resourceHint.hideIt();
    }

    public function deleteIt():void {
        if (!source) return;
        if (_countTxt) {
            source.removeChild(_countTxt);
            _countTxt.deleteIt();
            _countTxt = null;
        }
        source.deleteIt();
        _image = null;
        _check = null;
        source = null;
    }
}
}