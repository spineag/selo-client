/**
 * Created by user on 3/26/18.
 */
package windows.partyWindow {
import flash.geom.Rectangle;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;

import utils.DrawToBitmap;

public class BackgroundPartyLight extends Sprite {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;

    public function BackgroundPartyLight(w:int, h:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['partyAtlas'];
        _source = new Sprite();
        addChild(_source);
        var s:Sprite = new Sprite();

        if (w%2) w++;
        if (h%2) h++;

        //top left
        im = new Image(tex.getTexture('ne_light_p_corner_top'));
        im.x = -5;
        im.y = -4;
        s.addChild(im);

        // bottom left
        im = new Image(tex.getTexture('ne_light_p_corner_bottom'));
        im.scaleX = -1;
        im.x = 13;
        im.y = h - 10.5;
        s.addChild(im);

        // top right
        im = new Image(tex.getTexture('ne_light_p_corner_top'));
        im.scaleX = -1;
        im.x = w + 5;
        im.y = -4;
        s.addChild(im);

        // bottom right
        im = new Image(tex.getTexture('ne_light_p_corner_bottom'));
        im.x = w - 13;
        im.y = h - 10;
        s.addChild(im);

        // top
        im = new Image(tex.getTexture('ne_light_p_top'));
        im.tileGrid = new Rectangle();
        im.width = w - 2*12;
        im.x = 12;
        im.y = -4;
        im.tileGrid = im.tileGrid;
        s.addChild(im);

        // bottom
        im = new Image(tex.getTexture('ne_light_p_bottom'));
        im.tileGrid = new Rectangle();
        im.width = w - 2*13;
        im.x = 13;
        im.y = h - 8;
        im.tileGrid = im.tileGrid;
        s.addChild(im);

        // left
        im = new Image(tex.getTexture('ne_light_p_left'));
        im.tileGrid = new Rectangle();
        im.height = h - 13 - 10;
        im.x = -5;
        im.y = 13;
        im.tileGrid = im.tileGrid;
        s.addChild(im);

        // right
        im = new Image(tex.getTexture('ne_light_p_left'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = h - 13 - 10;
        im.x = w + 5;
        im.y = 13;
        im.tileGrid = im.tileGrid;
        s.addChild(im);

        // center
        im = new Image(tex.getTexture('ne_light_p_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 8;
        im.height = h - 8;
        im.x = 4;
        im.y = 4;
        im.tileGrid = im.tileGrid;
        s.addChild(im);

        var s2:Sprite = new Sprite();
        s.x = 5;
        s.y = 4;
        s2.addChild(s);
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(s2));
        s2.dispose();
        im.x = -5;
        im.y = -4;
        _source.addChild(im);
        _source.touchable = false;
    }

    public function get source():Sprite { return _source; }

    public function deleteIt():void {
        filter = null;
        dispose();
    }
}
}
