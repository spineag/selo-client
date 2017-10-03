/**
 * Created by andy on 11/5/15.
 */
package windows.WOComponents {
import flash.geom.Rectangle;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;

import utils.DrawToBitmap;

public class BackgroundWhiteIn extends Sprite{
    private var g:Vars = Vars.getInstance();

    public function BackgroundWhiteIn(w:int, h:int) {
        touchable = false;
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var s:Sprite = new Sprite();
        if (w%2) w++;
        if (h%2) h++;

        //top left
        im = new Image(tex.getTexture('order_white_s_panel_corner_top'));
        im.scaleX = -1;
        im.x = 10;
        s.addChild(im);

        // bottom left
        im = new Image(tex.getTexture('order_white_s_panel_corner_bottom'));
        im.y = h - 10;
        s.addChild(im);

        // top right
        im = new Image(tex.getTexture('order_white_s_panel_corner_top'));
        im.x = w - 10;
        s.addChild(im);

        // bottom right
        im = new Image(tex.getTexture('order_white_s_panel_corner_bottom'));
        im.scaleX = -1;
        im.x = w;
        im.y = h-10;
        s.addChild(im);

        // top
        im = new Image(tex.getTexture('order_white_s_panel_center_top'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 10;
        im.x = 10;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // bottom
        im = new Image(tex.getTexture('order_white_s_panel_center_bottom'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 10;
        im.x = 10;
        im.y = h - 8;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // left
        im = new Image(tex.getTexture('order_white_s_panel_center_bottom'));
        im.tileGrid = new Rectangle();
        im.width = h - 2 * 10;
        im.tileGrid = im.tileGrid;
        im.x = 8;
        im.y = 10;
        im.rotation = Math.PI/2;
        s.addChildAt(im, 0);

        // right
        im = new Image(tex.getTexture('order_white_s_panel_center_bottom'));
        im.tileGrid = new Rectangle();
        im.width = h - 2 * 10;
        im.tileGrid = im.tileGrid;
        im.x = w - 8;
        im.y = h - 10;
        im.rotation = -Math.PI/2;
        s.addChildAt(im, 0);

        // center
        im = new Image(tex.getTexture('order_white_s_panel_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 16;
        im.height = h - 16;
        im.x = 8;
        im.y = 10;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(s));
        addChild(im);
        s.dispose();
    }

    public function deleteIt():void {
        filter = null;
        dispose();
        g = null;
    }
}
}
