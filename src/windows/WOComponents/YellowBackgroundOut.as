/**
 * Created by andy on 11/5/15.
 */
package windows.WOComponents {
import flash.geom.Rectangle;

import manager.Vars;

import social.SocialNetworkSwitch;

import starling.display.BlendMode;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class YellowBackgroundOut extends Sprite{
    private var g:Vars = Vars.getInstance();

    public function YellowBackgroundOut(w:int, h:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];

        if (w%2) w++;
        if (h%2) h++;

        //top left
        im = new Image(tex.getTexture('fs_yellow_panel_corner_top'));
        im.x = -5;
        im.y = -4;
        addChild(im);

        // bottom left
        im = new Image(tex.getTexture('fs_yellow_panel_corner_bottom'));
        im.scaleX = -1;
        im.x = 13;
        im.y = h - 10.5;
        addChild(im);

        // top right
        im = new Image(tex.getTexture('fs_yellow_panel_corner_top'));
        im.scaleX = -1;
        im.x = w + 5;
        im.y = -4;
        addChild(im);

        // bottom right
        im = new Image(tex.getTexture('fs_yellow_panel_corner_bottom'));
        im.x = w - 13;
        im.y = h - 10;
        addChild(im);

        // top
        im = new Image(tex.getTexture('fs_yellow_panel_top'));
        im.tileGrid = new Rectangle();
        im.width = w - 2*12;
        im.x = 12;
        im.y = -4;
        im.tileGrid = im.tileGrid;
        addChild(im);

        // bottom
        im = new Image(tex.getTexture('fs_yellow_panel_bottom'));
        im.tileGrid = new Rectangle();
        im.width = w - 2*13;
        im.x = 13;
        im.y = h - 8;
        im.tileGrid = im.tileGrid;
        addChild(im);

        // left
        im = new Image(tex.getTexture('fs_yellow_panel_left'));
        im.tileGrid = new Rectangle();
        im.height = h - 13 - 10;
        im.x = -5;
        im.y = 13;
        im.tileGrid = im.tileGrid;
        addChild(im);

        // right
        im = new Image(tex.getTexture('fs_yellow_panel_left'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = h - 13 - 10;
        im.x = w + 5;
        im.y = 13;
        im.tileGrid = im.tileGrid;
        addChild(im);

        // center
        im = new Image(tex.getTexture('fs_yellow_panel_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 8;
        im.height = h - 8;
        im.x = 4;
        im.y = 4;
        im.tileGrid = im.tileGrid;
        addChild(im);

        touchable = false;
    }

    public function deleteIt():void {
        filter = null;
        dispose();
        g = null;
    }
}
}
