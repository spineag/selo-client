/**
 * Created by user on 4/4/18.
 */
package windows.miniPartyWindow {
import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import utils.CTextField;
import utils.MCScaler;

public class WOMiniPartyItem {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _parent:Sprite;
    private var im:Image;
    private var _txt:CTextField;

    public function WOMiniPartyItem(id:int, type:int, index:int, p:Sprite) {
        _parent = p;

        switch (type) {
            case BuildType.RESOURCE:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(id).imageShop));
                break;
            case BuildType.PLANT:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(id).imageShop + '_icon'));
                break;
            case 2:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                break;
            case 1:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                break;
            case BuildType.DECOR:
                im = new Image(g.allData.atlas['decorAtlas'].getTexture(g.allData.getBuildingById(id).image));
                break;
            case BuildType.INSTRUMENT:
                im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(id).imageShop));
                break;

        }
        MCScaler.scale(im, 95, 95);
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source = new Sprite();
        _source.addChild(im);

        switch (index) {
            case 0:
                _source.x = 0;
                _source.y = -87;
                break;
            case 1:
                _source.x = 85;
                _source.y = -30;
                _source.rotation = (Math.PI/5)*(index+1);
                break;
            case 2:
                _source.x = 55;
                _source.y = 65;
                _source.rotation = (Math.PI/4)*(index+1);
                break;
            case 3:
                _source.x = -57;
                _source.y = 73;
                _source.rotation = (Math.PI/3)*(index+1);
                break;
            case 4:
                _source.x = -90;
                _source.y = -30;
                _source.rotation = -1.5;
                break;

        }

        _parent.addChild(_source);
    }
}
}
