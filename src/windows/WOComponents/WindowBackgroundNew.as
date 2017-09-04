/**
 * Created by andy on 8/31/17.
 */
package windows.WOComponents {
import flash.geom.Rectangle;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;

public class WindowBackgroundNew extends Sprite {
    private var g:Vars = Vars.getInstance();

    public function WindowBackgroundNew(w:int, h:int, hT:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        if (w%2) w++;
        if (h%2) h++;
        if (hT%2) hT++;

    // blue part
        //top left
        im = new Image(tex.getTexture('fs_blue_panel_corner_top'));
        im.x = -w/2 - 9;
        im.y = -h/2 - 8;
        addChild(im);

        // top right
        im = new Image(tex.getTexture('fs_blue_panel_corner_top'));
        im.scaleX = -1;
        im.x = w/2 + 9;
        im.y = -h/2 - 8;
        addChild(im);

        // top centre
        im = new Image(tex.getTexture('fs_blue_panel_top'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 23;
        im.x = -w/2 + 23;
        im.y = -h/2 - 9;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // left centre
        im = new Image(tex.getTexture('fs_blue_panel_left'));
        im.tileGrid = new Rectangle();
        im.height = hT - 25;
        im.x = -w/2 - 10;
        im.y = -h/2 + 25;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // right centre
        im = new Image(tex.getTexture('fs_blue_panel_left'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = hT - 25;
        im.x = w/2 + 10;
        im.y = -h/2 + 25;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // center
        im = new Image(tex.getTexture('fs_blue_panel_center'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 10;
        im.height = hT - 11;
        im.x = -w/2 + 10;
        im.y = -h/2 + 11;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

     // milk part
        // left bottom
        im = new Image(tex.getTexture('fs_white_panel_corner_bottom'));
        im.x = -w/2 - 9;
        im.y = h/2 - 26;
        addChild(im);

        // right bottom
        im = new Image(tex.getTexture('fs_white_panel_corner_bottom'));
        im.scaleX = -1;
        im.x = w/2 + 9;
        im.y = h/2 - 26;
        addChild(im);

        //bottom centre
        im = new Image(tex.getTexture('fs_white_panel_bottom'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 23;
        im.x = -w/2 + 23;
        im.y = h/2 - 12;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // left centre
        im = new Image(tex.getTexture('fs_white_panel_left'));
        im.tileGrid = new Rectangle();
        im.height = h - hT - 26;
        im.x = -w/2 - 10;
        im.y = -h/2 + hT;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // right centre
        im = new Image(tex.getTexture('fs_white_panel_left'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = h - hT - 26;
        im.x = w/2 + 10;
        im.y = -h/2 + hT;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // center
        im = new Image(tex.getTexture('fs_white_panel_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 10;
        im.height = h - hT - 12;
        im.x = -w/2 + 10;
        im.y = -h/2 + hT;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);
    }

    public function deleteIt():void {
        filter = null;
        dispose();
        g = null;
    }
}
}
