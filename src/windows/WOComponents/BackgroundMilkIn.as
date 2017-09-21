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

public class BackgroundMilkIn extends Sprite{
    private var g:Vars = Vars.getInstance();

    public function BackgroundMilkIn(w:int, h:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        if (w%2) w++;
        if (h%2) h++;

        //top left
        im = new Image(tex.getTexture('white_milk_panel_r_corner_top'));
        im.scaleX = -1;
        im.x = 10;
        addChild(im);

        // bottom left
        im = new Image(tex.getTexture('white_milk_panel_l_corner_bottom'));
        im.y = h - 10;
        addChild(im);

        // top right
        im = new Image(tex.getTexture('white_milk_panel_r_corner_top'));
        im.x = w - 10;
        addChild(im);

        // bottom right
        im = new Image(tex.getTexture('white_milk_panel_l_corner_bottom'));
        im.scaleX = -1;
        im.x = w;
        im.y = h-10;
        addChild(im);

        // top
        im = new Image(tex.getTexture('white_milk_panel_center_top'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 10;
        im.x = 10;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // bottom
        im = new Image(tex.getTexture('white_milk_panel_center_bottom'));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * 10;
        im.x = 10;
        im.y = h - 10;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // left
        im = new Image(tex.getTexture('white_milk_panel_center_bottom'));
        im.tileGrid = new Rectangle();
        im.width = h - 2 * 10;
        im.tileGrid = im.tileGrid;
        im.x = 10;
        im.y = 10;
        im.rotation = Math.PI/2;
        addChildAt(im, 0);

        // right
        im = new Image(tex.getTexture('white_milk_panel_center_bottom'));
        im.tileGrid = new Rectangle();
        im.width = h - 2 * 10;
        im.tileGrid = im.tileGrid;
        im.x = w - 10;
        im.y = h - 10;
        im.rotation = -Math.PI/2;
        addChildAt(im, 0);

        // center
        im = new Image(tex.getTexture('white_milk_panel_center'));
        im.tileGrid = new Rectangle();
        im.width = w - 20;
        im.height = h - 20;
        im.x = 10;
        im.y = 10;
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
