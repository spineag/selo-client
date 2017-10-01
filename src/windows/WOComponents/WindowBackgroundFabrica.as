/**
 * Created by andy on 8/31/17.
 */
package windows.WOComponents {
import flash.geom.Rectangle;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;

import utils.DrawToBitmap;

public class WindowBackgroundFabrica extends Sprite {
    private var g:Vars = Vars.getInstance();

    public function WindowBackgroundFabrica(w:int, h:int, hT:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        if (w%2) w++;
        if (h%2) h++;
        var s:Sprite = new Sprite();

// TOP PART
        //top left
        im = new Image(tex.getTexture('plants_factory_b_panel_c_top'));
        im.x = -w/2 - 10;
        im.y = -h/2 - 10;
        s.addChild(im);

        // top right
        im = new Image(tex.getTexture('plants_factory_b_panel_c_top'));
        im.scaleX = -1;
        im.x = w/2 + 10;
        im.y = -h/2 - 10;
        s.addChild(im);

        // top centre
        im = new Image(tex.getTexture('plants_factory_b_panel_top'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 25;
        im.x = -w/2 + 25;
        im.y = -h/2 - 10;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // left centre
        im = new Image(tex.getTexture('plants_factory_b_panel_left'));
        im.tileGrid = new Rectangle();
        im.height = hT - 25 - 10;
        im.x = -w/2 - 10;
        im.y = -h/2 + 25;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // right centre
        im = new Image(tex.getTexture('plants_factory_b_panel_left'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = hT - 25 - 10;
        im.x = w/2 + 10;
        im.y = -h/2 + 25;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // center
        im = new Image(tex.getTexture('plants_factory_b_panel_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 15;
        im.height = hT - 15 - 10;
        im.x = -w/2 + 15;
        im.y = -h/2 + 15;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

// MIDDLE PART
        // left
        im = new Image(tex.getTexture('plants_factory_b_y_panel_left'));
        im.x = -w/2 - 10;
        im.y = -h/2 + hT - 10;
        s.addChildAt(im, 0);

        // right
        im = new Image(tex.getTexture('plants_factory_b_y_panel_left'));
        im.scaleX = -1;
        im.x = w/2 + 10;
        im.y = -h/2 + hT - 10;
        s.addChildAt(im, 0);

        // center
        // top centre
        im = new Image(tex.getTexture('plants_factory_b_y_panel_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 25;
        im.x = -w/2 + 25;
        im.y = -h/2 + hT - 10;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

//  BOTTOM PART
        // left bottom
        im = new Image(tex.getTexture('plants_factory_y_panel_c_bottom'));
        im.x = -w/2 - 10;
        im.y = h/2 - 25;
        s.addChild(im);

        // right bottom
        im = new Image(tex.getTexture('plants_factory_y_panel_c_bottom'));
        im.scaleX = -1;
        im.x = w/2 + 10;
        im.y = h/2 - 25;
        s.addChild(im);

        //bottom centre
        im = new Image(tex.getTexture('plants_factory_y_panel_center_bottom'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 25;
        im.x = -w/2 + 25;
        im.y = h/2 - 25;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // left centre
        im = new Image(tex.getTexture('plants_factory_y_panel_left'));
        im.tileGrid = new Rectangle();
        im.height = h - hT - 25 - 25;
        im.x = -w/2 - 10;
        im.y = -h/2 + hT + 25;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // right centre
        im = new Image(tex.getTexture('plants_factory_y_panel_left'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = h - hT - 25 - 25;
        im.x = w/2 + 10;
        im.y = -h/2 + hT + 25;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // center
        im = new Image(tex.getTexture('plants_factory_y_panel_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 25;
        im.height = h - hT - 25 - 25;
        im.x = -w/2 + 25;
        im.y = -h/2 + hT + 25;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        var s2:Sprite = new Sprite();
        s.x = w/2 + 10;
        s.y = h/2 + 10;
        s2.addChild(s);
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(s2));
        addChild(im);
        im.x = -w/2 - 10;
        im.y = -h/2 - 10;
        s.dispose();
    }

    public function deleteIt():void {
        filter = null;
        dispose();
        g = null;
    }
}
}
