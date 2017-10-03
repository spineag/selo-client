/**
 * Created by user on 11/27/15.
 */
package windows.WOComponents {
import flash.geom.Rectangle;

import manager.ManagerFilters;
import manager.Vars;

import starling.display.BlendMode;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.textures.TextureAtlas;
import starling.utils.Color;

import utils.CTextField;
import utils.DrawToBitmap;

public class HintBackground extends Sprite {
    public static const NONE_TRIANGLE:int = 1;
    public static const SMALL_TRIANGLE:int = 2;
    public static const LONG_TRIANGLE:int = 3;
    public static const BIG_TRIANGLE:int = 4;

    public static const LEFT_TOP:int = 5;
    public static const LEFT_CENTER:int = 6;
    public static const LEFT_BOTTOM:int = 7;
    public static const TOP_LEFT:int = 8;
    public static const TOP_CENTER:int = 9;
    public static const TOP_RIGHT:int = 10;
    public static const RIGHT_TOP:int = 11;
    public static const RIGHT_CENTER:int = 12;
    public static const RIGHT_BOTTOM:int = 13;
    public static const BOTTOM_LEFT:int = 14;
    public static const BOTTOM_CENTER:int = 15;
    public static const BOTTOM_RIGHT:int = 16;

    private var _txt:CTextField;
    private var _width:int;
    private var _height:int;
    private var _bg:Sprite;
    public var inSprite:Sprite;
    private var g:Vars = Vars.getInstance();

    public function HintBackground(wt:int, ht:int, typeTriangle:int = NONE_TRIANGLE, trianglePosition:int = 0) {
        var te:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        if (wt%2) wt++;
        _width = wt;
        _height = ht;

        if (_height <= 42) _height = 42;
        else if (_height <= 67) _height = 67;

        _bg = new Sprite();
        if (_height == 42) create_S_BG(_width, te);
            else if (_height == 67) create_B_BG(_width, te);
            else createBG(_width, _height, te);

        if (typeTriangle == NONE_TRIANGLE) {
            addChild(_bg);
        } else {
            var im:Image;
            var h:int = 29;
            if (typeTriangle == SMALL_TRIANGLE) im = new Image(te.getTexture('center_part_top_b_hint'));
            else if (typeTriangle == LONG_TRIANGLE) im = new Image(te.getTexture('center_part_top_m_hint'));
            else if (typeTriangle == BIG_TRIANGLE) im = new Image(te.getTexture('center_part_top_b_hint'));
            im.pivotX = im.width/2;
            im.pivotY = im.height;
            switch (trianglePosition) {
                case TOP_LEFT:
                    im.scaleY = -1;
                    _bg.x = int(-16 - im.width/2);
                    _bg.y = h;
                    break;
                case TOP_CENTER:
                    im.scaleY = -1;
                    _bg.x = int(-_width/2);
                    _bg.y = h;
                    break;
                case TOP_RIGHT:
                    im.scaleY = -1;
                    _bg.x = int(-_width+16+im.width/2);
                    _bg.y = h;
                    break;
                case BOTTOM_LEFT:
                    _bg.x = int(-16-im.width/2);
                    _bg.y = int(-h-_height);
                    break;
                case BOTTOM_CENTER:
                    _bg.x = int(-_width/2);
                    _bg.y = int(-h-_height);
                    break;
                case BOTTOM_RIGHT:
                    _bg.x = int(-_width+16+im.width/2);
                    _bg.y = int(-h-_height);
                    break;
                case LEFT_TOP:
                    im.rotation = Math.PI/2;
                    _bg.x = h;
                    _bg.y = int(-16-im.height/2);
                    break;
                case LEFT_CENTER:
                    im.rotation = Math.PI/2;
                    _bg.x = h;
                    _bg.y = int(-ht/2);
                    break;
                case LEFT_BOTTOM:
                    im.rotation = Math.PI/2;
                    _bg.x = h;
                    _bg.y = int(-_height+16+im.height/2);
                    break;
                case RIGHT_TOP:
                    im.rotation = -Math.PI/2;
                    _bg.x = int(-h-_width);
                    _bg.y = int(-16-im.height/2);
                    break;
                case RIGHT_CENTER:
                    im.rotation = -Math.PI/2;
                    _bg.x = int(-h-_width);
                    _bg.y = int(-_height/2);
                    break;
                case RIGHT_BOTTOM:
                    im.rotation = -Math.PI/2;
                    _bg.x = int(-h-_width);
                    _bg.y = int(-_height+16+im.height/2);
                    break;
            }
            addChild(im);
            addChildAt(_bg, 0);
        }

        inSprite = new Sprite();
        inSprite.x = _bg.x;
        inSprite.y = _bg.y;
        addChild(inSprite);
    }

    private function create_S_BG(w:int, tex:TextureAtlas):void {
        var im:Image;
        var sp:Sprite = new Sprite();

        // left
        im = new Image(tex.getTexture('left_part_s_hint'));
        im.x = -10;
        im.y = -11;
        sp.addChild(im);
        // right
        im = new Image(tex.getTexture('left_part_s_hint'));
        im.scaleX = -1;
        im.x = w + 10;
        im.y = -11;
        sp.addChild(im);
        // center
        im = new Image(tex.getTexture('c_part_s_hint'));
        im.tileGrid = new Rectangle();
        im.width = w - (30-10)*2;
        im.x = 30-10;
        im.y = -11;
        im.tileGrid = im.tileGrid;
        sp.addChildAt(im, 0);

        var s2:Sprite = new Sprite();
        sp.x = 10;
        sp.y = 11;
        s2.addChild(sp);
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(s2));
        addChild(im);
        im.x = -10;
        im.y = -11;
        s2.dispose();
        _bg.addChild(im);
    }

    private function create_B_BG(w:int, tex:TextureAtlas):void {
        var im:Image;
        var sp:Sprite = new Sprite();

        // left
        im = new Image(tex.getTexture('left_part_b_hint'));
        im.x = -11;
        im.y = -11;
        sp.addChild(im);
        // right
        im = new Image(tex.getTexture('left_part_b_hint'));
        im.scaleX = -1;
        im.x = w + 11;
        im.y = -11;
        sp.addChild(im);
        // center
        im = new Image(tex.getTexture('c_part_b_hint'));
        im.tileGrid = new Rectangle();
        im.width = w - (30-11)*2;
        im.x = 30-11;
        im.y = -11;
        im.tileGrid = im.tileGrid;
        sp.addChildAt(im, 0);

        var s2:Sprite = new Sprite();
        sp.x = 11;
        sp.y = 11;
        s2.addChild(sp);
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(s2));
        addChild(im);
        im.x = -11;
        im.y = -11;
        s2.dispose();
        _bg.addChild(im);
    }

    private function createBG(w:int, h:int, tex:TextureAtlas):void {
        var im:Image;
        var sp:Sprite = new Sprite();

        //top left
        im = new Image(tex.getTexture('corner_right_top_s_hint'));
        im.scaleX = -1;
        im.x = 30 - 11;
        im.y = -11;
        sp.addChild(im);

        // bottom left
        im = new Image(tex.getTexture('corner_right_bottom_s_hint'));
        im.scaleX = -1;
        im.x = 30 - 11;
        im.y = h - 30 + 11;
        sp.addChild(im);

        // top right
        im = new Image(tex.getTexture('corner_right_top_s_hint'));
        im.x = w - im.width + 11;
        im.y = -11;
        sp.addChild(im);

        // bottom right
        im = new Image(tex.getTexture('corner_right_bottom_s_hint'));
        im.x = w - 30 + 11;
        im.y = h - 30 + 11;
        sp.addChild(im);

        // top center
        im = new Image(tex.getTexture('center_top_s_hint'));
        im.tileGrid = new Rectangle();
        im.width = w - (30-11)*2;
        im.x = 30-11;
        im.y = -11;
        im.tileGrid = im.tileGrid;
        sp.addChildAt(im, 0);
        // bottom center
        im = new Image(tex.getTexture('center_bottom_s_hint'));
        im.tileGrid = new Rectangle();
        im.width = w - (30-11)*2;
        im.x = 30-11;
        im.y = h - 30 + 11;
        im.tileGrid = im.tileGrid;
        sp.addChildAt(im, 0);

        // left
        im = new Image(tex.getTexture('center_right_s_hint'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = h - (30-11)*2;
        im.x = 19;
        im.y = 30-11;
        im.tileGrid = im.tileGrid;
        sp.addChildAt(im, 0);
        // right
        im = new Image(tex.getTexture('center_right_s_hint'));
        im.tileGrid = new Rectangle();
        im.height = h - (30-11)*2;
        im.x = w-19;
        im.y = 30-11;
        im.tileGrid = im.tileGrid;
        sp.addChildAt(im, 0);

        im = new Image(tex.getTexture('center_hint'));
        im.tileGrid = new Rectangle();
        im.width = w - (30-11)*2;
        im.height = h - (30-11)*2;
        im.x = 30-11;
        im.y = 30-11;
        im.tileGrid = im.tileGrid;
        sp.addChildAt(im, 0);

        var s2:Sprite = new Sprite();
        sp.x = 11;
        sp.y = 11;
        s2.addChild(sp);
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(s2));
        addChild(im);
        im.x = -11;
        im.y = -11;
        s2.dispose();
        _bg.addChild(im);
    }

    public function addShadow():void { _bg.filter = ManagerFilters.SHADOW_LIGHT; }
    public function setText(st:String):void { _txt.text = st; }

    public function flipTxt(v:Boolean):void {
        if (!v) {
            _txt.x = _bg.x + 5;
            _txt.y = _bg.y + 5;
            _txt.scale = 1;
        } else {
            _txt.x = _bg.x + _bg.width - 5;
            _txt.y = _bg.y + _bg.height - 5;
            _txt.scale = -1;
        }
    }

    public function addTextField(size:int):void {
        deleteTextField();
        var s:String;
        if (size >= 20) s = CTextField.BOLD24;
            else if (size > 14) s = CTextField.BOLD18;
            else s = CTextField.BOLD18;
        _txt = new CTextField(_width - 10, _height - 20,'');
        _txt.setFormat(s, size, ManagerFilters.BLUE_COLOR);
        _txt.x = _bg.x + 5;
        _txt.y = _bg.y + 5;
        addChild(_txt);
    }

    private function deleteTextField():void {
        if (_txt) {
            removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
    }

    public function deleteIt():void {
        deleteTextField();
        dispose();
        _bg = null;
        inSprite = null;
    }
}
}
