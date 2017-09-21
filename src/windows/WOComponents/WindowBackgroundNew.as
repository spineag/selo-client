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

public class WindowBackgroundNew extends Sprite {
    private var g:Vars = Vars.getInstance();

    public function WindowBackgroundNew(w:int, h:int, hT:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        if (w%2) w++;
        if (h%2) h++;
        if (hT%2) hT++;
        var s:Sprite = new Sprite();

// TOP PART
        var str:String;
        if (hT > 0) str = 'fs_blue';
        else {
            str = 'fs_white';
            hT = 10;
        }
    // blue part
        //top left
        im = new Image(tex.getTexture(str + '_panel_corner_top'));
        im.x = -w / 2 - 9;
        im.y = -h / 2 - 8;
        s.addChild(im);

        // top right
        im = new Image(tex.getTexture(str + '_panel_corner_top'));
        im.scaleX = -1;
        im.x = w / 2 + 9;
        im.y = -h / 2 - 8;
        s.addChild(im);

        // top centre
        if (str == 'fs_blue') im = new Image(tex.getTexture(str + '_panel_top'));
            else im = new Image(tex.getTexture(str + '_panel_c_top'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 23;
        im.x = -w / 2 + 23;
        im.y = -h / 2 - 9;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // left centre
        im = new Image(tex.getTexture(str + '_panel_left'));
        im.tileGrid = new Rectangle();
        im.height = hT - 25;
        im.x = -w / 2 - 10;
        im.y = -h / 2 + 25;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // right centre
        im = new Image(tex.getTexture(str + '_panel_left'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = hT - 25;
        im.x = w / 2 + 10;
        im.y = -h / 2 + 25;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // center
        im = new Image(tex.getTexture(str + '_panel_center'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 10;
        im.height = hT - 11;
        im.x = -w / 2 + 10;
        im.y = -h / 2 + 11;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

// MILK BOTTOM PART
        // left bottom
        im = new Image(tex.getTexture('fs_white_panel_corner_bottom'));
        im.x = -w/2 - 9;
        im.y = h/2 - 26;
        s.addChild(im);

        // right bottom
        im = new Image(tex.getTexture('fs_white_panel_corner_bottom'));
        im.scaleX = -1;
        im.x = w/2 + 9;
        im.y = h/2 - 26;
        s.addChild(im);

        //bottom centre
        im = new Image(tex.getTexture('fs_white_panel_bottom'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 23;
        im.x = -w/2 + 23;
        im.y = h/2 - 12;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // left centre
        im = new Image(tex.getTexture('fs_white_panel_left'));
        im.tileGrid = new Rectangle();
        im.height = h - hT - 26;
        im.x = -w/2 - 10;
        im.y = -h/2 + hT;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // right centre
        im = new Image(tex.getTexture('fs_white_panel_left'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = h - hT - 26;
        im.x = w/2 + 10;
        im.y = -h/2 + hT;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // center
        im = new Image(tex.getTexture('fs_white_panel_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 10;
        im.height = h - hT - 12;
        im.x = -w/2 + 10;
        im.y = -h/2 + hT;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        var s2:Sprite = new Sprite();
        s.x = w/2 + 9;
        s.y = h/2 + 8;
        s2.addChild(s);
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(s2));
        addChild(im);
        im.x = -w/2 - 9;
        im.y = -h/2 - 8;
        s.dispose();
    }

    public function deleteIt():void {
        filter = null;
        dispose();
        g = null;
    }
}
}
