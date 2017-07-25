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

public class CartonBackground extends Sprite{
    private var g:Vars = Vars.getInstance();

    public function CartonBackground(w:int, h:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var arr:Array = [];

        if (w%2) w++;
        if (h%2) h++;

        //top left
        im = new Image(tex.getTexture('carton_lt'));
        im.x = 0;
        im.y = 0;
        addChild(im);
        arr.push(im);

        // bottom left
        im = new Image(tex.getTexture('carton_ld'));
        im.x = 0;
        im.y = h - im.height;
        addChild(im);
        arr.push(im);

        // top right
        im = new Image(tex.getTexture('carton_rt'));
        im.x = w - im.width;
        im.y = 0;
        addChild(im);
        arr.push(im);

        // bottom right
        im = new Image(tex.getTexture('carton_rd'));
        im.x = w - im.width;
        im.y = h - im.height;
        addChild(im);
        arr.push(im);

        //top center and bottom center and center
        var te:Texture = tex.getTexture('carton_cc');
        im = new Image(te);
        im.tileGrid = new Rectangle();
        im.width = w - arr[0].width - arr[2].width;
        im.height = h;
        im.x = arr[0].width;
        im.y = 0;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);
        if (g.socialNetworkID != SocialNetworkSwitch.SN_VK_ID) {
            // double image to fix artifacts
            im = new Image(te);
            im.tileGrid = new Rectangle();
            im.width = w - arr[0].width - arr[2].width + 6;
            im.height = h;
            im.x = arr[0].width - 3;
            im.y = 0;
            im.tileGrid = im.tileGrid;
            addChildAt(im, 0);
        }

        // left
        im = new Image(te);
        im.tileGrid = new Rectangle();
        im.width = arr[0].width;
        im.height = h - arr[0].height - arr[1].height;
        im.x = 0;
        im.y = arr[0].height;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        // right
        im = new Image(te);
        im.tileGrid = new Rectangle();
        im.width = arr[0].width;
        im.height = h - arr[0].height - arr[1].height;
        im.x = w - arr[2].width;
        im.y = arr[0].height;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);

        arr.length = 0;
        touchable = false;
    }

    public function deleteIt():void {
        filter = null;
        dispose();
        g = null;
    }
}
}
