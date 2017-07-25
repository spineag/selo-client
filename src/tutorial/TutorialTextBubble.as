/**
 * Created by andy on 3/3/16.
 */
package tutorial {
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

public class TutorialTextBubble {
    public static var SMALL:int = 1;
    public static var MIDDLE:int = 2;
    public static var BIG:int = 3;
    public static var SMALL_ORDER:int = 4;

    private var _source:Sprite;
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _isFlip:Boolean;
    private var _type:int;
    private var _im:Image;
    private var _txt:CTextField;

    public function TutorialTextBubble(p:Sprite) {
        _parent = p;
        _isFlip = false;
        _source = new Sprite();
        _parent.addChild(_source);
    }

    public function setXY(_x:int, _y:int):void {
        _source.x = _x;
        _source.y = _y;
    }

    public function showBubble(st:String, isFlip:Boolean, type:int):void {
        _isFlip = isFlip;
        _type = type;
        createBubble(st);
    }

    private function createBubble(st:String):void {
        switch (_type) {
            case BIG:
                _txt = new CTextField(278, 180, st);
                _txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
                _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_1'));
                if (_isFlip) {
                    _im.x = -12;
                    _im.y = -210;
                    _txt.x = 62;
                    _txt.y = -178;
                } else {
                    _im.scaleX = -1;
                    _im.x = 12;
                    _im.y = -210;
                    _txt.x = -334;
                    _txt.y = -178;
                }
                break;
            case MIDDLE:
                _txt = new CTextField(278, 180, st);
                _txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
                _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_2'));
                _txt.height = 134;
                if (_isFlip) {
                    _im.x = -12;
                    _im.y = -169;
                    _txt.x = 67;
                    _txt.y = -135;
                } else {
                    _im.scaleX = -1;
                    _im.x = 12;
                    _im.y = -169;
                    _txt.x = -333;
                    _txt.y = -135;
                }
                break;
            case SMALL:
                _txt = new CTextField(278, 180, st);
                _txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
                _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_3'));
                _txt.height = 90;
                if (_isFlip) {
                    _im.x = -15;
                    _im.y = -116;
                    _txt.x = 60;
                    _txt.y = -85;
                } else {
                    _im.scaleX = -1;
                    _im.x = 15;
                    _im.y = -116;
                    _txt.x = -335;
                    _txt.y = -85;
                }
                break;
            case SMALL_ORDER:
                _txt = new CTextField(210   , 180, st);
                _txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_4'));
                _txt.height = 90;
                if (_isFlip) {
                    _im.x = -15;
                    _im.y = -116;
                    _txt.x = 20;
                    _txt.y = -100;
                } else {
                    _im.scaleX = -1;
                    _im.x = 15;
                    _im.y = -116;
                    _txt.x = -335;
                    _txt.y = -85;
                }
                break;
        }
        _source.addChild(_im);
        _source.addChild(_txt);
    }

    public function clearIt():void {
        _source.removeChild(_txt);
        if (_txt) _txt.dispose();
        _txt = null;
        _source.removeChild(_im);
        if (_im) _im.dispose();
        _im = null;
    }

    public function deleteIt():void {
        if (_parent && _parent.contains(_source)) _parent.removeChild(_source);
        if (_source) _source.dispose();
        if (_txt) {
            _txt.deleteIt();
            _txt = null;
        }
        _source = null;
        _parent = null;
    }

}
}
