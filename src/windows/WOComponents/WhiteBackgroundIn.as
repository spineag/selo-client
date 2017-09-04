/**
 * Created by andy on 11/5/15.
 */
package windows.WOComponents {
import flash.geom.Rectangle;
import manager.Vars;

import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class WhiteBackgroundIn extends Sprite{
    private var g:Vars = Vars.getInstance();

    public function WhiteBackgroundIn(w:int, h:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];

        if (w%2) w++;
        if (h%2) h++;

        //top left
        im = new Image(tex.getTexture('fs_white_panel_corner_bottom'));
        im.scaleY = -1;
        im.x = -10;
        im.y = 24;
        addChild(im);

        // bottom left
        im = new Image(tex.getTexture('fs_white_panel_corner_bottom'));
        im.x = -10;
        im.y = h - 24;
        addChild(im);

        // top right
        im = new Image(tex.getTexture('fs_white_panel_corner_bottom'));
        im.scale = -1;
        im.x = w + 10;
        im.y = 24;
        addChild(im);

        // bottom right
        im = new Image(tex.getTexture('fs_white_panel_corner_bottom'));
        im.scaleX = -1;
        im.x = w + 10;
        im.y = h - 24;
        addChild(im);

        // top
        im = new Image(tex.getTexture('fs_white_panel_bottom'));
        im.scaleY = -1;
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 24;
        im.x = 24;
        im.y = 10;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // bottom
        im = new Image(tex.getTexture('fs_white_panel_bottom'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 24;
        im.x = 24;
        im.y = h - 10;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // left
        im = new Image(tex.getTexture('fs_white_panel_left'));
        im.tileGrid = new Rectangle();
        im.height = h - 2 * 24;
        im.x = -11;
        im.y = 24;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // right
        im = new Image(tex.getTexture('fs_white_panel_left'));
        im.scaleX = -1;
        im.tileGrid = new Rectangle();
        im.height = h - 2 * 24;
        im.x = w + 11;
        im.y = 24;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // center
        im = new Image(tex.getTexture('fs_white_panel_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 18;
        im.height = h - 18;
        im.x = 9;
        im.y = 9;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        touchable = false;
    }

    public function deleteIt():void {
        filter = null;
        dispose();
        g = null;
    }
}
}
