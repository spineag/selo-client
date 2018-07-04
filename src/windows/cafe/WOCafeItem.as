/**
 * Created by user on 4/25/18.
 */
package windows.cafe {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.BackgroundWhiteIn;

import windows.WOComponents.BackgroundYellowOut;

public class WOCafeItem {
    public var source:Sprite;
    private var _srcQuad:CSprite;
    private var _imBg:BackgroundWhiteIn;
    private var g:Vars = Vars.getInstance();
    private var _txtName:CTextField;
    private var _imResource:Image;
    private var _imageResource1:Image;
    private var _imageResource2:Image;
    private var _data:Object;
    private var _isHover:Boolean;
    private var _imPlus:Image;
    private var _callback:Function;
    private var _number:int = 0;

    public function WOCafeItem(data:Object, clickCallback:Function, number:int) {
        _data = data;
        _callback = clickCallback;
        _number = number;
        source = new CSprite();

        _imBg = new BackgroundWhiteIn(120,120);
        _imBg.touchable = true;
        source.addChild(_imBg);
        _imResource = new Image(g.allData.atlas['resourceAtlas'].getTexture(data.imageShop));
        source.addChild(_imResource);
        _imResource.x = 10;
        _imResource.y = 15;
        _txtName = new CTextField(100,30, data.name);
        _txtName.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_LIGHT_NEW);
        _txtName.x = 8;
        _txtName.touchable = true;
        source.addChild(_txtName);
        _imageResource1 = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_data.ingredientsId[0]).imageShop));
        MCScaler.scale(_imageResource1,50,50);
        _imageResource1.x = 5;
        _imageResource1.y = 40;
        _imageResource1.visible = false;
        source.addChild(_imageResource1);

        _imageResource2 = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_data.ingredientsId[1]).imageShop));
        _imageResource2.x = 65;
        _imageResource2.y = 40;
        MCScaler.scale(_imageResource2,50,50);
        _imageResource2.visible = false;
        source.addChild(_imageResource2);
        _imPlus = new Image(g.allData.atlas['interfaceAtlas'].getTexture('caffee_window_plus'));
        MCScaler.scale(_imPlus,20,20);
        _imPlus.x = 50;
        _imPlus.y = 57;
        source.addChild(_imPlus);
        _imPlus.visible = false;
        _isHover = false;

        _srcQuad = new CSprite();
        var quad:Quad = new Quad(120,120,Color.WHITE);
        quad.alpha = 0;
        _srcQuad.addChild(quad);
        source.addChild(_srcQuad);
        _srcQuad.endClickCallback = onClick;
        _srcQuad.hoverCallback = onHover;
        _srcQuad.outCallback = onOut;
    }

    private function onClick():void {
        onOut();
        if (_callback != null) {
            _callback.apply(null,[_number]);
        }
    }

    private function onHover():void {
        if (_isHover) return;
        _isHover = true;
        _imResource.visible = false;
        _txtName.text = 'Ингредиенты';
        _imageResource2.visible = true;
        _imPlus.visible = true;
        _imageResource1.visible = true;
    }

    private function onOut():void {
        if (!_isHover) return;
        _imageResource2.visible = false;
        _imageResource1.visible = false;
        _imPlus.visible = false;
        _txtName.text = _data.name;
        _imResource.visible = true;
        _isHover = false;
    }
}
}
