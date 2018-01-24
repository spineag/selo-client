/**
 * Created by user on 1/10/18.
 */
package windows.salePack.saleVauchers {
import data.BuildType;

import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;
import starling.utils.Color;

import utils.CTextField;
import utils.MCScaler;

public class WOSalePackVauchersItem {
    public var source:Sprite;
    private var _txtCount:CTextField;
    private var _txtName:CTextField;
    private var _objectId:int = 0;
    private var _objectType:int = 0;
    private var _objectCount:int = 0;
    private var g:Vars = Vars.getInstance();

    public function WOSalePackVauchersItem(objectId:int = 0, objectType:int = 0, objectCount:int = 0) {
        _objectId = objectId;
        _objectType = objectType;
        _objectCount = objectCount;
        source = new Sprite();
        var im:Image;
        im = new Image(g.allData.atlas['saleAtlas'].getTexture('vaucher_windows_cell'));
        source.addChild(im);
        _txtCount = new CTextField(171, 40, '');
        _txtCount.setFormat(CTextField.BOLD30, 26, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtCount.y = 100;
        _txtCount.x = 14;
        if (objectId == 5) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone'));
            _txtCount.text = String(_objectCount);
        } else if (objectId == 6) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone'));
            _txtCount.text = String(_objectCount);
        } else if (objectId == 7) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone'));
            _txtCount.text = String(_objectCount);
        } else if (objectId == 8) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone'));
            _txtCount.text = String(_objectCount);
        }
        im.x = 60 - im.width/2;
        im.y = 70 - im.height/2;
        source.addChild(im);
        source.addChild(_txtCount);
    }
}
}
