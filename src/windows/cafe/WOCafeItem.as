/**
 * Created by user on 4/25/18.
 */
package windows.cafe {
import manager.Vars;

import starling.display.Image;

import utils.CSprite;
import utils.CTextField;

public class WOCafeItem {
    public var source:CSprite;
    private var _imBg:Image;
    private var g:Vars = Vars.getInstance();
    private var _txtName:CTextField;
    private var _imResource:Image;

    public function WOCafeItem() {
        source = new CSprite();
        _imBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_yellow_cell'));
        source.addChild(_imBg);
        _imResource = new Image(g.allData.atlas['resourceAtlas'].getTexture('berry_yogurt_icon'));
        source.addChild(_imResource);
        _imResource.x = 10;
        _imResource.y = 10;
    }
}
}
