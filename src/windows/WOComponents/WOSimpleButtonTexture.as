/**
 * Created by andy on 1/21/16.
 */
package windows.WOComponents {
import flash.geom.Rectangle;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureAtlas;
import utils.CButton;
import utils.DrawToBitmap;

public class WOSimpleButtonTexture  extends Sprite {
    private var g:Vars = Vars.getInstance();

    public function WOSimpleButtonTexture(w:int, h:int, _type:int) {
        var im:Image;
        var tex:TextureAtlas = g.allData.atlas['interfaceAtlas'];
        var imLeft:String;
        var imCenter:String;
        var dX:int = 0;
        var dY:int = 0;
        var dW:int;

        if (w%2) w++;
        switch (_type) {
            case CButton.GREEN:
                if (h < 41) {
                    h = 40; // !!!
                    imLeft = 'fs_green_button_big_left';
                    imCenter = 'fs_green_button_big_center';
                    dX = -5;
                    dY = -3;
                } else if (h < 45) {
                    h = 42; // !!!
                    imLeft = 'silo_green_button_big_left';
                    imCenter = 'silo_green_button_big_center';
                    dX = -5;
                    dY = -3;
                } else {
                    h = 53; // !!!
                    imLeft = 'shop_green_button_left';
                    imCenter = 'shop_green_button_center';
                }
                break;
            case CButton.ORANGE:
                h = 35; // !!!
                imLeft = 'shop_yellow_button_left';
                imCenter = 'shop_yellow_button_center';
                break;
        }

        //left
        im = new Image(tex.getTexture(imLeft));
        im.x = dX;
        im.y = dY;
        dW = im.width + dX;
        addChild(im);

        //right
        im = new Image(tex.getTexture(imLeft));
        im.scaleX = -1;
        im.x = w - dX;
        im.y = dY;
        addChild(im);

        //center
        im = new Image(tex.getTexture(imCenter));
        im.tileGrid = new Rectangle();
        im.width = w - 2 * dW;
        im.x = dW;
        im.y = dY;
        im.tileGrid = im.tileGrid;
        addChildAt(im, 0);
    }

    public function deleteIt():void { dispose(); }
}
}
