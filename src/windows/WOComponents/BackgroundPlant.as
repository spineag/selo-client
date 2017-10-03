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

public class BackgroundPlant extends Sprite{
    private var g:Vars = Vars.getInstance();

    public function BackgroundPlant(w:int, h:int) {
        touchable = false;
        var im:Image;
        var s:Sprite = new Sprite();
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        if (w%2) w++;
        if (h%2) h++;

        //top left
        im = new Image(tex.getTexture('windows_plants_y_panel_corner_top'));
        im.x = -11;
        im.y = -11;
        s.addChild(im);

        // bottom left
        im = new Image(tex.getTexture('windows_plants_y_panel_corner_bottom'));
        im.x = -11;
        im.y = h - 35 + 11;
        s.addChild(im);

        // top right
        im = new Image(tex.getTexture('windows_plants_y_panel_corner_top'));
        im.scaleX = -1;
        im.x = w + 11;
        im.y = -11;
        s.addChild(im);

        // bottom right
        im = new Image(tex.getTexture('windows_plants_y_panel_corner_bottom'));
        im.scaleX = -1;
        im.x = w + 11;
        im.y = h - 35 + 11;
        s.addChild(im);

        // top
        im = new Image(tex.getTexture('windows_plants_y_panel_top'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * (35 - 11);
        im.x = 35 - 11;
        im.y = -11;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // bottom
        im = new Image(tex.getTexture('windows_plants_y_panel_bottom'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * (35 - 11);
        im.x = 35 - 11;
        im.y = h - 35 + 11;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);

        // left
        im = new Image(tex.getTexture('windows_plants_y_panel_right'));
        im.tileGrid = new Rectangle();
        im.height = h - 2 * (35 - 11);
        im.tileGrid = im.tileGrid;
        im.x = -11;
        im.y = 35-11;
        s.addChildAt(im, 0);

        // right
        im = new Image(tex.getTexture('windows_plants_y_panel_right'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = h - 2 * (35 - 11);
        im.tileGrid = im.tileGrid;
        im.x = w + 11;
        im.y = 35 - 11;
        s.addChildAt(im, 0);

        // center
        im = new Image(tex.getTexture('windows_plants_y_panel_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 2*(35 -11);
        im.height = h - 2*(35 - 11);
        im.x = 35 - 11;
        im.y = 35 - 11;
        im.tileGrid = im.tileGrid;
        s.addChildAt(im, 0);
        
        var s2:Sprite = new Sprite();
        s.x = 11;
        s.y = 11;
        s2.addChild(s);
        im = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(s2));
        addChild(im);
        im.x = -11;
        im.y = -11;
        s.dispose();
    }

    public function deleteIt():void {
        filter = null;
        dispose();
        g = null;
    }
}
}
